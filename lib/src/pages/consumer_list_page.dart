import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/models/consumer_model.dart' as ConsumerModel;
import 'package:basu/src/pages/consumer_page.dart';
// import 'package:basu/src/pages/consumer_page.dart';
import 'package:basu/src/providers/consumer_provider.dart';
import 'package:basu/src/services/consumer_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'new_consumer_page.dart';

class ConsumerListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ChangeNotifierProvider(
          create: (_) => _ConsumerListPage(),
          child: _ConsumerList(),
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
      title: 'Consumer',
      subtitle: 'List of all consumers',
      buttons: [
        GestureIcon(
          iconData: Icons.refresh,
          color: Colors.green,
          onTap: () {
            Provider.of<_ConsumerListPage>(context, listen: false).searchConsumers.call();
          },
        ),
        GestureIcon(
          iconData: Icons.add_circle_outline,
          color: Colors.blue,
          onTap: () async {
            final result =
                await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => NewConsumerPage()));
            if (result != null) {
              Provider.of<_ConsumerListPage>(context, listen: false).searchConsumers.call();
              showSuccessSnackbar(context, result);
            }
          },
        ),
      ],
    );
  }
}

class _ConsumerList extends StatefulWidget {
  @override
  __ConsumerListState createState() => __ConsumerListState();
}

class __ConsumerListState extends State<_ConsumerList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<_ConsumerListPage>(context).searchConsumers = () {
      this.setState(() {});
    };

    return SliderPageWrapper(
      future: ConsumerService().findAll(context),
      header: _Header(),
      getChildren: (data) {
        return List.generate(data.length, (i) => _Consumer(consumer: data[i]));
      },
    );
  }
}

class _Consumer extends StatelessWidget {
  final ConsumerModel.Consumer consumer;

  const _Consumer({this.consumer});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.005),
      child: ListTile(
        title: Text(this.consumer.id, style: TextStyle(fontSize: size.height * 0.035)),
        subtitle: Text(consumer.pushConfiguration.urls != null ? "Push" : "Pull"),
        leading: Icon(FontAwesomeIcons.sync, size: size.height * 0.05),
        trailing: consumer.pushConfiguration.urls != null
            ? Icon(FontAwesomeIcons.longArrowAltRight, size: size.height * 0.05)
            : Icon(FontAwesomeIcons.longArrowAltLeft, size: size.height * 0.05),
        tileColor: appTheme.accentColor.withOpacity(0.1),
        onTap: () {
          openConsumerDetails(context, consumer);
        },
      ),
    );
  }
}

Function openConsumerDetails = (BuildContext context, ConsumerModel.Consumer consumer) async {
  final consumerModel = Provider.of<ConsumerProvider>(context, listen: false);
  consumerModel.consumer = consumer;
  final result = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ConsumerPage()));

  if (result != null) {
    Provider.of<_ConsumerListPage>(context, listen: false).searchConsumers.call();
    showSuccessSnackbar(context, result);
  }
};

class _ConsumerListPage with ChangeNotifier {
  Function _searchConsumers;

  Function get searchConsumers => this._searchConsumers;

  set searchConsumers(Function value) {
    this._searchConsumers = value;
  }
}
