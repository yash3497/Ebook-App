// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ebook_app/model/catalog.dart';
import 'package:ebook_app/widget/reading_card_list.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(const Duration(seconds: 2));
    await firestore
        .collection('Book')
        .get()
        .then((QuerySnapshot querySnapshot) {
      CatalogModel.items.clear();
      for (var doc in querySnapshot.docs) {
        Item item = Item(doc["image"], doc["title"], doc["auth"], doc["rating"],
            doc["bookId"]);
        CatalogModel.items.add(item);
      }
    });
    if (mounted) {
      setState(
        () {
          /* ... */
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/main_page_bg.png"),
            alignment: Alignment.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * .1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline4,
                  children: [
                    TextSpan(text: "What are you \nreading "),
                    TextSpan(
                        text: "today?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                  ],
                ),
              ),
            ),
            30.0.heightBox,
            Container(
              width: double.infinity,
              height: 285,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: CatalogModel.items.length,
                itemBuilder: (context, index) {
                  final catalog = CatalogModel.items[index];
                  return Row(
                    children: <Widget>[
                      ReadingListCard(
                          catalog: catalog,
                          pressDetails: () {},
                          pressRead: () {}),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
