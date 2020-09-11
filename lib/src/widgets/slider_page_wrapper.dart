import 'package:flutter/material.dart';

import 'loading.dart';

class SliderPageWrapper extends StatelessWidget {
  final Future<List<dynamic>> future;
  final Widget header;
  final Function getChildren;

  const SliderPageWrapper({this.future, @required this.header, this.getChildren});

  @override
  Widget build(BuildContext context) {
    return future != null
        ? _SliderPageWrapperFutureBuilder(future: future, header: header, getChildren: getChildren)
        : _SliderPageWrapperBuilder(header: header, getChildren: getChildren);
  }
}

class _SliderPageWrapperBuilder extends StatelessWidget {
  final Widget header;
  final Function getChildren;

  const _SliderPageWrapperBuilder({@required this.header, @required this.getChildren});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverPersistentHeader(
          floating: true,
          delegate: _SliverAppBarDelegate(
            minHeight: size.height * 0.2,
            maxHeight: size.height * 0.2,
            child: Container(padding: EdgeInsets.only(bottom: size.height * 0.01), child: this.header),
          ),
        ),
        SliverList(delegate: SliverChildListDelegate(this.getChildren == null ? [] : this.getChildren()))
      ],
    );
  }
}

class _SliderPageWrapperFutureBuilder extends StatelessWidget {
  const _SliderPageWrapperFutureBuilder({
    @required this.future,
    @required this.header,
    @required this.getChildren,
  });

  final Future<List> future;
  final Widget header;
  final Function getChildren;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: this.future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverAppBarDelegate(
                minHeight: size.height * 0.2,
                maxHeight: size.height * 0.2,
                child: Container(padding: EdgeInsets.only(bottom: size.height * 0.01), child: this.header),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(!snapshot.hasData
                  ? [SizedBox(height: size.height * 0.1), Loading()]
                  : this.getChildren(snapshot.data)),
            )
          ],
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
