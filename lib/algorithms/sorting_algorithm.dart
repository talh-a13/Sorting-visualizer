import '../view_models/sorting_view_model.dart';

abstract class SortingAlgorithm {
  String get title;
  String get complexity;
  
  Future<void> sort(SortingViewModel viewModel);
}
