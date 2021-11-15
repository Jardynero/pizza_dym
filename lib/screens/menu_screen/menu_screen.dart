import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sortedmap/sortedmap.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void initState() {
    super.initState();
  }

  final Stream<QuerySnapshot> restaurantDb =
      FirebaseFirestore.instance.collection('restaurant').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: restaurantDb,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final restaurantDb = snapshot.data!.docs;
          Map restaurantMenu = restaurantDb[1].get('menu');
          Map restaurantMenuSorted = {};
          int counter = 1;
          while (counter != restaurantMenu.length + 1) {
            restaurantMenuSorted[counter] = restaurantMenu['$counter'];
            counter++;
          }
          return TabBarView(
            children: [
              for (String categorie in restaurantDb[0].get('categories'))
                Container(
                  // margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 1.9,
                    mainAxisSpacing: 7,
                    children: [
                      for (final itemData in restaurantMenuSorted.values)
                        if (categorie == itemData[3])
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shadowColor: Color(0xffE1E0E0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 4,
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Image.network(
                                          '${itemData[4]}',
                                          height: 150,
                                          width: 150,
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 7),
                                            // width: 250,
                                            // height: 150,
                                            // color: Colors.amberAccent,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('${itemData[0]}',
                                                    style: TextStyle(
                                                        fontSize: 19)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  child: Text(
                                                    '${itemData[1]}',
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  height: 35,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text('${itemData[2]}₽'),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                )
            ],
          );
        });
  }
}
