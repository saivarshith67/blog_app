import 'package:blog_app/core/configs/supabase_configs.dart';
import 'package:blog_app/viewmodels/auth_viewmodel.dart';
import 'package:blog_app/views/home_page.dart';
import 'package:blog_app/views/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    anonKey: SupabaseConfig.annonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel()..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          // Handle initial auth state
          if (authVM.currentUser != null) {
            return const HomePage();
          }
          // Add your login page here when ready
          return SignInPage();
        },
      ),
    );
  }
}
