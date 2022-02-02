// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:ebook_app/consttant.dart';
import 'package:ebook_app/model/catalog.dart';
import 'package:ebook_app/screen/detail_screen.dart';
import 'package:ebook_app/widget/book_rating.dart';
import 'package:ebook_app/widget/reading_card_list.dart';
import 'package:ebook_app/widget/two_sided_round_button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late num maxValue = 0;

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
            doc["bookId"], doc["progress"], doc["desc"]);
        CatalogModel.items.add(item);
      }
    });

    late num max1 = 0;
    for (var i in CatalogModel.items) {
      num p = i.progress;
      max1 = max(max1, p);
    }

    maxValue = max1;

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
    var pos = CatalogModel.items
        .indexWhere((element) => element.progress == maxValue);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
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
                          TextSpan(
                              text: "What are you \nreading ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.68))),
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
                                pressDetails: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            bookId: catalog.bookId),
                                      ));
                                },
                                pressRead: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                            bookId: catalog.bookId),
                                      ));
                                }),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            children: [
                              TextSpan(
                                  text: "Best of the ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.68))),
                              TextSpan(
                                text: "day",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: CatalogModel.items.isNotEmpty ? 1 : 0,
                          itemBuilder: (context, index) {
                            return bestOfTheDayCard(
                                size, context, CatalogModel.items[3]);
                          },
                        ),
                        15.heightBox,
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline4,
                            children: [
                              TextSpan(text: "Continue "),
                              TextSpan(
                                text: "reading...",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        20.0.heightBox,
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 0),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: CatalogModel.items.isNotEmpty ? 1 : 0,
                          itemBuilder: (context, index) {
                            return continueReading(
                                size, context, CatalogModel.items[pos]);
                          },
                        ),
                        40.heightBox,
                      ],
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

  Container continueReading(Size size, BuildContext context, Item item) {
    var pro = item.progress;
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38.5),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 33,
            color: kShadowColor,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          item.title.text.bold.make(),
                          item.auth.text.color(kLightBlackColor).make(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: "Chapter $pro of 10"
                                .text
                                .color(kLightBlackColor)
                                .size(10)
                                .make(),
                          ),
                          5.heightBox,
                        ],
                      ),
                    ),
                    Image.network(
                      item.image,
                      width: 55,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 7,
              width: size.width * (item.progress / 10),
              decoration: BoxDecoration(
                color: kProgressIndicator,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context, Item item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: double.infinity,
      height: 255,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "New York Time Best For 25th January 2022",
                      style: TextStyle(
                        fontSize: 9,
                        color: kLightBlackColor,
                      ),
                    ),
                  ),
                  "Rich Dad \nPoor Dad".text.semiBold.xl3.make(),
                  Text(
                    "Robert Kiyosaki",
                    style: TextStyle(color: kLightBlackColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: BookRating(score: 4.6),
                        ),
                        Expanded(
                          child: Text(
                            "keep using your brain, work for free, soon your mind will show you ways of making money far beyond what I could ever pay you.....",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: kLightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 0,
            child: Image.network(
              item.image,
              fit: BoxFit.fill,
              width: 140,
              height: 190,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 45,
              width: size.width * .33,
              child: TwoSideRoundedButton(
                text: "Read",
                radious: 24,
                press: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
