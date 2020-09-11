import 'package:basu/src/helpers/util.dart';
import 'package:basu/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CommonTextFormField extends StatelessWidget {
  final Function onChange;
  final bool validateEmpty;
  final String label;
  final bool noSpaces;
  final String hint;

  const CommonTextFormField(
      {this.validateEmpty = false, this.onChange, this.label = '', this.noSpaces = false, this.hint});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context).currentTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.01),
      child: TextFormField(
        inputFormatters: this.noSpaces ? [FilteringTextInputFormatter(RegExp(r'[a-zA-Z0-9-_]'), allow: true)] : [],
        decoration: InputDecoration(
          isDense: true,
          labelText: this.label,
          border: OutlineInputBorder(),
          helperText: '',
          hintText: this.hint,
        ),
        validator: this.validateEmpty ? Util.formValidateEmpty : null,
        onChanged: this.onChange != null ? this.onChange : () {},
        style: appTheme.textTheme.bodyText1,
      ),
    );
  }
}
