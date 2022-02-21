import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pizza_dym/global_widgets/widgets.dart';

class MenuAppBar extends StatefulWidget {
  final List categories;
  final List<GlobalKey> categoriesKeys;
  MenuAppBar({
    Key? key,
    required this.categories,
    required this.categoriesKeys,
  }) : super(key: key);

  @override
  State<MenuAppBar> createState() => _MenuAppBarState();
}

class _MenuAppBarState extends State<MenuAppBar> {
  GlobalKey _bbq = GlobalKey();
  GlobalKey _neapolitana = GlobalKey();
  GlobalKey _sitsiliya = GlobalKey();
  GlobalKey _soups = GlobalKey();
  GlobalKey _extras = GlobalKey();
  GlobalKey _drinks = GlobalKey();
  late List<GlobalKey> _chipsKeys;

  @override
  void initState() {
    super.initState();
    _chipsKeys =
        _chipsKeys = [_bbq, _neapolitana, _sitsiliya, _soups, _extras, _drinks];
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Color(0xff26282B),
      elevation: 4,
      shadowColor: Colors.grey[100],
      pinned: true,
      floating: true,
      expandedHeight: 230,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/img/company-logo black.png',
          fit: BoxFit.contain,
        ),
      ),
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        child: Container(
          color: Colors.white,
          height: 50,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: ActionChip(
                  key: _chipsKeys[index],
                  onPressed: () {
                    try {
                      Scrollable.ensureVisible(
                        widget.categoriesKeys[index].currentContext!,
                        alignment: 0.0,
                        duration: Duration(milliseconds: 400),
                      );
                    } catch (e) {
                      debugPrint(
                        '$e, - в категории ${widget.categories[index]} пока нет товаров',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        reUsableSnackBar(
                          'В этой категории товары появятся совсем скоро!',
                          context,
                        ),
                      );
                    }
                  },
                  label: Text(widget.categories[index]),
                  backgroundColor: Colors.grey[50],
                  labelStyle: TextStyle(color: Color(0xffFF9F38)),
                  elevation: 0,
                ),
              );
            },
            itemCount: widget.categories.length,
            scrollDirection: Axis.horizontal,
            dragStartBehavior: DragStartBehavior.down,
          ),
        ),
        preferredSize: Size.fromHeight(50.0),
      ),
    );
  }
}
