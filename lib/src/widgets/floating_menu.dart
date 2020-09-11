import 'package:basu/src/providers/floating_menu_provider.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingMenuButton {
  final Function onPressed;
  final IconData icon;

  FloatingMenuButton({@required this.onPressed, @required this.icon});
}

class FloatingMenu extends StatelessWidget {
  final Color inactiveColor;
  final List<FloatingMenuButton> items;

  FloatingMenu({
    this.inactiveColor = Colors.blueGrey,
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final show = Provider.of<FloatingMenuProvider>(context).show;

    return Positioned(
      bottom: size.height * 0.05,
      child: Container(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: 2),
            Flexible(
              flex: items.length * 2,
              child: ChangeNotifierProvider(
                create: (_) => _MenuModel(),
                child: AnimatedOpacity(
                  opacity: (show) ? 1 : 0,
                  duration: Duration(milliseconds: 250),
                  child: Builder(
                    builder: (context) {
                      Provider.of<_MenuModel>(context, listen: false).activeColor = appTheme.accentColor;
                      Provider.of<_MenuModel>(context, listen: false).inactiveColor = inactiveColor;
                      Provider.of<_MenuModel>(context, listen: false).backgroundColor = appTheme.backgroundColor;

                      return _FloatingMenuBackground(
                        child: _MenuItems(items),
                      );
                    },
                  ),
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class _FloatingMenuBackground extends StatelessWidget {
  final Widget child;
  _FloatingMenuBackground({@required this.child});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Provider.of<_MenuModel>(context).backgroundColor;

    return Container(
      child: child,
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: -5,
          ),
        ],
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final List<FloatingMenuButton> menuItems;

  _MenuItems(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(menuItems.length, (i) => _FloatingMenuButtom(i, menuItems[i])));
  }
}

class _FloatingMenuButtom extends StatelessWidget {
  final int index;
  final FloatingMenuButton item;

  _FloatingMenuButtom(this.index, this.item);

  @override
  Widget build(BuildContext context) {
    final itemSeleccionado = Provider.of<_MenuModel>(context).itemSeleccionado;
    final activeColor = Provider.of<_MenuModel>(context).activeColor;
    final inactiveColor = Provider.of<_MenuModel>(context).inactiveColor;

    return GestureDetector(
      onTap: () {
        Provider.of<_MenuModel>(context, listen: false).itemSeleccionado = index;
        item.onPressed();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Icon(
          item.icon,
          size: (itemSeleccionado == index) ? 35 : 25,
          color: (itemSeleccionado == index) ? activeColor : inactiveColor,
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  int _itemSeleccionado = 0;
  Color _backgroundColor;
  Color _activeColor;
  Color _inactiveColor;

  int get itemSeleccionado => this._itemSeleccionado;
  Color get backgroundColor => this._backgroundColor;
  Color get activeColor => this._activeColor;
  Color get inactiveColor => this._inactiveColor;

  set itemSeleccionado(int index) {
    this._itemSeleccionado = index;
    notifyListeners();
  }

  set backgroundColor(Color color) {
    this._backgroundColor = color;
  }

  set activeColor(Color color) {
    this._activeColor = color;
  }

  set inactiveColor(Color color) {
    this._inactiveColor = color;
  }
}
