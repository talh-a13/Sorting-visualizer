import '../view_models/sorting_view_model.dart';
import 'sorting_algorithm.dart';

class InsertionSort implements SortingAlgorithm {
  @override
  String get title => 'Insertion Sort';

  @override
  String get complexity => 'n²';

  @override
  Future<void> sort(SortingViewModel viewModel) async {
    int n = viewModel.numbers.length;
    viewModel.addSortedElement(0);

    for (int i = 1; i < n; i++) {
      int key = viewModel.numbers[i];
      int j = i - 1;

      if (await viewModel.visualize(pointers: [i], message: 'Inserting $key into sorted portion')) return;

      while (j >= 0 && viewModel.numbers[j] > key) {
        if (await viewModel.compare(j, j+1, message: '${viewModel.numbers[j]} > $key - Moving right')) return;
        

        if (await viewModel.overwrite(j + 1, viewModel.numbers[j])) return;
        
        j = j - 1;
      }
      
      if (await viewModel.overwrite(j + 1, key, message: 'Placed $key at correct position')) return;
      viewModel.addSortedElement(i);
    }
  }
}
