import 'package:flutter/material.dart';
import 'package:gemini_ai/chat_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ChatScreen(),
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      ),
    );
  }
}
