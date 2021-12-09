import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/appBar-actions.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const MainAppBar(this.appBarTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Text(
        '$appBarTitle',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.visible,
        ),
      ),
      centerTitle: appBarTitle.length > 18 ? false : true,
      elevation: 1,
      actions: [
        profileAppBarAction(context),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class MenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  const MenuAppBar(this.appBarTitle, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Text(
        '$appBarTitle',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.visible,
        ),
      ),
      centerTitle: appBarTitle.length > 18 ? false : true,
      elevation: 1,
      actions: [
        menuAppBarAction(context),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}