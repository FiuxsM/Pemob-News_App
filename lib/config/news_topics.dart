/// Satu pilihan kata kunci di halaman utama. Semuanya dimuat lewat `/search`.
class NewsTopic {
  final String id;
  final String label;
  final String query;

  const NewsTopic({required this.id, required this.label, required this.query});
}

class NewsTopics {
  NewsTopics._();

  static const List<NewsTopic> all = [
    NewsTopic(id: 'terbaru', label: 'Terbaru', query: 'teknologi'),
    NewsTopic(id: 'ai', label: 'AI', query: '"kecerdasan buatan" OR AI'),
    NewsTopic(id: 'gadget', label: 'Gadget', query: 'smartphone OR gadget'),
    NewsTopic(id: 'startup', label: 'Startup', query: 'startup'),
    NewsTopic(id: 'siber', label: 'Keamanan Siber', query: '"keamanan siber" OR siber'),
    NewsTopic(id: 'game', label: 'Game', query: 'game OR esports'),
    NewsTopic(id: 'jaringan', label: 'Internet & 5G', query: 'internet OR 5G'),
  ];
}
