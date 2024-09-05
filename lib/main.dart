import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() => runApp(WasteSorterApp());

class WasteSorterApp extends StatefulWidget {
  @override
  _WasteSorterAppState createState() => _WasteSorterAppState();
}

class _WasteSorterAppState extends State<WasteSorterApp> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> captureImage() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      final image = await controller.takePicture();
      // For now, we'll just show the image path
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayCapturedImage(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WasteSorter'),
        ),
        body: Center(
          child: isCameraInitialized
              ? Column(
            children: [
              Container(
                height: 400,
                width: 300,
                child: CameraPreview(controller),
              ),
              ElevatedButton(
                onPressed: captureImage,
                child: Text('Capture'),
              ),
            ],
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class DisplayCapturedImage extends StatelessWidget {
  final String imagePath;

  DisplayCapturedImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            SizedBox(height: 20),
            Text('Classified as: Recycling'),  // Mocked classification result
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
