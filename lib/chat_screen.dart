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
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: chatProvider.messages[index],
                      isBot: chatProvider.isBotMessage[index],
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
                  icon: const Icon(Icons.send),
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

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isBot;

  const ChatBubble({super.key, required this.message, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey[200] : const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 16.0, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}

class ChatProvider with ChangeNotifier {
  final List<String> _messages = [];
  final List<bool> _isBotMessage = [];

  List<String> get messages => _messages;
  List<bool> get isBotMessage => _isBotMessage;

  void sendMessage(String message) async {
    _messages.add(message);
    _isBotMessage.add(false);

    notifyListeners();

    String response = await getChatbotResponse(message);
    _messages.add(response);
    _isBotMessage.add(true);

    notifyListeners();
  }

  Future<String> getChatbotResponse(String message) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: '');
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    print(response.text);
    final data = response.text;

    await Future.delayed(const Duration(seconds: 2)); // simulate network delay
    return '$data';
  }
}
