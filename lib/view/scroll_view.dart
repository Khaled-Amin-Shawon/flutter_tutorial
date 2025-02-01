import 'package:flutter/material.dart';

void main() => runApp(const CarouselTextCompressorApp());

class CarouselTextCompressorApp extends StatelessWidget {
  const CarouselTextCompressorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      home: const TextCompressorCarousel(),
    );
  }
}

class TextCompressorCarousel extends StatefulWidget {
  const TextCompressorCarousel({super.key});

  @override
  State<TextCompressorCarousel> createState() => _TextCompressorCarouselState();
}

class _TextCompressorCarouselState extends State<TextCompressorCarousel> {
  final List<String> texts = [
    "khaledAminShawon",
    "FlutterDevelopment",
    "CarouselExample",
    "DynamicTextCompression",
    "ShortText",
  ];

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
      appBar: AppBar(title: const Text('Text Compressor Carousel')),
      body: ListView.builder(
        itemCount: texts.length,
        itemBuilder: (context, index) {
          String originalText = texts[index];
          String compressedText = compressText(originalText);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Original Text:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      originalText,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Compressed Text:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      compressedText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
