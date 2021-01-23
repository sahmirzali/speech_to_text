import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mic_stream_example/dialog.dart';
import 'package:mic_stream_example/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

import 'provider_data.dart';
import 'utils/const.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyData()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mic Stream Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AudioRecognize(),
    );
  }
}

class AudioRecognize extends StatefulWidget {
  final TextEditingController textEditingControllers;

  const AudioRecognize({Key key, this.textEditingControllers}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AudioRecognizeState();
}

class _AudioRecognizeState extends State<AudioRecognize> {
 

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MyData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio File Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              controller: widget.textEditingControllers,
              decoration: InputDecoration(
                hintText: 'Enter a message',
                suffixIcon: IconButton(
                  onPressed: () async {
                    /*Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Dialogum(
                            //datas: controller.text.trim(),
                            ))); */
                    //await vm.streamingRecognize();
                    await showDialog(
                        context: context, builder: (context) => Dialogum());
                  },
                  icon: Icon(Icons.mic),
                ),
              ),
            ),
            /*  if (vm.recognizeFinished)
              _RecognizeContent(
                text: vm.text,
              ),
            RaisedButton(
              onPressed: vm.recognizing ? vm.stopRecording : vm.streamingRecognize,
              child: recognizing
                  ? Text('Stop recording')
                  : Text('Start Streaming from mic'),
            ),*/
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




/*
                          Center(
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  color: Colors.white,
                                  width: 300,
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('aaaaaaaaa'),
                                      //if (recognizeFinished)
                                       
                                          Text(vm.text),
                                        
                                      RaisedButton(
                                        onPressed: vm.recognizing
                                            ? vm.stopRecording
                                            : vm.streamingRecognize,
                                        child: vm.recognizing
                                            ? Text('Stop recording')
                                            : Text('Start Streaming from mic'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
*/
class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'The text recognized by the Google Speech Api:',
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
