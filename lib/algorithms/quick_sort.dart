import '../view_models/sorting_view_model.dart';
import 'sorting_algorithm.dart';

class QuickSort implements SortingAlgorithm {
  @override
  String get title => 'Quick Sort';

  @override
  String get complexity => 'n log n';

  @override
  Future<void> sort(SortingViewModel viewModel) async {
    await _quickSort(viewModel, 0, viewModel.numbers.length - 1);
  }

  Future<void> _quickSort(SortingViewModel vm, int low, int high) async {
    if (low < high) {
      int pi = await _partition(vm, low, high);
      if (vm.isSorting == false) return;


      vm.addSortedElement(pi);
      await _quickSort(vm, low, pi - 1);
      await _quickSort(vm, pi + 1, high);
    } else if (low == high) {
       vm.addSortedElement(low);
    }
  }

  Future<int> _partition(SortingViewModel vm, int low, int high) async {
    int pivot = vm.numbers[high];
    
    int i = (low - 1);

    for (int j = low; j < high; j++) {
      if (await vm.compare(j, high, message: 'Comparing ${vm.numbers[j]} with pivot $pivot')) return high;

      if (vm.numbers[j] < pivot) {
        i++;
        if (i != j) {
          if (await vm.swapItems(i, j, message: 'Swapping ${vm.numbers[i]} and ${vm.numbers[j]}')) return high;
        }
      }
    }
    
    if (i + 1 != high) {
       if (await vm.swapItems(i + 1, high, message: 'Placing pivot at correct position')) return high;
    }
    
    return i + 1;
  }
}
