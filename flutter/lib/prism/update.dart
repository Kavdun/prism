// Prism: update check against the self-hosted download site.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

import '../common.dart';
import '../models/platform_model.dart';

// Replaced by CI with the GitHub Actions run number.
const int kPrismBuild = 0;
const String kPrismSite = 'https://prism.g-chat.synology.me/';

bool _checked = false;

bool _isRu() => bind.mainGetLocalOption(key: 'lang') != 'en';

Future<void> prismCheckUpdate() async {
  if (_checked || kPrismBuild == 0) return;
  _checked = true;
  try {
    final r = await http
        .get(Uri.parse('${kPrismSite}version.json'))
        .timeout(const Duration(seconds: 10));
    if (r.statusCode != 200) return;
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    final build = (j['build'] as num?)?.toInt() ?? 0;
    if (build <= kPrismBuild) return;
    final url = (j['url'] as String?) ?? kPrismSite;
    final ru = _isRu();
    gFFI.dialogManager.show((setState, close, context) {
      return CustomAlertDialog(
        title: Text(ru ? 'Доступно обновление Prism' : 'Prism update available'),
        content: Text(ru
            ? 'Вышла новая сборка #$build (у вас #$kPrismBuild). Скачать?'
            : 'New build #$build is available (you have #$kPrismBuild). Download?'),
        actions: [
          dialogButton(ru ? 'Позже' : 'Later', onPressed: close, isOutline: true),
          dialogButton(ru ? 'Скачать' : 'Download', onPressed: () {
            close();
            launchUrlString(url);
          }),
        ],
        onCancel: close,
      );
    });
  } catch (_) {}
}
