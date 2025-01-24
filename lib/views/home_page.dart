import 'package:blog_app/viewmodels/blog_viewmodel.dart';
import 'package:blog_app/views/create_blog_page.dart';
import 'package:blog_app/views/view_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch blogs when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogViewModel>().fetchBlogs();
    });
  }

  // Helper method to show only the first few words of the content
  String _getPreviewContent(String content) {
    final words = content.split(' ');
    if (words.length > 10) {
      return '${words.take(10).join(' ')}...'; // Show first 10 words
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<BlogViewModel>().fetchBlogs(),
          ),
        ],
      ),
      body: Consumer<BlogViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.blogsList.isEmpty) {
            return Center(child: Text('No blogs available.'));
          }

          return ListView.builder(
            itemCount: viewModel.blogsList.length,
            itemBuilder: (context, index) {
              final blog = viewModel.blogsList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(blog.title),
                  subtitle: Text(_getPreviewContent(blog.content)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await viewModel.deleteBlog(blog.id);
                    },
                  ),
                  onTap: () {
                    // Navigate to ViewBlogPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewBlogPage(blog: blog),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CreateBlogPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateBlogPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
