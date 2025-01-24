class Blog {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Blog(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
