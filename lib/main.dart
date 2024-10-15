import 'package:flutter/material.dart';
import 'home.page.dart'; // Importa la página de inicio
import 'chat.page.dart'; // Importa la página del chatbot

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatBot-IA',
      theme: ThemeData(
        // Define una paleta de colores personalizada
        primaryColor: const Color(0xFF1E2A38),
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          primary: const Color(0xFF1E2A38),
          secondary: const Color(0xFF4CAF50),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/', // Ruta inicial a la página de inicio
      routes: {
        '/': (context) => const HomePage(), // Página de inicio
        '/chatbot': (context) => const ChatPage(), // Página del chatbot
      },
    );
  }
}
