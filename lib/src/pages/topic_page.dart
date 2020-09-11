import 'dart:convert';

import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/environment_model.dart';
import 'package:basu/src/models/message_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/providers/topic_provider.dart';
import 'package:basu/src/services/environment_service.dart';
import 'package:basu/src/services/message_service.dart';
import 'package:basu/src/services/topic_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/dynamic_text.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              _TopicBasicInfo(),
              _TopicPushConfigurationInfo(),
              _TopicConsumersInfo(),
            ];
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final topic = Provider.of<TopicProvider>(context).topic;

    return PlainTitleHeader(
      title: 'Topic',
      subtitle: 'Details of topic',
      buttons: [
        GestureIcon(
          iconData: Icons.chevron_left,
          color: appTheme.currentTheme.accentColor,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureIcon(
          onTap: () async {
            final Message message = Message.build();
            message.headers.putIfAbsent("test_header_name", () => "test_header_value");
            message.data.putIfAbsent("test_data_name", () => "test_data_value");
            final result = await MessageService().create(context, topic.id, message);
            if (result == null) {
              showSuccessSnackbar(context, 'Message send');
            } else {
              showErrorSnackbar(context, 'Failed to send message');
            }
          },
          iconData: Icons.mail_outline,
          color: Colors.blue,
        ),
        GestureIcon(
          iconData: Icons.content_copy,
          color: Colors.blue,
          onTap: () async {
            final currentEnvironment = Provider.of<ConfigurationProvider>(context, listen: false).environment;
            List<Environment> environments = await EnvironmentService().getAll();
            environments = environments.where((environtment) => environtment.name != currentEnvironment.name).toList();
            if (environments.length < 1) {
              return showErrorSnackbar(context, "At least 2 environments are required");
            }

            showModalPicker(
              context: context,
              options: environments,
              values: List.generate(environments.length, (index) => environments.elementAt(index).name),
              field: "name",
              onConfirm: (environment) async {
                final result = await TopicService().copy(context, topic, baseUrl: environment.baseUrl);
                if (result != null) {
                  showErrorSnackbar(context, result);
                } else {
                  showSuccessSnackbar(context, "Copy success");
                }
              },
            );
          },
        ),
        GestureIcon(
          onTap: () async {
            final result = await TopicService().delete(context, topic.id);

            if (result) {
              Navigator.pop(context, 'Topic deleted');
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to delete topic')));
            }
          },
          iconData: Icons.remove_circle_outline,
          color: Colors.red,
        ),
      ],
    );
  }
}

class _TopicBasicInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topic = Provider.of<TopicProvider>(context).topic;
    final size = MediaQuery.of(context).size;

    return BasicCard(
      title: 'Basic info',
      child: Table(
        children: [
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Id ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.id),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Virtual host ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.vhost),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Type ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.type),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Durability ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.durability.toString()),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(
                    text: "Autodelete ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.autoDelete.toString()),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Internal ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: topic.internal.toString()),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopicPushConfigurationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topic = Provider.of<TopicProvider>(context).topic;
    final size = MediaQuery.of(context).size;

    if (topic.pushConfiguration == null ||
        topic.pushConfiguration.urls == null ||
        topic.pushConfiguration.urls.length == 0) return Container();

    return BasicCard(
      title: 'Push configuration info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DynamicText(children: [
            TextSpan(text: "Retries ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
            TextSpan(
                text: topic.pushConfiguration.attempsLimit == null
                    ? "0"
                    : topic.pushConfiguration.attempsLimit.toString()),
          ]),
          ...topic.pushConfiguration.urls.map(
            (url) => DynamicText(children: [
              TextSpan(text: "Path ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
              TextSpan(text: url),
            ]),
          )
        ],
      ),
    );
  }
}

class _TopicConsumersInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topic = Provider.of<TopicProvider>(context).topic;

    if (topic.bindings == null) return Container();

    return BasicCard(
      title: 'Consumers Info',
      child: Column(
        children: List.generate(
          topic.bindings.length,
          (index) => _BindingTile(topic.bindings[index].destination),
        ),
      ),
    );
  }
}

class _BindingTile extends StatelessWidget {
  final String name;

  const _BindingTile(this.name);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListTile(
      title: Text(this.name),
      leading: Icon(FontAwesomeIcons.sync, size: size.height * 0.04),
      onTap: () {},
    );
  }
}
