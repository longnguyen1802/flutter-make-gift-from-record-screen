import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_recorder/screen_recorder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ScreenRecorderController controller = ScreenRecorderController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            ScreenRecorder(
              height: 200,
              width: 200,
              controller: controller,
              child: Center(
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.start();
              },
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.stop();
              },
              child: Text('Stop'),
            ),
            ElevatedButton(
              onPressed: () async {
                var gif = await controller.export();
                Directory tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;
                var filePath = tempPath + '/file_01.gif';
                File x = await File(filePath).writeAsBytes(Uint8List.fromList(gif!));
                final result = await ImageGallerySaver.saveFile(x.path, isReturnPathOfIOS: true);
                print(result);
                _toastInfo("$result");
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Image.memory(Uint8List.fromList(gif!)),
                    );
                  },
                );
              },
              child: Text('show recoded video'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
