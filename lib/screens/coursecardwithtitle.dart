import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gitgo/constants/app_constants.dart';

class CourseGridSectionTitle extends StatelessWidget {
  final String title = 'Learn. Code. Master.';
  final List<String> courseNames = ['Git', 'Java', 'Python'];
  final List<String> imagePath = [
    'assets/git.png',
    'assets/java.png',
    'assets/python.png'
  ];

  final List<Color> courseColors = [Colors.white, Colors.white, Colors.yellow];
  Shader linearGradient = const LinearGradient(
    colors: [Colors.purple, Colors.blue],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Learn Today. Lead Tomorrow.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = linearGradient,
              ),
            )

            // Text(
            //   title,
            //   style: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black87,
            //   ),
            // ),
            ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(courseNames.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CourseCard(
                    courseName: courseNames[index],
                    color: courseColors[index % courseColors.length],
                    imagePath: imagePath[index],
                    isEnabled: courseNames[index] ==
                        'Git', // Enable only Linux course
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final Color color;
  final String imagePath;
  final bool isEnabled;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.color,
    required this.imagePath,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // No elevation since we are using a shadow for the glow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: isEnabled
            ? () {
                Navigator.pushNamed(context, '/explore');
              }
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: [
              // Glowing border effect using shadow
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5), // Glowing border color
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              // Glassmorphism effect with blur and semi-transparent overlay
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  width: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagePath,
                          height: 80,
                          fit: BoxFit.contain,
                          color: isEnabled
                              ? null
                              : Colors.grey, // Grey out disabled images
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          isEnabled ? courseName : 'Upcoming',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isEnabled ? Colors.black87 : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (isEnabled)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/sessionPage',
                                arguments: {'groupKey': RoadmapItems.basic},
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(color),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(80, 30)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Learn',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
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
