import 'package:gotodone/models/code_tip_model.dart';
import 'package:gotodone/screens/tip_detail_page.dart';
import 'package:flutter/material.dart';

import '../utils/tts_utils';

class TipsListView extends StatelessWidget {
  final List<CodeTipModel> tips;

  TipsListView({required this.tips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Day ${tip.day}: ${tip.tip}'),
            subtitle: Text('Level: ${tip.level}'),
            onTap: () {
              TtsUtils.speak(tip.tip);
              //   Navigator.push(
              //     context,
              //     PageRouteBuilder(
              //       transitionDuration: Duration(milliseconds: 500),
              //       transitionsBuilder:
              //           (context, animation, secondaryAnimation, child) {
              //         const begin = Offset(1.0, 0.0);
              //         const end = Offset.zero;
              //         const curve = Curves.ease;
              //         var tween = Tween(begin: begin, end: end)
              //             .chain(CurveTween(curve: curve));
              //         var offsetAnimation = animation.drive(tween);
              //         return SlideTransition(
              //           position: offsetAnimation,
              //           child: child,
              //         );
              //       },
              //       pageBuilder: (context, animation, secondaryAnimation) =>
              //           TipDetailPage(tip: tips[index]),
              //     ),
              //   );
              // },

              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TipDetailPage(tip: tips[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
