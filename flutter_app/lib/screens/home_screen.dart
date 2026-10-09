import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBar(
            hintText: 'Search destination',
            leading: const Icon(Icons.search),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.temple_buddhist),
              title: const Text('Angkor Wat'),
              subtitle: const Text('Siem Reap'),
              trailing: FilledButton(
                onPressed: () {},
                child: const Text('Book'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}