import 'package:blog_app/models/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch all blogs, ordered by creation date in descending order
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
      // Handle any errors that occur during the fetch operation
      throw Exception('Failed to fetch blogs: $e');
    }
  }

  // Add a new blog post
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
      // Handle any errors that occur during the insert operation
      throw Exception('Failed to add blog: $e');
    }
  }

  // Update an existing blog post
  Future<void> updateBlog(String id, String title, String content) async {
    try {
      await supabase.from('blogs').update({
        'title': title,
        'content': content,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', id);
    } catch (e) {
      // Handle any errors that occur during the update operation
      throw Exception('Failed to update blog: $e');
    }
  }

  // Delete a blog post by ID
  Future<void> deleteBlog(String id) async {
    try {
      await supabase.from('blogs').delete().eq('id', id);
    } catch (e) {
      // Handle any errors that occur during the delete operation
      throw Exception('Failed to delete blog: $e');
    }
  }

  // Fetch a single blog post by ID
  Future<Blog?> fetchBlogById(String id) async {
    try {
      final response =
          await supabase.from('blogs').select().eq('id', id).single();

      return Blog.fromJson(response);
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      throw Exception('Failed to fetch blog by ID: $e');
    }
  }
}
