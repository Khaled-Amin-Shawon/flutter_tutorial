import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsFeedPage extends StatelessWidget {
  final List<String> sellerPosts = [
    'https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvdjEwNTctbG9nby0yOF8xLnBuZw.png',
    'https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvdjEwNTctbG9nby0xOV8xLnBuZw.png',
    'https://png.pngtree.com/template/20191219/ourmid/pngtree-abstract-colorful-shirt-logo-vector-cloth-logo-designs-template-image_341456.jpg',
  ];

  final List<Map<String, String>> buyerPosts = [
    {'title': 'Looking for Custom Jackets', 'description': 'Need bulk jackets for my store.'},
    {'title': 'Wedding Dresses Needed', 'description': 'Looking for 5 custom wedding dresses.'},
    {'title': 'Custom T-shirts Order', 'description': 'Want T-shirts with unique prints.'},
  ];

  NewsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Feed - StitchHub'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Seller Business Posts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          CarouselSlider(
            items: sellerPosts.map((post) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: Image.network(post).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              autoPlayInterval: Duration(seconds: 3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Buyer Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: buyerPosts.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      buyerPosts[index]['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(buyerPosts[index]['description']!),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NewsFeedPage(),
  ));
}
