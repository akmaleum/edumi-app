class BlogPost {
  final String id;
  final String title;
  final String summary;
  final String category;
  final String content;
  final String photoMain;
  final String publishedDate;
  final bool isPublished;

  BlogPost({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.content,
    required this.photoMain,
    required this.publishedDate,
    required this.isPublished,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      category: json['category'] as String? ?? '',
      content: json['content'] as String? ?? '',
      photoMain: json['photo_main'] as String? ?? '',
      publishedDate: json['published_date'] as String? ?? '',
      isPublished: json['is_published'] == '1',
    );
  }
}
