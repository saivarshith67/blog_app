import 'package:blog_app/models/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await supabase
          .from('blogs')
          .select()
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        return [];
      }

      return response.map<Blog>((json) => Blog.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch blogs: $e');
    }
  }

  Future<void> addBlog(String title, String content) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await supabase.from('blogs').insert({
        'title': title,
        'content': content,
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to add blog: $e');
    }
  }

  Future<void> updateBlog(String id, String title, String content) async {
    try {
      await supabase.from('blogs').update({
        'title': title,
        'content': content,
        'created_at': DateTime.now(),
      }).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update blog: $e');
    }
  }

  Future<void> deleteBlog(String id) async {
    try {
      await supabase.from('blogs').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete blog: $e');
    }
  }

  Future<Blog?> fetchBlogById(String id) async {
    try {
      final response =
          await supabase.from('blogs').select().eq('id', id).single();

      return Blog.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch blog by ID: $e');
    }
  }
}
