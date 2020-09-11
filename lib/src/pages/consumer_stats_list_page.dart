import 'package:basu/src/models/consumer_stats_model.dart';
import 'package:basu/src/services/consumer_stats_service.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:basu/src/widgets/basic_card.dart';
import 'package:basu/src/widgets/dynamic_text.dart';
import 'package:basu/src/widgets/gesture_icon.dart';
import 'package:basu/src/widgets/plain_title_header.dart';
import 'package:basu/src/widgets/slider_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumerStatsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ChangeNotifierProvider(
          create: (_) => _ConsumerStatsListPage(),
          child: _ConsumerStatsList(),
        ),
      ),
    );
  }
}

class _ConsumerStatsList extends StatefulWidget {
  @override
  __ConsumerStatsListState createState() => __ConsumerStatsListState();
}

class __ConsumerStatsListState extends State<_ConsumerStatsList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<_ConsumerStatsListPage>(context)._searchCunsumerStats = () {
      this.setState(() {});
    };

    return SliderPageWrapper(
      future: ConsumerStatsService().findAll(context),
      header: _Header(),
      getChildren: (data) {
        return List.generate(data.length, (i) => _ConsumerStat(consumerStats: data[i]));
      },
    );
  }
}

class _ConsumerStat extends StatelessWidget {
  final ConsumerStats consumerStats;

  const _ConsumerStat({this.consumerStats});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;
    return BasicCard(
      color: consumerStats.unacknowledged > 2 ? Colors.red.withOpacity(0.3) : null,
      title: consumerStats.id,
      footer: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {},
              child: Text(
                'Purge',
                style: TextStyle(color: appTheme.textTheme.bodyText1.color, fontSize: size.height * 0.03),
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () {},
              child: Text(
                'Resend',
                style: TextStyle(color: appTheme.textTheme.bodyText1.color, fontSize: size.height * 0.03),
              ),
            ),
          ),
        ],
      ),

      // TableRow(children: [
      //   MaterialButton(onPressed: () {}, child: Text('Purge')),
      //   MaterialButton(onPressed: () {}, child: Text('Resend')),
      // ]),
      child: Table(
        children: [
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Total ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.total.toString()),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Published ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.published.toString()),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(text: "Ready ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.ready.toString()),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Requests ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.requestAmount.toString()),
              ]),
            ],
          ),
          TableRow(
            children: [
              DynamicText(children: [
                TextSpan(
                    text: "Unaknowledged ",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.unacknowledged.toString()),
              ]),
              DynamicText(children: [
                TextSpan(
                    text: "Aknowledged ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: size.height * 0.03)),
                TextSpan(text: consumerStats.acknowledged.toString()),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
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
            Provider.of<_ConsumerStatsListPage>(context, listen: false).searchCunsumerStats.call();
          },
        ),
      ],
    );
  }
}

class _ConsumerStatsListPage with ChangeNotifier {
  Function _searchCunsumerStats;

  Function get searchCunsumerStats => this._searchCunsumerStats;

  set searchCunsumerStats(Function value) {
    this._searchCunsumerStats = value;
  }
}
