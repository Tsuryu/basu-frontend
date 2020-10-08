import 'dart:async';

import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/pages/home_page.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/providers/consumer_provider.dart';
import 'package:basu/src/providers/topic_provider.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sentry/sentry.dart';

final sentry = SentryClient(dsn: "https://4400559313f0428eaa0b2cb53f682607@o450009.ingest.sentry.io/5433966");

void main() async {
  runZonedGuarded(
    () => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TopicProvider()),
        ChangeNotifierProvider(create: (_) => ConsumerProvider()),
        ChangeNotifierProvider(create: (_) => ConfigurationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChanger(2)),
      ],
      child: MyApp(),
    )),
    (error, stackTrace) async {
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    changeStatusLight();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Basu',
      theme: appTheme.currentTheme,
      // home: TopicListPage(),
      home: HomePage(),
    );
  }
}
