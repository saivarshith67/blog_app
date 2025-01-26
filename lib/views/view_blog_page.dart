import 'package:blog_app/models/blog.dart';
import 'package:blog_app/views/update_blog_page.dart';
import 'package:flutter/material.dart';

class ViewBlogPage extends StatelessWidget {
  final Blog blog;

  const ViewBlogPage({required this.blog, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              blog.content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateBlogPage(
                        blog: blog,
                      )));
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
