import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemCardShimmer extends StatelessWidget {
  const ItemCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        shadowColor: Colors.grey[100],
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Color(0xffE6E8EB),
              highlightColor: Color(0xffF9F9FB),
              child: Image.asset('assets/img/pizzadym AppIcon.png')
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Color(0xffE6E8EB),
                      highlightColor: Color(0xffF9F9FB),
                      child: Text('Маргарита',
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xffE6E8EB),
                      highlightColor: Color(0xffF9F9FB),
                      child: Text(
                        'Томатный соус, моцарелла, салями, пармезан, оливковое масло',
                        style: Theme.of(context).textTheme.bodyText1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xffE6E8EB),
                      highlightColor: Color(0xffF9F9FB),
                      child: SizedBox(
                        width: 165,
                        height: 40,
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              '470 ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
