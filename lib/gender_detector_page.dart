import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gender_detector_app/components/appBarComponent.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class GenderDetectorPage extends StatefulWidget {
  @override
  GenderDetectorPageState createState() => GenderDetectorPageState();
}

class GenderDetectorPageState extends State<GenderDetectorPage> {
  bool _isLoading;
  PickedFile _image;
  List _output;
  final picker = ImagePicker();
  String _resultGender;

  // audio
  AudioPlayer audioPlayer;
  AudioPlayerState audioPlayerState;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    // audio
    audioPlayer = AudioPlayer();
    audioPlayerState = null;
  }

  Future loadAsset(String gender) async {
    return await rootBundle.load('assets/speech/$gender.mp3');
  }

  Future<void> play(data) async {
    var gender;
    (int.parse(data.split(' ')[0]) == 0) ? gender = "male" : gender = "female";
    // jika laki laki
    final file =
        new File('${(await getTemporaryDirectory()).path}/$gender.mp3');
    await file.writeAsBytes((await loadAsset(gender)).buffer.asUint8List());
    await audioPlayer.play(file.path, isLocal: true);

    setState(() {
      audioPlayerState = AudioPlayerState.PLAYING;
      if (audioPlayer.state == AudioPlayerState.COMPLETED) {
        audioPlayerState = AudioPlayerState.COMPLETED;
      }
    });
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    setState(() {
      audioPlayerState = AudioPlayerState.STOPPED;
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
                ? Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _image == null
                              ? Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 100),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 60),
                                          blurRadius: 50,
                                          color: Color(0x7090B0).withAlpha(60),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image(
                                            image:
                                                AssetImage("assets/puimek.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Text(
                                            "Pastikan foto kamu jelas\n untuk proses deteksi foto lebih akurat",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 30.0),
                                        blurRadius: 50.0,
                                        color: Color(0x7090B0).withAlpha(60),
                                        // spreadRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 90),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.file(
                                      File(_image.path),
                                      fit: BoxFit.cover,
                                      height: 470,
                                      width: 350,
                                    ),
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
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      "Hasilnya Deteksi",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                        color: int.parse(_resultGender.split(' ')[0]) == 0
                            ? Colors.blue[400]
                            : Colors.purple[200],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${_resultGender.split(' ')[1]}",
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: int.parse(_resultGender.split(' ')[0]) == 0
                            ? Colors.blue[400]
                            : Colors.purple[200],
                      ),
                    )
                  ],
                ),
              ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10.0),
                    blurRadius: 10.0,
                    color: Colors.purple.withAlpha(20),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              margin: EdgeInsets.only(left: 10, bottom: 10),
              padding: EdgeInsets.fromLTRB(10, 10, 20, 0),
              child: RaisedButton(
                color: Colors.purple[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.purple[200], width: 2.0),
                ),
                onPressed: () {
                  if (audioPlayerState == AudioPlayerState.PLAYING) {
                    stop();
                  }
                  choosePicker("camera");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "Tambah Foto",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10.0),
                    blurRadius: 10.0,
                    color: Colors.purple.withAlpha(20),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              margin: EdgeInsets.only(right: 10, bottom: 10),
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              child: RaisedButton(
                color: Colors.purple[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.purple[200], width: 2.0),
                ),
                onPressed: () {
                  if (audioPlayerState == AudioPlayerState.PLAYING) {
                    stop();
                  }
                  choosePicker("gallery");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "Ambil Foto",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
      _resultGender = _output[0]['label'];
    });
    play(_resultGender);
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }
}
