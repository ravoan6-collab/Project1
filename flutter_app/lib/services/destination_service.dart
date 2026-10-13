import '../models/destination.dart';

class DestinationService {
  static const _all = [
    Destination(
      id: '1',
      name: 'Angkor Wat',
      province: 'Siem Reap',
      description: 'The largest religious monument in the world.',
      rating: 4.9,
      pricePerDay: 40,
    ),
    Destination(
      id: '2',
      name: 'Bayon Temple',
      province: 'Siem Reap',
      description: 'Famous for its giant smiling stone faces.',
      rating: 4.8,
      pricePerDay: 35,
    ),
    Destination(
      id: '3',
      name: 'Royal Palace',
      province: 'Phnom Penh',
      description: 'The royal residence in the capital city.',
      rating: 4.6,
      pricePerDay: 25,
    ),
    Destination(
      id: '4',
      name: 'Koh Rong',
      province: 'Sihanoukville',
      description: 'Island with white sand beaches and clear water.',
      rating: 4.7,
      pricePerDay: 60,
    ),
    Destination(
      id: '5',
      name: 'Bokor National Park',
      province: 'Kampot',
      description: 'Mountain park with old colonial ruins.',
      rating: 4.5,
      pricePerDay: 30,
    ),
    Destination(
      id: '6',
      name: 'Kep Crab Market',
      province: 'Kep',
      description: 'Fresh seafood by the sea.',
      rating: 4.4,
      pricePerDay: 20,
    ),
  ];

  Future<List<Destination>> search(String query) async {
    // Fake network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Type "error" in the search box to test the error state
    if (query.trim().toLowerCase() == 'error') {
      throw Exception('Network error');
    }

    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _all;

    return _all
        .where((d) =>
    d.name.toLowerCase().contains(q) ||
        d.province.toLowerCase().contains(q))
        .toList();
  }
}