import 'package:flutter/material.dart';

enum GameMode{daily, practice}

final ValueNotifier<GameMode> currentGameMode = ValueNotifier<GameMode>(GameMode.daily);