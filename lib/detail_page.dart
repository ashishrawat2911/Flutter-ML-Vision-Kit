import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_ml_vision_example/detector_painters.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  DetailPage({this.imageFile});

  final File imageFile;

  @override
  _DetailPageState createState() {
    print(imageFile);
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  Future<Size> imageSize;
  dynamic _scanResults;
  Detector _currentDetector = Detector.text;

  Future<Size> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    );

    final Size imageSize = await completer.future;
    print("Size =====$imageSize");
    return imageSize;
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    dynamic results;
    switch (_currentDetector) {
      case Detector.barcode:
        final BarcodeDetector detector =
            FirebaseVision.instance.barcodeDetector();
        results = await detector.detectInImage(visionImage);
        break;
      case Detector.face:
        final FaceDetector detector = FirebaseVision.instance.faceDetector();
        results = await detector.processImage(visionImage);
        break;
      case Detector.label:
        final LabelDetector detector = FirebaseVision.instance.labelDetector();
        results = await detector.detectInImage(visionImage);
        break;
      case Detector.cloudLabel:
        final CloudLabelDetector detector =
            FirebaseVision.instance.cloudLabelDetector();
        results = await detector.detectInImage(visionImage);
        break;
      case Detector.text:
        final TextRecognizer recognizer =
            FirebaseVision.instance.textRecognizer();
        results = await recognizer.processImage(visionImage);
        break;
      default:
        return;
    }

    setState(() {
      _scanResults = results;
    });
  }

  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter;

    switch (_currentDetector) {
      case Detector.barcode:
        painter = BarcodeDetectorPainter(imageSize, results);
        break;
      case Detector.face:
        painter = FaceDetectorPainter(imageSize, results);
        break;
      case Detector.label:
        painter = LabelDetectorPainter(imageSize, results);
        break;
      case Detector.cloudLabel:
        painter = LabelDetectorPainter(imageSize, results);
        break;
      case Detector.text:
        painter = TextDetectorPainter(imageSize, results);
        break;
      default:
        break;
    }

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    Size sizeImage;
    imageSize.then((imageSize) {
      sizeImage = imageSize;
    });
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.file(widget.imageFile).image,
          fit: BoxFit.fill,
        ),
      ),
      child: imageSize == null || _scanResults == null
          ? const Center(
              child: Text(
                'Scanning...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : _buildResults(sizeImage, _scanResults),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageSize = _getImageSize(widget.imageFile);
    print("image size ===$imageSize");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Image.file(widget.imageFile),
    );
  }
}
