import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isConnected = true;

  final String _apiKey = 'AIzaSyA9ejnBH-ZMI0zQFDHk9GTQ3cH5aPHGi0U';

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _loadMessages();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesJson = prefs.getString('chat_messages');
    if (messagesJson != null) {
      setState(() {
        _messages = (jsonDecode(messagesJson) as List)
            .map((item) => Map<String, String>.from(item))
            .toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_messages', jsonEncode(_messages));
  }

  Future<void> _sendMessage() async {
    String message = _controller.text.trim();

    if (message.isNotEmpty) {
      setState(() {
        _messages.add({"role": "user", "parts": message});
        _isLoading = true;
        _controller.clear();
      });

      String botResponse = await _getBotResponse(message);

      setState(() {
        _messages.add({"role": "model", "parts": botResponse});
        _isLoading = false;
      });

      _saveMessages();
    }
  }

  Future<String> _getBotResponse(String userMessage) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey');

    // Preparar el historial de mensajes en el formato correcto
    List<Map<String, dynamic>> formattedMessages = _messages.map((message) {
      return {
        "role": message["role"],
        "parts": [
          {"text": message["parts"]}
        ]
      };
    }).toList();

    // Añadir el mensaje actual del usuario
    formattedMessages.add({
      "role": "user",
      "parts": [
        {"text": userMessage}
      ]
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": formattedMessages,
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('candidates') && data['candidates'].isNotEmpty) {
          String botMessage =
              data['candidates'][0]['content']['parts'][0]['text']?.trim() ??
                  'No response from bot';
          return botMessage;
        } else {
          return 'No candidates available in response';
        }
      } catch (e) {
        return 'Error parsing response: $e';
      }
    } else {
      return "Error: ${response.statusCode} ${response.body}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Establece el color de fondo general de la pantalla
      backgroundColor: const Color(0xFF0D1B2A), // Azul oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A), // Azul oscuro
        elevation: 0,
        toolbarHeight: 150, // Ajusta la altura según sea necesario
        flexibleSpace: const Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal
              const Text(
                'ChatBot - IA',
                style: TextStyle(
                  color: Color.fromARGB(255, 101, 192, 40),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Fila con logotipo y textos
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logotipo
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('asset/img/uplogo.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 10),
                  // Textos
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Francisco de Jesus Escobar Gutierrez',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Universidad Politécnica de Chiapas',
                          style: TextStyle(
                            color: Color.fromARGB(255, 9, 137, 77),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              // Añade padding alrededor de la lista de mensajes
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = _messages[index]['role'] == 'user';
                  return Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0, // Mayor padding vertical
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? const Color(
                                0xFF1E2A38) // Color para mensajes de usuario
                            : const Color(
                                0xFF013220), // Verde tipo consola para el bot
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        _messages[index]['parts']!,
                        style: TextStyle(
                          color:
                              isUserMessage ? Colors.white : Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(9.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Envía un mensaje...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .greenAccent, // Color del borde cuando está activo
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .green, // Color del borde cuando está enfocado
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E2A38),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Color.fromARGB(255, 101, 192, 40)),
                  onPressed: _isConnected
                      ? _sendMessage
                      : null, // Desactiva si no hay internet
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
