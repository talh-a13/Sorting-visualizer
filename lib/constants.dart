import 'package:flutter/material.dart';
import 'modals.dart';

// Modern color palette with gradients and professional colors
const Color primary = Color(0xFF0D1B2A);
const Color primaryDark = Color(0xFF1B263B);
const Color secondary = Color(0xFF415A77);
const Color accent = Color(0xFF778DA9);
const Color surface = Color(0xFF1A2332);
const Color activeData = Color(0xFF00F4B8);
const Color comparingData = Color(0xFFFF6B6B);
const Color sortedData = Color(0xFF4ECDC4);
const Color unselectedData = Color(0xFF9FB3C8);

// Gradient colors for bars
const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient activeGradient = LinearGradient(
  colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient comparingGradient = LinearGradient(
  colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Algorithm titles
const String bubbleSortTitle = 'Bubble Sort';
const String selectionSortTitle = 'Selection Sort';
const String insertionSortTitle = 'Insertion Sort';

// Complexity strings
const bigOh = 'O';
const logN = 'log(n)';
const nsquare = 'n²';
const logNsquare = 'n log(n)';

// Enhanced algorithms list with proper complexity values
final List<SortingAlgorithm> sortingAlgorithmsList = [
  SortingAlgorithm(
    title: bubbleSortTitle,
    complexity: nsquare,
  ),
  SortingAlgorithm(
    title: selectionSortTitle,
    complexity: nsquare,
  ),
  SortingAlgorithm(
    title: insertionSortTitle,
    complexity: nsquare,
  ),
];

// Animation durations
const Duration fastDuration = Duration(milliseconds: 200);
const Duration mediumDuration = Duration(milliseconds: 500);
const Duration slowDuration = Duration(milliseconds: 800);

// UI constants
const double defaultPadding = 16.0;
const double smallPadding = 8.0;
const double largePadding = 24.0;
const double borderRadius = 12.0;
const double cardElevation = 4.0;
