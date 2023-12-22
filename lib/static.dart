
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class StaticImageLabelling extends StatefulWidget {
  const StaticImageLabelling({super.key});

  @override
  State<StaticImageLabelling> createState() => _StaticImageLabellingState();
}

class _StaticImageLabellingState extends State<StaticImageLabelling> {
  late ImagePicker imagePicker;
  File? _image;
  String result = 'Results will be shown here.......';

  // declare ImageLabeler'
  dynamic imageLabeler;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //capture image using camera
  imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      _image;
      doImageLabeling();
    });
  }

  //choose image using gallery
  imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doImageLabeling();
      });
    }
  }

  //image labeling code here
  doImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    result = '';
    for (ImageLabel label in labels) {
      final String text = label.label;
      //final int index = label.index;
      final double confidence = label.confidence;
        result += "$text  ${confidence.toStringAsFixed(2)}\n";
    
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/frame.png',
                        height: 510,
                        width: 500,
                      ),
                    ),
                  ]),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: imgFromGallery,
                      onLongPress: imgFromCamera,
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 335,
                                height: 495,
                                fit: BoxFit.fill,
                              )
                            : SizedBox(
                                width: 340,
                                height: 330,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 100,
                                ),
                              ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
