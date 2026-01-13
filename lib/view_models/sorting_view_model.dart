
import 'package:flutter/foundation.dart';
import '../algorithms/sorting_algorithm.dart';

class SortingViewModel extends ChangeNotifier {
  List<int> _numbers = [];
  List<int> _pointers = [];
  List<int> _sortedElements = [];
  
  String _updateText = "Select a sorting algorithm and press sort to begin";
  bool _isSorting = false;
  bool _isCancelled = false;
  double _speedMultiplier = 1.0;
  
  int _comparisons = 0;
  int _swaps = 0;
  
  int _sampleSize = 10;

  List<int> get numbers => _numbers;
  List<int> get pointers => _pointers;
  List<int> get sortedElements => _sortedElements;
  String get updateText => _updateText;
  bool get isSorting => _isSorting;
  double get speedMultiplier => _speedMultiplier;
  int get comparisons => _comparisons;
  int get swaps => _swaps;
  int get sampleSize => _sampleSize;

  SortingViewModel() {
    reset();
  }

  void updateSampleSize(double value) {
    int newSize = value.toInt();
    if (_sampleSize != newSize) {
      _sampleSize = newSize;
      reset();
    }
  }

  void reset() {
    _numbers = List<int>.generate(_sampleSize, (i) => i + 1);
    shuffle();
  }

  void shuffle() {
    _numbers.shuffle();
    _pointers = [];
    _sortedElements = [];
    _comparisons = 0;
    _swaps = 0;
    _updateText = "Array shuffled! Ready to sort.";
    notifyListeners();
  }

  void setSpeed(double value) {
    _speedMultiplier = value;
    notifyListeners();
  }

  void updateBlock(List<int> newNumbers) {
    _numbers = List.from(newNumbers);
    notifyListeners();
  }

  void updatePointers(List<int> newPointers) {
    _pointers = List.from(newPointers);
    notifyListeners();
  }

  void addSortedElement(int index) {
    if (!_sortedElements.contains(index)) {
      _sortedElements.add(index);
      notifyListeners();
    }
  }
  
  void clearSortedElements() {
    _sortedElements.clear();
    notifyListeners();
  }
  
  void markAllSorted() {
    _sortedElements = List.generate(_numbers.length, (index) => index);
    notifyListeners();
  }

  void incrementComparisons() {
    _comparisons++;
    notifyListeners();
  }

  void incrementSwaps() {
    _swaps++;
    notifyListeners();
  }

  void setUpdateText(String text) {
    _updateText = text;
    notifyListeners();
  }

  void stopSorting() {
    if (_isSorting) {
      _isCancelled = true;
      _updateText = "Stopping...";
      notifyListeners();
    }
  }

  Future<void> runAlgorithm(SortingAlgorithm algorithm) async {
    if (_isSorting) return;

    _isSorting = true;
    _isCancelled = false;
    _comparisons = 0;
    _swaps = 0;
    _sortedElements = [];
    _pointers = [];
    _updateText = "Starting ${algorithm.title}...";
    notifyListeners();

    await algorithm.sort(this);

    if (!_isCancelled) {
      _updateText = "Sorting completed! 🎉";
      markAllSorted();
    } else {
      _updateText = "Sorting cancelled";
    }

    _isSorting = false;
    _pointers = [];
    notifyListeners();
  }



  Future<bool> _wait(int baseDurationMs) async {
    if (_isCancelled) return true;
    
    int actualDelay = (_speedMultiplier * baseDurationMs).toInt();
    if (actualDelay < 1) actualDelay = 1;
    
    await Future.delayed(Duration(milliseconds: actualDelay));
    return _isCancelled;
  }

  Future<bool> compare(int i, int j, {String? message}) async {
    if (_isCancelled) return true;
    
    _pointers = [i, j];
    _comparisons++;
    if (message != null) _updateText = message;
    notifyListeners();
    
    return await _wait(200); // 200ms base for comparisons
  }

  Future<bool> swapItems(int i, int j, {String? message}) async {
    if (_isCancelled) return true;

    if (message != null) _updateText = message;
    
    int temp = _numbers[i];
    _numbers[i] = _numbers[j];
    _numbers[j] = temp;
    
    _swaps++;
    _pointers = [i, j]; // Highlight swapped elements
    notifyListeners();

    return await _wait(300); // 300ms base for swaps
  }
  
  Future<bool> visualize({
    List<int>? pointers, 
    String? message,
    int durationMs = 100
  }) async {
    if (_isCancelled) return true;
    
    if (pointers != null) _pointers = pointers;
    if (message != null) _updateText = message;
    notifyListeners();
    
    return await _wait(durationMs);
  }

  Future<bool> overwrite(int index, int value, {String? message}) async {
     if (_isCancelled) return true;
     
     if (message != null) _updateText = message;
     _numbers[index] = value;
     _swaps++; // Counting writes as operations
     _pointers = [index];
     notifyListeners();
     
     return await _wait(200);
  }
}