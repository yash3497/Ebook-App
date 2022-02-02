// ignore_for_file: prefer_const_constructors

import 'package:ebook_app/consttant.dart';
import 'package:ebook_app/model/catalog.dart';
import 'package:ebook_app/widget/book_rating.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BookInfo extends StatelessWidget {
  final Size size;
  final Item catalog;
  const BookInfo({Key? key, required this.size, required this.catalog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int len = catalog.title.length ~/ 2;
    return Container(
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: catalog.title
                      .substring(0, len)
                      .text
                      .headline4(context)
                      .size(28)
                      .make(),
                ),
                Container(
                  margin: EdgeInsets.only(top: this.size.height * .005),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 0),
                  child: catalog.title
                      .substring(len, catalog.title.length)
                      .text
                      .subtitle1(context)
                      .bold
                      .size(28)
                      .make(),
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * .3,
                          padding: EdgeInsets.only(top: size.height * .02),
                          child: catalog.desc.text
                              .size(10)
                              .color(kLightBlackColor)
                              .maxLines(5)
                              .make(),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * .015),
                          height: 40,
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: FlatButton(
                            onPressed: () {},
                            child: "Read".text.bold.make(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.grey,
                            )),
                        BookRating(score: double.parse(catalog.rating)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(right: 5),
              color: Colors.transparent,
              child: Image.network(
                catalog.image,
                height: double.infinity,
                alignment: Alignment.topRight,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
