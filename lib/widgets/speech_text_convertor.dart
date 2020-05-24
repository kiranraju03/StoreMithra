import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechTextConvert extends StatefulWidget {
  @override
  _SpeechTextConvertState createState() => _SpeechTextConvertState();
}

class _SpeechTextConvertState extends State<SpeechTextConvert> {
  stt.SpeechToText speech = stt.SpeechToText();
  String _currentLocaleId = "";
  List<stt.LocaleName> _localeNames = [];
  bool _hasSpeech = false;

  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_hasSpeech){
      initSpeechState();
    }
    return IconButton(
      icon: Icon(Icons.mic),
      onPressed: !_hasSpeech || speech.isListening ? null : startListening,
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 10),
        localeId: _currentLocaleId,
        // onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
      print(lastWords);
    });
  }


  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
