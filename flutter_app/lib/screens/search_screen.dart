import 'dart:async';
import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/destination_service.dart';

enum SearchStatus { loading, success, empty, error }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _service = DestinationService();
  final _controller = TextEditingController();
  Timer? _debounce;
  int _requestId = 0;

  SearchStatus _status = SearchStatus.loading;
  List<Destination> _results = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // Wait 400ms after the user stops typing before searching
  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> _search(String query) async {
    final id = ++_requestId;
    setState(() => _status = SearchStatus.loading);

    try {
      final results = await _service.search(query);
      // Ignore old responses if a newer search has started
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = results;
        _status = results.isEmpty ? SearchStatus.empty : SearchStatus.success;
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() => _status = SearchStatus.error);
    }
  }

  Widget _buildBody() {
    switch (_status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return const _MessageView(
          icon: Icons.search_off,
          title: 'No results',
          message: 'Try a different destination or province.',
        );
      case SearchStatus.error:
        return _MessageView(
          icon: Icons.wifi_off,
          title: 'Something went wrong',
          message: 'Please check your connection and try again.',
          actionLabel: 'Retry',
          onAction: () {
            _controller.clear();
            _search('');
          },
        );
      case SearchStatus.success:
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _results.length,
          itemBuilder: (context, index) =>
              _DestinationCard(destination: _results[index]),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              controller: _controller,
              hintText: 'Search destination or province',
              leading: const Icon(Icons.search),
              onChanged: _onChanged,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Destination destination;

  const _DestinationCard({required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.place, color: theme.colorScheme.primary),
        ),
        title: Text(destination.name),
        subtitle: Text(
          '${destination.province}  •  ★ ${destination.rating}\n'
              '${destination.description}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${destination.pricePerDay}',
                style: theme.textTheme.titleMedium),
            Text('per day', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageView({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}