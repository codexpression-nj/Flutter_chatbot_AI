import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(chatProvider.messages[index]),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<ChatProvider>(context, listen: false)
                          .sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatProvider with ChangeNotifier {
  List<String> _messages = [];

  List<String> get messages => _messages;

  void sendMessage(String message) async {
    _messages.add('You: $message');
    notifyListeners();

    // Here, you'll call the Gemini API to get the response
    String response = await getChatbotResponse(message);
    _messages.add('Bot: $response');
    notifyListeners();
  }

  Future<String> getChatbotResponse(String message) async {
    // Make an HTTP request to the Gemini API
    // For demonstration, we'll use a mock response
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: '');
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    print(response.text);
    final data = response.text;

    await Future.delayed(Duration(seconds: 2)); // simulate network delay
    return '$data';
  }
}
