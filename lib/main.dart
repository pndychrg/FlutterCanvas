import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:human_canvas/views/update_home_page.dart';
import 'package:human_canvas/models/asset_info_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:human_canvas/constants/constants.dart';
import 'package:human_canvas/views/home_page.dart';
import 'package:human_canvas/widgets/position_input_form.dart';
import 'widgets/custom_draw.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          // backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: UpdatedHomePage(),
          ),
        ),
      ),
    );
  }
}
