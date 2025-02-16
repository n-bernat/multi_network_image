import 'package:flutter/material.dart';
import 'package:multi_network_image/multi_network_image.dart';

void main() {
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://placehold.co/40/png',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24),
          const Text('Open high-quality image:'),
          const SizedBox(height: 12),
          const Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageButton(
                label: 'NetworkImage (Default)',
                image: NetworkImage(
                  'https://placehold.co/4001/png',
                ),
              ),
              PageButton(
                label: 'MultiNetworkImage',
                image: MultiNetworkImage([
                  'https://placehold.co/4002/png',
                  'https://placehold.co/40/png',
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A button that opens a new page with an image.
class PageButton extends StatelessWidget {
  const PageButton({
    super.key,
    required this.label,
    required this.image,
  });

  final String label;
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => ImagePage(image: image),
        ),
      ),
      child: Text(label),
    );
  }
}

/// A page that displays an image.
class ImagePage extends StatelessWidget {
  const ImagePage({
    super.key,
    required this.image,
  });

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        child: Image(
          image: image,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
