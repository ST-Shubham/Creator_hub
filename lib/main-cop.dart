import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Video Upload',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _video;
  final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('');
  }

  Future pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      _video = File(result.files.single.path!);
      _controller = VideoPlayerController.file(_video!);
      _controller.initialize();
      _controller.setLooping(true);
      setState(() {});
    }
  }

  Future uploadVideo() async {
    if (_video == null) return;

    try {
      firebase_storage.UploadTask task = storageReference
          .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4')
          .putFile(_video!);

      await task.whenComplete(() async {
        print('Video uploaded');
        // You can get the download URL of the uploaded video
        String downloadURL = await task.snapshot.ref.getDownloadURL();
        print('Download URL: $downloadURL');
      });
    } catch (e) {
      print('Error uploading video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Video Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _video == null
                ? Text('No video selected.')
                : AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickVideo(),
              child: Text('Pick Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => uploadVideo(),
              child: Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
