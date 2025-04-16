import 'package:flutter/material.dart';
import '../models/blog_post.dart';

class BlogPostDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogPostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Debug print to check the content
    print('Blog post content: ${post.content}');

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.photoMain.isNotEmpty)
              Image.network(
                post.photoMain,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFE5E7EB),
                    height: 200,
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ) ??
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Published on: ${post.publishedDate}',
              style:
                  Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey) ??
                  const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            post.content.isNotEmpty
                ? Text(
                  post.content,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 16) ??
                      const TextStyle(fontSize: 16),
                )
                : const Text(
                  'No content available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
          ],
        ),
      ),
    );
  }
}
