import 'package:basu/src/pages/consumer_stats_list_page.dart';
import 'package:basu/src/pages/environment_list_page.dart';
import 'package:basu/src/pages/consumer_list_page.dart';
import 'package:basu/src/pages/home_page.dart';
import 'package:basu/src/pages/topic_list_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final pageRoutes = <_Route>[
  _Route(FontAwesomeIcons.home, "Home", HomePage()),
  _Route(FontAwesomeIcons.comments, "Topics", TopicListPage(), environmentRequired: true),
  _Route(FontAwesomeIcons.sync, "Consumers", ConsumerListPage(), environmentRequired: true),
  _Route(FontAwesomeIcons.tools, "Environments", EnvironmentPage()),
  _Route(FontAwesomeIcons.chartBar, "Stats", ConsumerStatsListPage(), environmentRequired: true),
];

class _Route {
  final IconData icon;
  final String title;
  final Widget page;
  final bool environmentRequired;

  _Route(this.icon, this.title, this.page, {this.environmentRequired = false});
}
