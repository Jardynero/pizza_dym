import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmallItemCardShimmer extends StatelessWidget {
  const SmallItemCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shadowColor: Colors.grey[300],
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Color(0xffE6E8EB),
              highlightColor: Color(0xffF9F9FB),
              child: Image.asset('assets/img/pizzadym AppIcon.png'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Shimmer.fromColors(
                    baseColor: Color(0xffE6E8EB),
                    highlightColor: Color(0xffF9F9FB),
                    child: Text('Маргарита',
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  Shimmer.fromColors(
                    baseColor: Color(0xffE6E8EB),
                    highlightColor: Color(0xffF9F9FB),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('350 ₽'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
