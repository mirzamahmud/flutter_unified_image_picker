import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_unified_image_picker/flutter_unified_image_picker.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Picker Pro',
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Image Preview'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CameraView()),
          );

          if (result != null) {
            setState(() {
              imagePath = result;
            });
          }
        },
        child: Icon(Icons.camera),
      ),
      body: Center(
        child:
            imagePath != null
                ? Image.file(File(imagePath!), fit: BoxFit.contain)
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error),
                    const SizedBox(height: 8),
                    Text('No Image Found'),
                  ],
                ),
      ),
    );
  }
}
