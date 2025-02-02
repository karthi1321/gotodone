import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DynamicSVGExample extends StatelessWidget {
  final String title;
  final String author;

  DynamicSVGExample({required this.title, required this.author});

  @override
  Widget build(BuildContext context) {
    // Dynamic SVG template
    final svgTemplate = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500">
  <!-- Background -->
  <rect width="500" height="500" fill="#F4F4F4" />
  
  <!-- Book Spine -->
  <rect x="40" y="40" width="60" height="420" fill="#D1E8E4" />

  <!-- Book Cover -->
  <rect x="100" y="40" width="360" height="420" rx="10" fill="#A7C4C4" />

  <!-- Title Rectangle -->
  <rect x="140" y="80" width="280" height="80" rx="10" fill="#F4F4F4" />

  <!-- Title Text -->
  <text x="150" y="130" font-family="Arial, sans-serif" font-size="28" font-weight="bold" fill="#555">
    $title
  </text>

  <!-- Author Rectangle -->
  <rect x="160" y="180" width="240" height="40" rx="10" fill="#D1E8E4" />

  <!-- Author Text -->
  <text x="175" y="205" font-family="Arial, sans-serif" font-size="20" fill="#555">
    $author
  </text>

  <!-- Decoration Lines -->
  <line x1="120" y1="240" x2="380" y2="240" stroke="#F4F4F4" stroke-width="2" />
  <line x1="120" y1="260" x2="380" y2="260" stroke="#F4F4F4" stroke-width="2" />
  <line x1="120" y1="280" x2="380" y2="280" stroke="#F4F4F4" stroke-width="2" />

  <!-- Bottom Decoration -->
  <circle cx="250" cy="400" r="40" fill="#555" />
  <text x="230" y="410" font-family="Arial, sans-serif" font-size="20" fill="#F4F4F4">
    Flutter
  </text>
</svg>
    ''';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic SVG Example"),
      ),
      body: Center(
        child: SvgPicture.string(
          svgTemplate,
          height: 400,
          width: 300,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DynamicSVGExample(
      title: "Dynamic Title",
      author: "Dynamic Author",
    ),
  ));
}
