import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'constants.dart';

class BottomPointer extends StatelessWidget {
  final int length;
  final List<int> pointers;

  const BottomPointer({Key? key, required this.length, required this.pointers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Stack(
        children: pointers.asMap().entries.map((entry) {
          int index = entry.key;
          int item = entry.value;
          return AnimatedPositioned(
            duration: fastDuration,
            left: item *
                (MediaQuery.of(context).size.width - 2 * defaultPadding) /
                length,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: index == 0 ? activeData : comparingData,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: (index == 0 ? activeData : comparingData)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ChartWidget extends StatefulWidget {
  final List<int> numbers;
  final List<int> activeElements;
  final List<int> sortedElements;

  const ChartWidget({
    Key? key,
    required this.numbers,
    required this.activeElements,
    this.sortedElements = const [],
  }) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: mediumDuration,
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.numbers != widget.numbers ||
        oldWidget.activeElements != widget.activeElements) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      margin: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: BarChart(
              mainBarData(),
              swapAnimationDuration: fastDuration,
            ),
          );
        },
      ),
    );
  }

  Color _getBarColor(int index) {
    if (widget.sortedElements.contains(index)) {
      return sortedData;
    } else if (widget.activeElements.contains(index)) {
      return widget.activeElements.indexOf(index) == 0
          ? activeData
          : comparingData;
    } else {
      return unselectedData;
    }
  }

  BarChartGroupData makeGroupData(int x, int y) {
    final color = _getBarColor(x);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble() * _animationController.value,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 12,
            color: primaryDark.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() {
    return widget.numbers.asMap().entries.map((entry) {
      return makeGroupData(entry.key, entry.value);
    }).toList();
  }

  BarChartData mainBarData() {
    return BarChartData(
      maxY: 12,
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < widget.numbers.length) {
                return Text(
                  widget.numbers[value.toInt()].toString(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                );
              }
              return Container();
            },
            reservedSize: 32,
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }
}

class SortingAlgorithmsList extends StatelessWidget {
  final bool isDisabled;
  final Function(String) onTap;
  final String selectedAlgorithm;

  const SortingAlgorithmsList({
    Key? key,
    this.isDisabled = false,
    required this.onTap,
    required this.selectedAlgorithm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: defaultPadding),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: sortingAlgorithmsList.length,
        itemBuilder: (BuildContext context, int index) {
          final algorithm = sortingAlgorithmsList[index];
          final isSelected = algorithm.title == selectedAlgorithm;

          return AnimatedContainer(
            duration: fastDuration,
            margin: EdgeInsets.symmetric(horizontal: smallPadding),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : () => onTap(algorithm.title),
                borderRadius: BorderRadius.circular(borderRadius),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: largePadding,
                    vertical: smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? activeData : surface,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(
                      color: isSelected ? activeData : surface,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: activeData.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        algorithm.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'O(${algorithm.complexity})',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.black54 : Colors.white54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String text;
  final bool isActive;

  const StatusCard({
    Key? key,
    required this.text,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: mediumDuration,
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(largePadding),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isActive ? activeData : surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;

  const ActionButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    if (isDestructive) {
      backgroundColor = comparingData;
      foregroundColor = Colors.white;
    } else if (isPrimary) {
      backgroundColor = activeData;
      foregroundColor = Colors.black;
    } else {
      backgroundColor = surface;
      foregroundColor = Colors.white;
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: cardElevation,
          shadowColor: backgroundColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: largePadding),
        ),
      ),
    );
  }
}
