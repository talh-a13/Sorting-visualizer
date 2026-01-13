# Sorting Visualizer using Flutter

A beautiful, interactive, and educational Flutter application to visualize how various sorting algorithms work in real-time. Features a modern UI, real-time speed control, dynamic array resizing, and detailed performance metrics.

## 🚀 Features

*   **Algorithms Supported**:
    *   **Bubble Sort** (`O(n²)`)
    *   **Selection Sort** (`O(n²)`)
    *   **Insertion Sort** (`O(n²)`)
    *   **Merge Sort** (`O(n log n)`)
    *   **Quick Sort** (`O(n log n)`)

*   **Interactive Controls**:
    *   **Start/Stop/Shuffle**: Full control over the sorting process.
    *   **Speed Slider**: Adjust animation speed in real-time (0.5x to 2.5x).
    *   **Array Size**: Dynamically change the number of elements to sort (5 to 50).

*   **Real-time Metrics**:
    *   Live tracking of **Comparisons** and **Swaps**.
    *   Visual indicators for active comparisons, swaps, and sorted elements.

*   **Architecture**:
    *   Built using **MVVM (Model-View-ViewModel)** for clean separation of concerns.
    *   **Provider** (via `ChangeNotifier`) for efficient state management.

## 🛠 Tech Stack

*   **Framework**: Flutter
*   **Language**: Dart
*   **Architecture**: MVVM
*   **State Management**: `ChangeNotifier` (Native Flutter)
*   **Charts**: Custom implementation using `fl_chart`

## 📂 Project Structure

```
lib/
├── algorithms/           # Algorithm implementations
│   ├── sorting_algorithm.dart  # Abstract base class
│   ├── bubble_sort.dart
│   ├── quick_sort.dart
│   └── ...
├── view_models/          # Business logic & State
│   └── sorting_view_model.dart
├── views/                # UI Screens
│   └── sorting_page.dart
├── constants.dart        # Colors, Strings, Configs
├── widgets.dart          # Reusable UI Components
└── main.dart             # Entry point
```

## 📸 How It Works

1.  **Select Algorithm**: Choose between Bubble, Selection, Insertion, Merge, or Quick sort.
2.  **Adjust Settings**: Use the sliders to set your desired array size and animation speed.
3.  **Shuffle**: Generate a new random set of bars.
4.  **Sort**: Watch the algorithm in action! The visualizer highlights:
    *   **Green**: Sorted elements
    *   **Cyan**: Active element being examined
    *   **Red**: Elements currently being compared

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](issues).
