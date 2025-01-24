import 'package:blog_app/models/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BlogService {
  final supabase = Supabase.instance.client;

  Future<List<Blog>> fetchBlogs() async {
    final response = await supabase
        .from('blogs')
        .select()
        .order('created_at', ascending: false);
    return response.map<Blog>((json) => Blog.fromJson(json)).toList();
  }

  Future<void> addBlog(String title, String content) async {
    await supabase.from('blogs').insert({
      'title': title,
      'content': content,
      'user_id': supabase.auth.currentUser!.id
    });
  }

  Future<void> deleteBlog(String id) async {
    await supabase.from('blogs').delete().eq('id', id);
  }
}
