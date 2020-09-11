import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/environment_model.dart';
import 'package:basu/src/providers/configuration_provider.dart';
import 'package:basu/src/routes/routes.dart';
import 'package:basu/src/services/environment_service.dart';
import 'package:basu/src/services/health_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    initEnvironment();
    super.initState();
  }

  initEnvironment() async {
    final configurationProvider = Provider.of<ConfigurationProvider>(context, listen: false);
    final environment = await EnvironmentService().getDefault();
    configurationProvider.environment = environment;
  }

  @override
  Widget build(BuildContext context) {
    final Environment environment = Provider.of<ConfigurationProvider>(context).environment;

    return Scaffold(
      drawer: _MenuPrincipal(),
      body: Center(
        child: environment == null
            ? _StatusImage(connectionSuccess: null)
            : FutureBuilder(
                future: HealthService().healthcheck(context),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    return _StatusImage(connectionSuccess: snapshot.data);
                  } else {
                    return Loading();
                  }
                },
              ),
      ),
    );
  }
}

class _StatusImage extends StatelessWidget {
  final bool connectionSuccess;

  const _StatusImage({@required this.connectionSuccess});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context);
    final Environment environment = Provider.of<ConfigurationProvider>(context).environment;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          environment == null
              ? Icons.not_listed_location
              : !connectionSuccess ? FontAwesomeIcons.carCrash : FontAwesomeIcons.busAlt,
          color: connectionSuccess != null && !connectionSuccess ? Colors.red : appTheme.currentTheme.accentColor,
          size: size.height * 0.3,
        ),
        SizedBox(height: size.height * 0.03),
        if (environment != null)
          Text(
            environment.name,
            style: TextStyle(
              fontSize: size.height * 0.05,
              color: connectionSuccess != null && !connectionSuccess ? Colors.red : appTheme.currentTheme.accentColor,
            ),
          ),
      ],
    );
  }
}

class _ListaOpciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final environment = Provider.of<ConfigurationProvider>(context).environment;

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, i) => Divider(color: appTheme.primaryColorLight),
      itemCount: pageRoutes.length,
      itemBuilder: (context, i) => ListTile(
        leading: FaIcon(pageRoutes[i].icon, color: appTheme.accentColor),
        title: Text(pageRoutes[i].title),
        trailing: Icon(Icons.chevron_right, color: appTheme.accentColor),
        onTap: () {
          // pop para regresar
          if (pageRoutes[i].environmentRequired && environment == null) {
            return showInfoSnackbar(context, "Environment configuration required");
          }
          Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => pageRoutes[i].page));
        },
      ),
    );
  }
}

class _MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final accentColor = appTheme.currentTheme.accentColor;
    final size = MediaQuery.of(context).size;

    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.05),
        child: Column(
          children: [
            SafeArea(
              child: Container(
                width: double.infinity,
                height: 150.0,
                child: CircleAvatar(
                  backgroundColor: accentColor,
                  child: Text("SV", style: TextStyle(fontSize: 40.0)),
                ),
              ),
            ),
            Expanded(
              child: _ListaOpciones(),
            ),
          ],
        ),
      ),
    );
  }
}
