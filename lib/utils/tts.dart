import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

enum TTSState { playing, stopped }

class TTS {
  static final TTS _singleton = TTS._internal();
  FlutterTts _flutterTts;
  TTSState _ttsState;
  int _index = 0;
  List _contentArr = [];
  Function _startHandler;
  Function _completionHandler;
  /// 保存暂停
  // String residenceContent;

  factory TTS() {
    return _singleton;
  }

  TTS._internal() {
    _flutterTts = FlutterTts();
    _flutterTts.setPitch(1);
    final voices  = _flutterTts.getVoices;
    print(voices);
    _flutterTts.setStartHandler(() {
      
      _startHandler(_index);
      _ttsState = TTSState.playing;
    });
    _flutterTts.setCompletionHandler(() {
      _ttsState = TTSState.stopped;
      /// 判断是否执行结束，结束则调用结束
      if (_index == _contentArr.length - 1) {
        return _completionHandler();
      }
      /// 延迟500毫秒重新播放
      Future.delayed(Duration(milliseconds: 500)).then((value){
        _index++;
        speakContent(_contentArr, _index,
          completionHandler: _completionHandler,
          startHandler: _startHandler
        );
      });
    });
    _flutterTts.setErrorHandler((msg) {
      _ttsState = TTSState.stopped;
    });
  }

  Future<bool> _setSpeakingLanguage(String language) async {
    _flutterTts.setLanguage(language);
    return true;
  }

  Future<bool> speak(String language, String text) async {
    print('播放1');
    if (_ttsState == TTSState.playing) return true;
    print('播放2');
    if (await _setSpeakingLanguage(language) == false) return false;
    print('播放3');
    var result = await _flutterTts.speak(text);
    if (result == 1) _ttsState = TTSState.playing;
    return true;
  }
  speakContent(contentArr, index, { Function startHandler, Function completionHandler }) async{
    _index = index;
    _contentArr = contentArr;
    _startHandler = startHandler;
    _completionHandler = completionHandler;
    print('触发');
    speak('zh-CN', contentArr[index]);
  }
//   String getResidenceByDuration(int duration){
//         int tempIndex= (int) (duration/charStep);
//         if(duration > (charStep * residenceContent.length())){
//            return "";
//         }
//         residenceContent=residenceContent.substring(tempIndex-1);
//         return residenceContent;
// //        int index=findSentenceIndex(duration);
// //        if(index==-1){
// //            return "";
// //        }else {
// //            residenceContent=residenceContent.substring((int)((duration-sentenceStep.get(index-1))/charStep)+1);
// //            return residenceContent;
// //        }
//     }
  Future<void> stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) _ttsState = TTSState.stopped;
  }
  void dispose() {
    _flutterTts.stop();
  }

  get isPlaying => _ttsState == TTSState.playing;
  get isStopped => _ttsState == TTSState.stopped;
    
}