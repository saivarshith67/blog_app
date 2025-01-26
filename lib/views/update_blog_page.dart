import 'package:blog_app/models/blog.dart';
import 'package:blog_app/viewmodels/blog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBlogPage extends StatefulWidget {
  final Blog blog;

  const UpdateBlogPage({
    super.key,
    required this.blog,
  });

  @override
  State<UpdateBlogPage> createState() => _UpdateBlogPageState();
}

class _UpdateBlogPageState extends State<UpdateBlogPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _contentController = TextEditingController(text: widget.blog.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogViewModel = context.watch<BlogViewModel>();

    if (blogViewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Blog'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_titleController.text.isEmpty ||
                _contentController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Title and content cannot be empty')),
              );
              return;
            }

            await blogViewModel.updateBlog(
              widget.blog.id,
              _titleController.text,
              _contentController.text,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Blog updated successfully!')),
            );

            Navigator.pop(context); // Go back to the previous page
          },
          child: Icon(Icons.check),
        ),
      );
    }
  }
}
