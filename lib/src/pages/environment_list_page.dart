import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/environment_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/services/environment_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'new_environment_page.dart';

class EnvironmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ChangeNotifierProvider(
          create: (_) => _EnvironmentListPage(),
          child: _EnvironmentList(),
        ),
      ),
    );
  }
}

class _EnvironmentList extends StatefulWidget {
  @override
  __EnvironmentListState createState() => __EnvironmentListState();
}

class __EnvironmentListState extends State<_EnvironmentList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<_EnvironmentListPage>(context).searchEnvironment = () {
      this.setState(() {});
    };

    return SliderPageWrapper(
      future: EnvironmentService().getAll(),
      header: _Header(),
      getChildren: (List<Environment> data) {
        return List.generate(
          data.length,
          (i) => _Environment(
            environment: data[i],
            onDismiss: () async {
              final String result = await EnvironmentService().delete(data.elementAt(i).name);
              if (result == null) {
                showSuccessSnackbar(context, "Environment removed");
              } else {
                return showErrorSnackbar(context, result);
              }

              try {
                final configurationProvider = Provider.of<ConfigurationProvider>(context, listen: false);
                if (configurationProvider.environment != null &&
                    configurationProvider.environment.name == data.elementAt(i).name) {
                  await EnvironmentService().setDefault(null);
                  configurationProvider.environment = null;
                }
              } catch (e) {
                print(e);
              }
              data.removeAt(i);
              setState(() {});
            },
            activateEnvironment: () async {
              final configurationProvider = Provider.of<ConfigurationProvider>(context, listen: false);
              configurationProvider.environment = data.elementAt(i);
              final result = await EnvironmentService().setDefault(data.elementAt(i));
              if (result == null) {
                showSuccessSnackbar(context, "Environment set");
              } else {
                showErrorSnackbar(context, result);
              }
            },
          ),
        );
      },
    );
  }
}

class _Environment extends StatelessWidget {
  final Environment environment;
  final Function onDismiss;
  final Function activateEnvironment;

  const _Environment({this.environment, this.onDismiss, this.activateEnvironment});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    final Environment currentEnvironment = Provider.of<ConfigurationProvider>(context).environment;

    return Dismissible(
      key: Key(environment.name),
      direction: DismissDirection.startToEnd,
      background: Container(color: Colors.red),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.005),
        child: ListTile(
          title: Text(this.environment.name, style: TextStyle(fontSize: size.height * 0.035)),
          subtitle: Text(this.environment.baseUrl),
          leading: Icon(FontAwesomeIcons.tools, size: size.height * 0.05),
          tileColor: currentEnvironment != null && currentEnvironment.name == this.environment.name
              ? appTheme.accentColor.withOpacity(0.3)
              : appTheme.accentColor.withOpacity(0.1),
          onTap: () {
            showInfoSnackbar(context, "No extra info\nSlide right to remove\nHold to select");
          },
          onLongPress: () {
            activateEnvironment.call();
          },
        ),
      ),
      onDismissed: (direction) {
        onDismiss.call();
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlainTitleHeader(
      title: 'Environment',
      subtitle: 'List of environments',
      buttons: [
        GestureIcon(
          iconData: Icons.refresh,
          color: Colors.green,
          onTap: () {
            Provider.of<_EnvironmentListPage>(context, listen: false).searchEnvironment.call();
          },
        ),
        GestureIcon(
          iconData: Icons.add_circle_outline,
          color: Colors.blue,
          onTap: () async {
            final result = await Navigator.push(
                context, CupertinoPageRoute(builder: (BuildContext context) => NewEnvironmentPage()));
            if (result != null) {
              Provider.of<_EnvironmentListPage>(context, listen: false).searchEnvironment.call();
              showSuccessSnackbar(context, result);
            }
          },
        ),
      ],
    );
  }
}

class _EnvironmentListPage with ChangeNotifier {
  Function _searchEnvironment;

  Function get searchEnvironment => this._searchEnvironment;

  set searchEnvironment(Function value) {
    this._searchEnvironment = value;
  }
}
