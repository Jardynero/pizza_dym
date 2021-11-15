// Contacts page

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _phoneWidth = MediaQuery.of(context).size.width;
    final _phone_height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SafeArea(
          child: Container(
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/pizzadym-5ad61.appspot.com/o/pizza%2Fbrezaola-2.jpg?alt=media&token=4cdfafb4-c4f1-46cb-b22a-fdaa0baf8d39',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      Flexible(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7),
                            // width: 250,
                            // height: 150,
                            // color: Colors.amberAccent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Брезаола',
                                    style: TextStyle(fontSize: 19)),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Томатный соус, моцарелла, брезаола, шпинат, пармезан, оливковое масло',
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text('690₽'),
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
        ),
      ],
    );
  }
}
