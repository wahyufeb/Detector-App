import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gender_detector_app/components/appBarComponent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class GenderDetectorPage extends StatefulWidget {
  @override
  GenderDetectorPageState createState() => GenderDetectorPageState();
}

class GenderDetectorPageState extends State<GenderDetectorPage> {
  bool _isLoading;
  PickedFile _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        title: "Gender Detector App",
      ),
      body: Stack(children: [
        ListView(
          children: [
            (_isLoading)
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  )
                : Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _image == null
                              ? Container(
                                  child: Text("NULL"),
                                )
                              : Container(
                                  child: Image.file(
                                    File(_image.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        _output == null
            ? Container(child: Text(""))
            : Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 40),
                child: Text(
                  "Anda harusnya \n ${_output[0]['label'].split(' ')[1]}",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: RaisedButton(
                onPressed: () {
                  choosePicker("camera");
                },
                child: Text("Ambil Foto dari Kamera"),
              ),
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: RaisedButton(
                onPressed: () {
                  choosePicker("gallery");
                },
                child: Text("Ambil Foto dari Gallery"),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  choosePicker(String modeCamera) async {
    var image;
    if (modeCamera == "camera") {
      image = await picker.getImage(source: ImageSource.camera);
    } else {
      image = await picker.getImage(source: ImageSource.gallery);
    }
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });
    runModel(image);
  }

  runModel(PickedFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }
}
