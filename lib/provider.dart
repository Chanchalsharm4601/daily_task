import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  List<String> _confirmedWords = [];
  List<String> _filteredWords = [];
  List<bool> _isCheckedList = [];
  bool _isListening = false;

  List<String> get confirmedWords => _confirmedWords;
  List<String> get filteredWords => _filteredWords;
  List<bool> get isCheckedList => _isCheckedList;
  bool get isListening => _isListening;

  HomeProvider(){
    _loadState();
  }

  void addWord(String word){
    _confirmedWords.add(word);
    _isCheckedList.add(false);
    _filteredWords = List.from(_confirmedWords);
    notifyListeners();
    _saveState();
  }

  void editWord(int index,String newWord){
    _confirmedWords[index] = newWord;
    _filteredWords = List.from(_confirmedWords);
    notifyListeners();
    _saveState();
  }

  void toggleCheck(int index,bool value){
    _isCheckedList[index] = value;
    notifyListeners();
    _saveState();
  }

  void setListening(bool listening){
    _isListening = listening;
    notifyListeners();
  }

  void deleteWord(int index){
    _confirmedWords.removeAt(index);
    _isCheckedList.removeAt(index);
    _filteredWords = List.from(_confirmedWords);
    notifyListeners();
    _saveState();
  }

  set filteredWords(List<String> words) {
    _filteredWords = words;
    notifyListeners();
  }

  Future<void> _saveState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('confirmedWords', _confirmedWords);
    prefs.setStringList('isCheckedList', _isCheckedList.map((e) => e.toString()).toList());
  }

  Future<void> _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _confirmedWords = prefs.getStringList('confirmedWords') ?? [];
    _filteredWords = List.from(_confirmedWords);
    _isCheckedList = prefs.getStringList('isCheckedList')?.map((e) => e == 'true').toList() ?? [];
    notifyListeners();
  }
}
