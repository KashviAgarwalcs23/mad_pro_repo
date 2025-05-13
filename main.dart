import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Add this
import 'package:provider/provider.dart';
import 'package:untitled/models/playlist_provider.dart';
import 'package:untitled/auth/login_page.dart';
import 'package:untitled/themes/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/pages/homepage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Ensure Firebase is initialized
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melodaze',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomePage(); // User is logged in
          } else {
            return LoginPage(); // Not logged in
          }
        },
      ),
    );
  }
}
