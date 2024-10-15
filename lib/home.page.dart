import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir el enlace de GitHub

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Función para abrir la URL de GitHub
  Future<void> _launchGitHub() async {
    final Uri url =
        Uri.parse('https://github.com/FranEscobarG/chatbot-flutter.git');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define una paleta de colores pastel femenina
    const Color pastelPurple = Color(0xFFE1BEE7);
    const Color pastelPink = Color(0xFFF8BBD0);
    const Color accentGreen = Color(0xFF4CAF50);
    const Color darkBackground = Color(0xFF0D1B2A);
    const Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: darkBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'asset/img/uplogo.jpg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              // Nombre
              const Text(
                'Francisco de Jesús Escobar Gutiérrez',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 9, 137, 77),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Información adicional
              const Text(
                'Ingeniería en Desarrollo de Software',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Programación para Móviles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 9, 137, 77),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                '221193 - 9°A',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              // Botón para ir al Chatbot
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chatbot');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Iniciar ChatBot',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Enlace a GitHub
              GestureDetector(
                onTap: _launchGitHub,
                child: const Text(
                  'Ver repositorio en GitHub',
                  style: TextStyle(
                    color: Color.fromARGB(255, 9, 137, 77),
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
