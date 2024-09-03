import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionService {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String text = '';

  void initialize() {
    _speech = stt.SpeechToText();
  }

  Future<bool> startListening(Function(String, double) onResult) async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
      },
    );

    if (available) {
      isListening = true;
      _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords, result.confidence);
          isListening = false;
        },
      );
    } else {
      print('Speech recognition not available');
    }

    return available;
  }

  void stop() {
    _speech.stop();
    isListening = false;
  }
}
