import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/consumer_model.dart' as ConsumerModel;
import 'package:basu/src/models/consumer_model.dart';
import 'package:basu/src/services/consumer_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/common_text_form_field.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewConsumerPage extends StatelessWidget {
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
      title: 'Consumer',
      subtitle: 'Details of consumer',
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
        create: (_) => NewConsumerProvider(),
        child: _NewConsumerForm(),
      ),
    );
  }
}

class _NewConsumerForm extends StatefulWidget {
  @override
  __NewConsumerFormState createState() => __NewConsumerFormState();
}

class __NewConsumerFormState extends State<_NewConsumerForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final consumerProvider = Provider.of<NewConsumerProvider>(context);
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: 'Id',
              validateEmpty: true,
              noSpaces: true,
              onChange: (String value) {
                consumerProvider.id = value;
              },
            ),
            CommonTextFormField(
              label: 'Topic id',
              validateEmpty: true,
              noSpaces: true,
              onChange: (String value) {
                consumerProvider.topicId = value;
              },
            ),
            CommonTextFormField(
              label: 'Url',
              hint: '/stack/service/path',
              onChange: (String value) {
                consumerProvider.url = value;
              },
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
                  final String result = await ConsumerService().create(context, consumerProvider.getConsumer());

                  if (result == null) {
                    Navigator.pop(context, 'Consumer created');
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

class NewConsumerProvider with ChangeNotifier {
  String _topicId;
  String _id;
  String _url;

  set topicId(String value) {
    this._topicId = value;
  }

  set url(String value) {
    this._url = value;
  }

  set id(String value) {
    this._id = value;
  }

  ConsumerModel.Consumer getConsumer() {
    final consumer = ConsumerModel.Consumer(id: this._id);
    if (this._url != null && this._url.isNotEmpty) {
      consumer.pushConfiguration = PushConfiguration(urls: [this._url]);
    }
    consumer.topicId = this._topicId;
    return consumer;
  }
}
