import 'package:blog_app/models/blog.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:flutter/material.dart';

class BlogViewModel extends ChangeNotifier {
  final BlogService _blogService = BlogService();
  bool _isLoading = false;
  List<Blog> _blogsList = [];

  bool get isLoading => _isLoading;

  List<Blog> get blogsList => _blogsList;

  Future<void> fetchBlogs() async {
    _setLoading(true);
    try {
      _blogsList = await _blogService.fetchBlogs();
    } catch (e) {
      debugPrint('Failed to fetch blogs: $e');
      _blogsList = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addBlog(String title, String content) async {
    _setLoading(true);
    try {
      await _blogService.addBlog(title, content);
      await fetchBlogs();
    } catch (e) {
      debugPrint('Failed to add blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateBlog(String id, String title, String content) async {
    _setLoading(true);
    try {
      await _blogService.updateBlog(id, title, content);
      await fetchBlogs();
    } catch (e) {
      debugPrint('Failed to update blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteBlog(String id) async {
    _setLoading(true);
    try {
      await _blogService.deleteBlog(id);
      await fetchBlogs();
    } catch (e) {
      debugPrint('Failed to delete blog: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
