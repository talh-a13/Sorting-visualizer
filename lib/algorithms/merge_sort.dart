import '../view_models/sorting_view_model.dart';
import 'sorting_algorithm.dart';

class MergeSort implements SortingAlgorithm {
  @override
  String get title => 'Merge Sort';

  @override
  String get complexity => 'n log n';

  @override
  Future<void> sort(SortingViewModel viewModel) async {
    await _mergeSort(viewModel, 0, viewModel.numbers.length - 1);
  }

  Future<void> _mergeSort(SortingViewModel vm, int l, int r) async {
    if (l >= r) return;

    int m = l + (r - l) ~/ 2;
    
    if (await vm.visualize(pointers: [l, r], message: 'Dividing range $l to $r')) return;

    await _mergeSort(vm, l, m);
    await _mergeSort(vm, m + 1, r);
    
    await _merge(vm, l, m, r);
  }

  Future<void> _merge(SortingViewModel vm, int l, int m, int r) async {
    int n1 = m - l + 1;
    int n2 = r - m;

    List<int> left = List.filled(n1, 0);
    List<int> right = List.filled(n2, 0);

    for (int i = 0; i < n1; i++) left[i] = vm.numbers[l + i];
    for (int j = 0; j < n2; j++) right[j] = vm.numbers[m + 1 + j];

    int i = 0, j = 0, k = l;

    vm.setUpdateText("Merging range $l to $r");
    
    while (i < n1 && j < n2) {
      if (await vm.compare(l + i, m + 1 + j)) return;

      if (left[i] <= right[j]) {
        if (await vm.overwrite(k, left[i])) return;
        i++;
      } else {
        if (await vm.overwrite(k, right[j])) return;
        j++;
      }
      k++;
    }

    while (i < n1) {
      if (await vm.overwrite(k, left[i])) return;
      i++;
      k++;
    }

    while (j < n2) {
      if (await vm.overwrite(k, right[j])) return;
      j++;
      k++;
    }
    
    // Mark sorted range
    for (int x = l; x <= r; x++) {
       vm.addSortedElement(x);
    }
  }
}
