import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gitgo/constants/AppColors.dart';
import 'package:gitgo/models/code_tip_model.dart';
import 'package:gitgo/screens/code_drawer.dart';
import 'package:gitgo/screens/tips_list_view.dart';
import 'package:gitgo/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PythonListView extends StatefulWidget {
  const PythonListView({super.key});

  @override
  _PythonListViewState createState() => _PythonListViewState();
}

class _PythonListViewState extends State<PythonListView> {
  late Future<List<CodeTipModel>> _tipsFuture;

  @override
  void initState() {
    super.initState();
    _tipsFuture = _loadTips(); // Initialize the future
  }

  Future<List<CodeTipModel>> _loadTips() async {
    final String response = await rootBundle.loadString('assets/linux_100_days_tips.json');
    final List<dynamic> data = json.decode(response)['tips'];
    return data.map((tip) => CodeTipModel(
          day: tip['day'],
          tip: tip['tip'],
          level: tip['level'],
        )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onIconSelected: (int) {},
      ),
      endDrawer: CodeDrawer(),
      body: FutureBuilder<List<CodeTipModel>>(
        future: _tipsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tips'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tips available'));
          }

          // Use the TipsListView widget with loaded tips
          return TipsListView(tips: snapshot.data!);
        },
      ),
    );
  }
}
