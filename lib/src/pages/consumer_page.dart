import 'package:basu/src/providers/consumer_provider.dart';
import 'package:basu/src/services/consumer_service.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/dynamic_text.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SliderPageWrapper(
          header: _Header(),
          getChildren: () {
            return <Widget>[
              _BasicInfoForm(),
              _TopicPushConfigurationInfo(),
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
    final consumer = Provider.of<ConsumerProvider>(context).consumer;
    return PlainTitleHeader(
      title: 'Consumer',
      subtitle: 'Details of consumer',
      buttons: [
        GestureIcon(
          iconData: Icons.chevron_left,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        GestureIcon(
          onTap: () async {
            final result = await ConsumerService().delete(context, consumer.id);

            if (result) {
              Navigator.pop(context, 'Consumer deleted');
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to delete consumer')));
            }
          },
          iconData: Icons.remove_circle_outline,
          color: Colors.red,
        ),
      ],
    );
  }
}

class _BasicInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final consumer = Provider.of<ConsumerProvider>(context).consumer;
    final size = MediaQuery.of(context).size;

    return BasicCard(
      title: 'Basic info',
      child: Table(
        children: [
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Id ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.id),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Virtual host ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.vhost),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Type ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.type),
              ]),
              DynamicText(children: [
                TextSpan(text: "Durable ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.durable.toString()),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(
                    text: "Autodelete ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.autoDelete.toString()),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Exclusive ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumer.exclusive.toString()),
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
    final consumer = Provider.of<ConsumerProvider>(context).consumer;
    final size = MediaQuery.of(context).size;

    if (consumer.pushConfiguration == null ||
        consumer.pushConfiguration.urls == null ||
        consumer.pushConfiguration.urls.length == 0) return Container();

    return BasicCard(
      title: 'Push configuration info',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DynamicText(children: [
            TextSpan(text: "Retries ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
            TextSpan(
                text: consumer.pushConfiguration.attempsLimit == null
                    ? "0"
                    : consumer.pushConfiguration.attempsLimit.toString()),
          ]),
          ...consumer.pushConfiguration.urls.map(
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
