import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotodone/utils/shared_prefs_utils.dart';
import 'package:gotodone/screens/code_drawer.dart';
import 'package:gotodone/screens/coursecardwithtitle.dart';
import 'package:gotodone/screens/text_to_peech_widget.dart';
import 'package:gotodone/widgets/custom_app_bar.dart';
import 'banner_session.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String userName = ''; // Initialize with an empty string
  bool isLoading = true;
  bool showEndOfContent = false;

  final List<Widget> contentWidgets = []; // Store widgets for lazy building

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      String name = await SharedPrefsUtils.getUsername();
      setState(() {
        userName = name;
        isLoading = false;
        _buildContentWidgets(); // Build the list of widgets after loading username
      });
    } catch (e) {
      // Optionally handle the error
      print('Error loading username: $e');
    }
  }

  void _buildContentWidgets() {
    contentWidgets.addAll([
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _buildWelcomeSection(),
        ),
      ),
      const SizedBox(height: 20),
      _buildUserGreeting(),
      const SizedBox(height: 30),
      // SizedBox(
      //   height: MediaQuery.of(context).size.height * 0.4,
      //   child: BannerSection(),
      // ),
      SizedBox(
  height: 300,  // Minimum height to ensure content doesn't break inside
  child: BannerSection(),
),

      const SizedBox(height: 30),
      CourseGridSectionTitle(),
      const SizedBox(height: 50),
      const ScrollableBannerSection(
        banners: [
          {
            'title': 'Understanding Flow Over Syntax Memorization',
            'description':
                'Our goal is to make programming accessible to everyone by emphasizing understanding and logic flow, rather than memorizing syntax.',
          },
          {
            'title': 'Empowering Accessibility: Text-to-Speech Audio Support',
            'description':
                'Enhance your experience with our text-to-speech feature, making content accessible to all users.',
          },
          {
            'title': 'Privacy First: Your Data, Our Priority',
            'description':
                'Our platform prioritizes user privacy and security. As such, we do not retain any user data.',
          },
        ],
      ),
      const SizedBox(height: 30),
      TextToSpeechWidget(),
      const SizedBox(height: 30),
    ]);
  }

  Widget _buildWelcomeSection() {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 20),
              child: child,
            ),
          );
        },
        child: SvgPicture.asset(
          'assets/svg/Welcome-bro.svg',
          height: MediaQuery.of(context).size.height * 0.3,  // Use screen size dynamically
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).textScaleFactor * 20.0,
          ),
          children: [
            const TextSpan(
              text: 'Hello, ',
              style: TextStyle(color: Colors.red),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: '$userName! 👋',
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onIconSelected: (int) {},
      ),
      endDrawer: const CodeDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification &&
                    scrollNotification.metrics.extentAfter == 0.0) {
                  setState(() {
                    showEndOfContent = true;
                  });
                } else if (scrollNotification is ScrollUpdateNotification &&
                    scrollNotification.metrics.extentAfter > 0.0) {
                  setState(() {
                    showEndOfContent = false;
                  });
                }
                return true;
              },
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: contentWidgets.length + 1, // +1 for "End of content"
                  itemBuilder: (context, index) {
                    if (index < contentWidgets.length) {
                      return contentWidgets[index];
                    } else if (showEndOfContent) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'End of content',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
    );
  }
}
