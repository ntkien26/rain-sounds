import 'package:flutter/widgets.dart';

@immutable
abstract class AppEvent {}

class OnFirebaseConfigurationEvent extends AppEvent{}