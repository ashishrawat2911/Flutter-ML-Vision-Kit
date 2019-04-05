import 'dart:io';

import 'package:firebase_ml_vision_example/Constant.dart';
import 'package:firebase_ml_vision_example/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ML Kit Demo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Expandable("Barcode scanning", BARCODE_SCANNER,
                "assets/images/barcode_scanning.png"),
            Expandable("Face detection", FACE_SCANNER,
                "assets/images/face_detection.png"),
            Expandable("label Detection", LABEL_SCANNER,
                "assets/images/image_labeling.png"),
            Expandable("label Detection", LABEL_SCANNER_CLOUD,
                "assets/images/image_labeling.png"),
            Expandable("Text recognition (OCR)", TEXT_SCANNER,
                "assets/images/text_recognition.png"),
          ],
        ),
      ),
    );
  }
}

class Expandable extends StatelessWidget {
  Expandable(this.name, this.detector, this.asset);
  final String name;
  final String detector;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        leading: Icon(Icons.ac_unit),
        title: Text(
          name,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      children: [
        Center(
          child: Column(
            children: <Widget>[
              Image.asset(asset),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      onPickImageSelected(detector, "camera", context);
                    },
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                  MaterialButton(
                    onPressed: () {
                      onPickImageSelected(detector, "gallery", context);
                    },
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void onPickImageSelected(
      String detector, String resourcePicker, BuildContext context) async {
    ImageSource imageSource;
    if (resourcePicker == "camera") {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    try {
      final File file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(
                    imageFile: file,
                  )));
    } catch (e) {
      print(e);
    }
  }
}
