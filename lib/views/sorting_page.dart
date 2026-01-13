import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../view_models/sorting_view_model.dart';
import '../algorithms/sorting_algorithm.dart';
import '../algorithms/bubble_sort.dart';
import '../algorithms/selection_sort.dart';
import '../algorithms/insertion_sort.dart';
import '../algorithms/merge_sort.dart';
import '../algorithms/quick_sort.dart';
import '../widgets.dart';

class SortingPage extends StatefulWidget {
  const SortingPage({Key? key}) : super(key: key);

  @override
  State<SortingPage> createState() => _SortingPageState();
}

class _SortingPageState extends State<SortingPage> with TickerProviderStateMixin {
  late SortingViewModel _viewModel;
  late List<SortingAlgorithm> _algorithms;
  SortingAlgorithm? _selectedAlgorithm;

  @override
  void initState() {
    super.initState();
    _viewModel = SortingViewModel();
    
    _algorithms = [
      BubbleSort(),
      SelectionSort(),
      InsertionSort(),
      MergeSort(),
      QuickSort(),
    ];
    _selectedAlgorithm = _algorithms[0];
  }
  
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return Column(
              children: <Widget>[
                _buildAppBar(context),
                _buildAlgorithmSelector(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ChartWidget(
                          numbers: _viewModel.numbers,
                          activeElements: _viewModel.pointers,
                          sortedElements: _viewModel.sortedElements,
                        ),
                        BottomPointer(
                          length: _viewModel.numbers.length,
                          pointers: _viewModel.pointers,
                        ),
                        _buildStatsRow(),
                        StatusCard(
                          text: _viewModel.updateText,
                          isActive: _viewModel.isSorting,
                        ),
                        _buildSpeedSlider(),
                        _buildSizeSlider(),
                      ],
                    ),
                  ),
                ),
                _buildActionButtons(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sort,
            color: activeData,
            size: 28,
          ),
          SizedBox(width: smallPadding),
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
      isDisabled: _viewModel.isSorting,
      selectedAlgorithmTitle: _selectedAlgorithm?.title ?? '',
      algorithms: _algorithms,
      onTap: (algorithm) {
        setState(() {
          _selectedAlgorithm = algorithm;
          _viewModel.setUpdateText("Ready to sort with ${algorithm.title}");
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
          _buildStatItem('Comparisons', _viewModel.comparisons, Icons.compare_arrows),
          _buildStatItem('Swaps', _viewModel.swaps, Icons.swap_horiz),
          _buildStatItem('Array Size', _viewModel.numbers.length, Icons.view_array),
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
            SizedBox(width: 4),
            Text(
              value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedSlider() {
    return Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Animation Speed',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Text(
                '${(3.0 - _viewModel.speedMultiplier + 0.5).toStringAsFixed(1)}x',
                style: TextStyle(color: activeData, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeData,
              inactiveTrackColor: primaryDark,
              thumbColor: activeData,
              overlayColor: activeData.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _viewModel.speedMultiplier,
              min: 0.5,
              max: 2.5,
              divisions: 8,
              onChanged: _viewModel.isSorting
                  ? null
                  : (value) {
                      _viewModel.setSpeed(value);
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSlider() {
    return Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Array Size: ${_viewModel.sampleSize}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: secondary,
              inactiveTrackColor: primaryDark,
              thumbColor: secondary,
              overlayColor: secondary.withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _viewModel.sampleSize.toDouble(),
              min: 5,
              max: 50,
              divisions: 45,
              onChanged: _viewModel.isSorting
                  ? null
                  : (value) {
                      setState(() {
                        _viewModel.updateSampleSize(value);
                      });
                      HapticFeedback.selectionClick();
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
              label: _viewModel.isSorting ? 'Stop' : 'Start Sort',
              icon: _viewModel.isSorting ? Icons.stop : Icons.play_arrow,
              isPrimary: !_viewModel.isSorting,
              isDestructive: _viewModel.isSorting,
              onPressed: () {
                if (_viewModel.isSorting) {
                  _viewModel.stopSorting();
                } else {
                  if (_selectedAlgorithm != null) {
                    _viewModel.runAlgorithm(_selectedAlgorithm!);
                  }
                }
                HapticFeedback.mediumImpact();
              },
            ),
          ),
          SizedBox(width: defaultPadding),
          Expanded(
            child: ActionButton(
              label: 'Shuffle',
              icon: Icons.shuffle,
              onPressed: _viewModel.isSorting
                  ? null
                  : () {
                      _viewModel.shuffle();
                      HapticFeedback.lightImpact();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
