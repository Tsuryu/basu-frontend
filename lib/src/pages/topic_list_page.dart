import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/topic_model.dart';
import 'package:basu/src/pages/topic_page.dart';
import 'package:basu/src/providers/topic_provider.dart';
import 'package:basu/src/services/topic_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'new_topic_page.dart';

class TopicListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ChangeNotifierProvider(
          create: (_) => _TopicListPage(),
          child: _TopicList(),
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  @override
  __HeaderState createState() => __HeaderState();
}

class __HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(
      title: 'Topic',
      subtitle: 'List of all topics',
      buttons: [
        GestureIcon(
          iconData: Icons.refresh,
          color: Colors.green,
          onTap: () {
            Provider.of<_TopicListPage>(context, listen: false).searchTopics.call();
          },
        ),
        GestureIcon(
          iconData: Icons.add_circle_outline,
          color: Colors.blue,
          onTap: () async {
            final result =
                await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => NewTopicPage()));
            if (result != null) {
              Provider.of<_TopicListPage>(context, listen: false).searchTopics.call();
              showSuccessSnackbar(context, result);
            }
          },
        ),
      ],
    );
  }
}

class _TopicList extends StatefulWidget {
  @override
  __TopicListState createState() => __TopicListState();
}

class __TopicListState extends State<_TopicList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<_TopicListPage>(context).searchTopics = () {
      this.setState(() {});
    };

    return SliderPageWrapper(
      future: TopicService().findAll(context),
      header: _Header(),
      getChildren: (data) {
        return List.generate(data.length, (i) => _Topic(topic: data[i]));
      },
    );
  }
}

class _Topic extends StatelessWidget {
  final Topic topic;

  const _Topic({this.topic});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.005),
      child: ListTile(
        title: Text(this.topic.id, style: TextStyle(fontSize: size.height * 0.035)),
        subtitle: Text(topic.pushConfiguration.urls != null ? "Push" : "Pull"),
        leading: Icon(FontAwesomeIcons.comments, size: size.height * 0.05),
        trailing: topic.pushConfiguration.urls != null
            ? Icon(FontAwesomeIcons.longArrowAltRight, size: size.height * 0.05)
            : Icon(FontAwesomeIcons.longArrowAltLeft, size: size.height * 0.05),
        tileColor: appTheme.accentColor.withOpacity(0.1),
        onTap: () {
          openTopicDetails(context, topic);
        },
      ),
    );
  }
}

Function openTopicDetails = (BuildContext context, Topic topic) async {
  final topicModel = Provider.of<TopicProvider>(context, listen: false);
  topicModel.topic = topic;
  final result = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => TopicPage()));

  if (result != null) {
    Provider.of<_TopicListPage>(context, listen: false).searchTopics.call();
    showSuccessSnackbar(context, result);
  }
};

class _TopicListPage with ChangeNotifier {
  Function _searchTopics;

  Function get searchTopics => this._searchTopics;

  set searchTopics(Function value) {
    this._searchTopics = value;
  }
}
