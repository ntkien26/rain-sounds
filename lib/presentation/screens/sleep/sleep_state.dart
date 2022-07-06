import 'package:rain_sounds/data/local/model/mix.dart';

enum SleepStatus { loading, success, empty, error }

class SleepState {
  const SleepState(
      {this.status = SleepStatus.loading,
      this.mixes,
      this.categories,
      this.selectedMix});

  final SleepStatus status;
  final List<Mix>? mixes;
  final List<Category>? categories;
  final Mix? selectedMix;

  SleepState copyWith({
    SleepStatus? status,
    List<Mix>? mixes,
    List<Category>? categories,
    Mix? selectedMix,
  }) {
    return SleepState(
        status: status ?? this.status,
        mixes: mixes,
        categories: categories ?? this.categories,
        selectedMix: selectedMix ?? this.selectedMix);
  }

  static SleepState initial = const SleepState();
}

class Category {
  final int id;
  final String title;

  Category({required this.id, required this.title});
}
