import 'package:flutter/material.dart';

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
          overflow: TextOverflow.ellipsis,
        ),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: Colors.grey[100],
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
      automaticallyImplyLeading: true,
      leading: IconButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false), icon: Icon(Icons.arrow_back_ios,)),
      centerTitle: appBarTitle.length > 18 ? false : true,
      elevation: 4,
      shadowColor: Colors.grey[100],

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}