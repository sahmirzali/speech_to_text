import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:provider/provider.dart';

class MyData extends ChangeNotifier {
  final RecorderStream recorder = RecorderStream();

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;

  final TextEditingController textEditingController = TextEditingController();

  /* @override
  void initState() {
    super.initState();

  _recorder.initialize();
  }*/

  Future streamingRecognize() async {
    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = recorder.audioStream.listen((event) {
      _audioStream.add(event);
    });

    await recorder.start();
   // notifyListeners();
    // setState(() {
    recognizing = true;
    //notifyListeners();
    //});
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        _audioStream);

    responseStream.listen((data) {
      //setState(() {
      text =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');
      print('--++++++++++ $text');
      textEditingController.text =
          data.results.map((e) => e.alternatives.first.transcript).join('\n');
      recognizeFinished = true;
      //notifyListeners();
      // });
    }, onDone: () {
      // setState(() {
      recognizing = false;
      //notifyListeners();
      // });
    });
    notifyListeners();
  }

  Future stopRecording() async {
    await recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
    //  setState(() {
    recognizing = false;
    print('---------------- > $text');
    notifyListeners();
    //});
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'ru-RU');

//final filterNode = FocusNode();

}
