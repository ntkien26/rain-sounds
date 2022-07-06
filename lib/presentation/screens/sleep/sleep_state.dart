import 'package:rain_sounds/data/local/model/mix.dart';

enum SleepStatus { loading, success, empty, error }

class SleepState {

  const SleepState({this.status = SleepStatus.loading, this.mixes, this.categories});

  final SleepStatus status;
  final List<Mix>? mixes;
  final List<Category>? categories;

  SleepState copyWith(
      {SleepStatus? status, List<Mix>? mixes, List<Category>? categories}) {
    return SleepState(status: status ?? this.status, mixes: mixes, categories: categories ?? this.categories);
  }

  static SleepState initial = const SleepState();
}

class Category {
  final int id;
  final String title;

  Category({required this.id, required this.title});
}
