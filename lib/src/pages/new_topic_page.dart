import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/topic_model.dart';
import 'package:basu/src/services/topic_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/common_text_form_field.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTopicPage extends StatelessWidget {
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
    return PlainTitleHeader(
      title: 'Topic',
      subtitle: 'Details of topic',
      buttons: [
        GestureIcon(
          iconData: Icons.chevron_left,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class _BasicInfoForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicCard(
      title: 'Basic info',
      child: ChangeNotifierProvider(
        create: (_) => NewTopicProvider(),
        child: _NewTopicForm(),
      ),
    );
  }
}

class _NewTopicForm extends StatefulWidget {
  @override
  __NewTopicFormState createState() => __NewTopicFormState();
}

class __NewTopicFormState extends State<_NewTopicForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final topicProvider = Provider.of<NewTopicProvider>(context);
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextFormField(
              label: 'Id',
              validateEmpty: true,
              noSpaces: true,
              onChange: (String value) {
                topicProvider.id = value;
              },
            ),
            CommonTextFormField(
              label: 'Url',
              hint: '/stack/service/path',
              onChange: (String value) {
                topicProvider.url = value;
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.02),
              child: Text('Default consumer', style: TextStyle(fontSize: size.height * 0.025)),
            ),
            Container(
              padding: EdgeInsets.only(bottom: size.height * 0.02, left: size.width * 0.02),
              width: double.infinity,
              child: Row(
                children: [
                  Text('OFF'),
                  Switch(
                    value: topicProvider.defaultConsumer,
                    onChanged: (value) => topicProvider.defaultConsumer = value,
                  ),
                  Text('ON'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                elevation: 0.0,
                child: Text('Create', style: appTheme.textTheme.bodyText1),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    FocusManager.instance.primaryFocus.unfocus();
                    showErrorSnackbar(context, 'Invalid data');
                    return;
                  }
                  final String result = await TopicService().create(context, topicProvider.getTopic());

                  if (result == null) {
                    Navigator.pop(context, 'Topic created');
                  } else {
                    showErrorSnackbar(context, result);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewTopicProvider with ChangeNotifier {
  String _id;
  String _url;
  bool _defaultConsumer = false;

  get defaultConsumer => this._defaultConsumer;

  set defaultConsumer(bool value) {
    this._defaultConsumer = value;
    notifyListeners();
  }

  set url(String value) {
    this._url = value;
  }

  set id(String value) {
    this._id = value;
  }

  Topic getTopic() {
    final topic = Topic(id: this._id);
    if (this._url != null && this._url.isNotEmpty) {
      topic.pushConfiguration = PushConfiguration(urls: [this._url]);
    }
    topic.defaultConsumer = this._defaultConsumer;
    return topic;
  }
}
