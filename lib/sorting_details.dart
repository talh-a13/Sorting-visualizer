import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'widgets.dart';
import 'algorithms/sorting_algorithm.dart';
import 'algorithms/bubble_sort.dart';
import 'algorithms/selection_sort.dart';
import 'algorithms/insertion_sort.dart';
import 'algorithms/merge_sort.dart';
import 'algorithms/quick_sort.dart';

class SortDetailsScreen extends StatefulWidget {
  const SortDetailsScreen({super.key});

  @override
  State<StatefulWidget> createState() => SortDetailsScreenState();
}

class SortDetailsScreenState extends State<SortDetailsScreen>
    with TickerProviderStateMixin {
  List<int> numbers = [];
  List<int> pointers = [];
  List<int> sortedElements = [];
  late int n;
  String updateText = "Select a sorting algorithm and press sort to begin";
  late List<SortingAlgorithm> sortingAlgorithmsList;
  late SortingAlgorithm selectedAlgorithmObject;
  String selectedAlgorithm = '';
  bool disableButtons = false;
  bool isCancelled = false;
  double _delay = 1.0;
  int comparisons = 0;
  int swaps = 0;

  late AnimationController _statusAnimationController;
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    sortingAlgorithmsList = [
      BubbleSort(),
      SelectionSort(),
      InsertionSort(),
      MergeSort(),
      QuickSort(),
    ];
    selectedAlgorithmObject = sortingAlgorithmsList[0];
    selectedAlgorithm = selectedAlgorithmObject.title;
    numbers = List<int>.generate(10, (i) => i + 1);
    n = numbers.length;
    shuffle();

    _statusAnimationController = AnimationController(
      duration: mediumDuration,
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: fastDuration,
      vsync: this,
    );

    _statusAnimationController.forward();
    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _statusAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            _buildAlgorithmSelector(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ChartWidget(
                      numbers: numbers,
                      activeElements: pointers,
                      sortedElements: sortedElements,
                    ),
                    BottomPointer(
                      length: numbers.length,
                      pointers: pointers,
                    ),
                    _buildStatsRow(),
                    StatusCard(
                      text: updateText,
                      isActive: disableButtons,
                    ),
                    _buildSpeedSlider(),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sort,
            color: activeData,
            size: 28,
          ),
          const SizedBox(width: smallPadding),
          Text(
            'Sorting Visualizer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmSelector() {
    return SortingAlgorithmsList(
      isDisabled: disableButtons,
      selectedAlgorithmTitle: selectedAlgorithm,
      algorithms: sortingAlgorithmsList,
      onTap: (selected) {
        setState(() {
          selectedAlgorithmObject = selected;
          selectedAlgorithm = selected.title;
          updateText = "Ready to sort with ${selected.title}";
        });
        HapticFeedback.lightImpact();
      },
    );
  }

  Widget _buildStatsRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Comparisons', comparisons, Icons.compare_arrows),
          _buildStatItem('Swaps', swaps, Icons.swap_horiz),
          _buildStatItem('Array Size', n, Icons.view_array),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: activeData, size: 16),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
       const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedSlider() {
    return Container(
      margin: const EdgeInsets.all(defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Animation Speed',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Text(
                '${(3 - _delay + 0.5).toStringAsFixed(1)}x',
                style:
                    const TextStyle(color: activeData, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeData,
              inactiveTrackColor: primaryDark,
              thumbColor: activeData,
              overlayColor: activeData.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _delay,
              min: 0.5,
              max: 2.5,
              divisions: 8,
              onChanged: disableButtons
                  ? null
                  : (value) {
                      setState(() {
                        _delay = value;
                      });
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ActionButton(
              label: disableButtons ? 'Stop' : 'Start Sort',
              icon: disableButtons ? Icons.stop : Icons.play_arrow,
              isPrimary: !disableButtons,
              isDestructive: disableButtons,
              onPressed: () {
                if (disableButtons) {
                  setState(() {
                    isCancelled = true;
                  });
                } else {
                  selectWhichSorting();
                }
                HapticFeedback.mediumImpact();
              },
            ),
          ),
          const SizedBox(width: defaultPadding),
          Expanded(
            child: ActionButton(
              label: 'Shuffle',
              icon: Icons.shuffle,
              onPressed: disableButtons
                  ? null
                  : () {
                      shuffle();
                      HapticFeedback.lightImpact();
                    },
            ),
          ),
        ],
      ),
    );
  }

  void selectWhichSorting() {
    switch (selectedAlgorithm) {
      case bubbleSortTitle:
        bubbleSort();
        break;
      case selectionSortTitle:
        selectionSort();
        break;
      case insertionSortTitle:
        insertionSort();
        break;
      default:
        break;
    }
  }

  void shuffle() {
    setState(() {
      updateText = 'Array shuffled! Ready to sort.';
      numbers.shuffle();
      pointers.clear();
      sortedElements.clear();
      comparisons = 0;
      swaps = 0;
    });
  }

  void updatePointers(List<int> currentPointers) {
    setState(() {
      pointers = currentPointers;
    });
  }

  void finishedSorting() {
    setState(() {
      updateText = 'Sorting completed! 🎉';
      disableButtons = false;
      pointers.clear();
      sortedElements = List.generate(n, (index) => index);
    });
    HapticFeedback.heavyImpact();
  }

  void cancelledSorting() {
    setState(() {
      updateText = 'Sorting cancelled';
      disableButtons = false;
      pointers.clear();
      sortedElements.clear();
    });
  }

  void startSorting() {
    setState(() {
      isCancelled = false;
      disableButtons = true;
      comparisons = 0;
      swaps = 0;
      sortedElements.clear();
    });
  }

  void setUpdateText(String text) {
    setState(() {
      updateText = text;
    });
  }

  void swap(List<int> numbers, int i, int j) {
    int temp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = temp;
    setState(() {
      swaps++;
    });
  }

  void incrementComparisons() {
    setState(() {
      comparisons++;
    });
  }

  // Bubble Sort with enhanced animations
  void bubbleSort() async {
    startSorting();
    setUpdateText('Starting Bubble Sort...');
    await Future.delayed(const Duration(milliseconds: 500));

    for (int step = 0; step < n; step++) {
      if (isCancelled) break;

      for (int i = 0; i < n - step - 1; i++) {
        if (isCancelled) break;

        updatePointers([i, i + 1]);
        incrementComparisons();
        setUpdateText('Comparing ${numbers[i]} and ${numbers[i + 1]}');
        await Future.delayed(Duration(milliseconds: (_delay * 500).toInt()));

        if (numbers[i] > numbers[i + 1]) {
          setUpdateText('${numbers[i]} > ${numbers[i + 1]} - Swapping!');
          swap(numbers, i, i + 1);
          await Future.delayed(Duration(milliseconds: (_delay * 300).toInt()));
        } else {
          setUpdateText('${numbers[i]} ≤ ${numbers[i + 1]} - No swap needed');
          await Future.delayed(Duration(milliseconds: (_delay * 200).toInt()));
        }
      }

      // Mark the last element as sorted
      setState(() {
        if (!sortedElements.contains(n - step - 1)) {
          sortedElements.add(n - step - 1);
        }
      });
    }

    isCancelled ? cancelledSorting() : finishedSorting();
  }

  // Selection Sort with enhanced animations
  void selectionSort() async {
    startSorting();
    setUpdateText('Starting Selection Sort...');
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < n - 1; i++) {
      if (isCancelled) break;

      int minIdx = i;
      setUpdateText('Finding minimum element from position $i');
      updatePointers([i]);
      await Future.delayed(Duration(milliseconds: (_delay * 400).toInt()));

      for (int j = i + 1; j < n; j++) {
        if (isCancelled) break;

        updatePointers([minIdx, j]);
        incrementComparisons();
        setUpdateText('Is ${numbers[j]} < ${numbers[minIdx]}?');
        await Future.delayed(Duration(milliseconds: (_delay * 300).toInt()));

        if (numbers[j] < numbers[minIdx]) {
          minIdx = j;
          setUpdateText('New minimum found: ${numbers[minIdx]}');
        }
      }

      if (minIdx != i) {
        updatePointers([minIdx, i]);
        setUpdateText('Swapping ${numbers[minIdx]} and ${numbers[i]}');
        await Future.delayed(Duration(milliseconds: (_delay * 400).toInt()));
        swap(numbers, minIdx, i);
      } else {
        setUpdateText('${numbers[i]} is already in correct position');
      }

      // Mark current position as sorted
      setState(() {
        if (!sortedElements.contains(i)) {
          sortedElements.add(i);
        }
      });

      await Future.delayed(Duration(milliseconds: (_delay * 200).toInt()));
    }

    // Mark the last element as sorted
    setState(() {
      if (!sortedElements.contains(n - 1)) {
        sortedElements.add(n - 1);
      }
    });

    isCancelled ? cancelledSorting() : finishedSorting();
  }

  // Insertion Sort with enhanced animations
  void insertionSort() async {
    startSorting();
    setUpdateText('Starting Insertion Sort...');
    await Future.delayed(const Duration(milliseconds: 500));

    // Mark first element as sorted
    setState(() {
      if (!sortedElements.contains(0)) {
        sortedElements.add(0);
      }
    });

    for (int i = 1; i < n; i++) {
      if (isCancelled) break;

      int key = numbers[i];
      int j = i - 1;

      setUpdateText('Inserting ${numbers[i]} into sorted portion');
      updatePointers([i]);
      await Future.delayed(Duration(milliseconds: (_delay * 400).toInt()));

      // Move elements that are greater than key one position ahead
      while (j >= 0 && numbers[j] > key) {
        if (isCancelled) break;

        updatePointers([j, j + 1]);
        incrementComparisons();
        setUpdateText('${numbers[j]} > $key - Moving ${numbers[j]} right');
        await Future.delayed(Duration(milliseconds: (_delay * 300).toInt()));

        numbers[j + 1] = numbers[j];
        setState(() {
          swaps++;
        });
        j = j - 1;

        await Future.delayed(Duration(milliseconds: (_delay * 200).toInt()));
      }

      // Place key at its correct position
      numbers[j + 1] = key;
      setUpdateText('Placing $key at position ${j + 1}');
      updatePointers([j + 1]);
      await Future.delayed(Duration(milliseconds: (_delay * 300).toInt()));

      // Mark current position as sorted
      setState(() {
        if (!sortedElements.contains(i)) {
          sortedElements.add(i);
        }
      });

      await Future.delayed(Duration(milliseconds: (_delay * 200).toInt()));
    }

    isCancelled ? cancelledSorting() : finishedSorting();
  }
}
