import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar-actions.dart';


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const MainAppBar(this.appBarTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$appBarTitle'),
      centerTitle: true,
      elevation: 4,
      actions: [
        profileAppBarAction(context),
      ],
    );
  }
  @override
  Size get preferredSize =>Size.fromHeight(kToolbarHeight);
}
