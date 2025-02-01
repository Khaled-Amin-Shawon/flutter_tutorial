import 'package:flutter/material.dart';

class TextCompressorApp extends StatelessWidget {
  const TextCompressorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      home: const TextCompressorScreen(),
    );
  }
}

class TextCompressorScreen extends StatefulWidget {
  const TextCompressorScreen({super.key});

  @override
  State<TextCompressorScreen> createState() => _TextCompressorScreenState();
}

class _TextCompressorScreenState extends State<TextCompressorScreen> {
  String inputText = "";
  final int maxLength = 10;

  /// Function to compress text if it exceeds a specified length
  String compressText(String text) {
    if (text.length <= maxLength) return text;

    // Extract first part and append "..."
    String firstPart = text.substring(0, maxLength - 3);
    return '$firstPart...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Compressor Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type something...',
                labelText: "Enter text",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Compressed Text:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              compressText(inputText),
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
