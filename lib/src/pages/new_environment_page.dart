import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/environment_model.dart';
import 'package:basu/src/services/environment_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/common_text_form_field.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEnvironmentPage extends StatelessWidget {
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
      title: 'Environment',
      subtitle: 'Details of environment',
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
        create: (_) => NewEnvironmentProvider(),
        child: _NewEnvironmentForm(),
      ),
    );
  }
}

class _NewEnvironmentForm extends StatefulWidget {
  @override
  __NewEnvironmentFormState createState() => __NewEnvironmentFormState();
}

class __NewEnvironmentFormState extends State<_NewEnvironmentForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final environmentProvider = Provider.of<NewEnvironmentProvider>(context);
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CommonTextFormField(
              label: 'Name',
              validateEmpty: true,
              onChange: (String value) {
                environmentProvider.name = value;
              },
            ),
            CommonTextFormField(
              label: 'Base url',
              validateEmpty: true,
              onChange: (String value) {
                environmentProvider.value = value;
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
                  final String result = await EnvironmentService().create(environmentProvider.getEnvironment());

                  if (result == null) {
                    Navigator.pop(context, 'Environment added');
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

class NewEnvironmentProvider with ChangeNotifier {
  String _name;
  String _baseUrl;

  get name => this._name;
  get baseUrl => this._baseUrl;

  set name(String value) {
    this._name = value;
  }

  set value(String value) {
    this._baseUrl = value;
  }

  Environment getEnvironment() {
    return Environment(name: this._name, baseUrl: this._baseUrl);
  }
}
