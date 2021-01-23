import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:mic_stream_example/main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';

class Dialogum extends StatefulWidget {
  Dialogum({Key key}) : super(key: key);

  @override
  _DialogumState createState() => _DialogumState();
}

class _DialogumState extends State<Dialogum> {
  final RecorderStream recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;

  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    recorder.initialize();
  }

  void streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = recorder.audioStream.listen((event) {
      _audioStream.add(event);
    });

    await recorder.start();

    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream);

    responseStream.listen((data) {
      setState(() {
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        textEditingController.text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        recognizeFinished = true;
      });
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    });
  }

  void stopRecording() async {
    await recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    setState(() {
      recognizing = false;
    });
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AudioRecognize(
              textEditingControllers: textEditingController,
            )));
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'ru-RU');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.white,
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (recognizeFinished) Text(text),
              RaisedButton(
                onPressed: ()  {
                  recognizing ? stopRecording() : streamingRecognize();
                },
                child: recognizing
                    ? Text('Stop recording')
                    : Text('Start Streaming from mic'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
