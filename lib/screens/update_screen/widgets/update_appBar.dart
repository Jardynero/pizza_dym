import 'package:flutter/material.dart';

class UpdateAppBar extends StatelessWidget implements PreferredSizeWidget{
  const UpdateAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Обновление приложения', style: Theme.of(context).textTheme.headline6),
      elevation: 4,
      shadowColor: Colors.grey[100],
      automaticallyImplyLeading: false,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}