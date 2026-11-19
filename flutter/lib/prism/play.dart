// Prism: "Play" button. Launches Moonlight if installed; placeholder otherwise.
import 'dart:io';

import 'package:flutter/material.dart';

import '../common.dart';
import '../models/platform_model.dart';

bool _isRu() => bind.mainGetLocalOption(key: 'lang') != 'en';

String prismPlayLabel() => _isRu() ? 'Играть' : 'Play';

String? _findMoonlight() {
  final candidates = <String>[
    '${Platform.environment['ProgramFiles'] ?? r'C:\Program Files'}\\Moonlight Game Streaming\\Moonlight.exe',
    '${Platform.environment['LOCALAPPDATA'] ?? ''}\\Programs\\Moonlight Game Streaming\\Moonlight.exe',
  ];
  for (final p in candidates) {
    if (File(p).existsSync()) return p;
  }
  return null;
}

Future<void> prismLaunchPlay() async {
  final exe = Platform.isWindows ? _findMoonlight() : null;
  if (exe != null) {
    try {
      await Process.start(exe, [], mode: ProcessStartMode.detached);
      return;
    } catch (_) {}
  }
  showToast(_isRu()
      ? 'Игровой режим (Moonlight) будет подключён позже'
      : 'Game mode (Moonlight) is coming later');
}

Widget prismPlayButton() {
  return SizedBox(
    height: 28.0,
    child: OutlinedButton.icon(
      onPressed: prismLaunchPlay,
      style: OutlinedButton.styleFrom(
        foregroundColor: MyTheme.accent,
        side: const BorderSide(color: MyTheme.accent),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
      icon: const Icon(Icons.sports_esports_outlined, size: 16),
      label: Text(prismPlayLabel()),
    ),
  );
}
