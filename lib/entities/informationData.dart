import 'package:flutter/material.dart';
import 'package:rada_egerton/theme.dart';

class InformationCategory {
  String name;
  String id;
  InformationCategory(this.id, this.name);
}

class InformationData {
  InformationMetadata metadata;
  List<InformationContent> content;

  InformationData({
    required this.metadata,
    required this.content,
  });

  factory InformationData.fromJson(Map<String, dynamic> json) {
    Iterable content = json["content"];
    List<InformationContent> informationContent = List<InformationContent>.from(
        content.map((item) => InformationContent.fromJson(item)));
    InformationMetadata metadata =
        InformationMetadata.fromJson(json["metadata"]);
    return InformationData(
      metadata: metadata,
      content: informationContent,
    );
  }
}

class InformationMetadata {
  String title;
  String category;
  String thumbnail;
  InformationMetadata({
    required this.title,
    required this.category,
    required this.thumbnail,
  });
  factory InformationMetadata.fromJson(Map<String, dynamic> json) {
    return InformationMetadata(
        title: json["title"],
        category: json["category"].toString(),
        thumbnail: json["thumbnail"]);
  }
}

class InformationContent {
  String? subtitle;
  String bodyContent;
  String type;
  ContentAttributes attributes;
  InformationContent(
      {required this.subtitle,
      required this.type,
      required this.bodyContent,
      required this.attributes});
  factory InformationContent.fromJson(Map<String, dynamic> json) {
    return InformationContent(
        bodyContent:
            json["insert"] is String ? json["insert"] : json["insert"]["image"],
        type: json["insert"] is String
            ? InformationContent.text
            : InformationContent.image,
        attributes: json["attributes"] == null
            ? ContentAttributes()
            : ContentAttributes.fromJson(json["attributes"]),
        subtitle: json["subtitle"]);
  }
  //generate text style from attributes
  TextStyle get getTextStyle {
    TextStyle style = TextStyle(fontSize: 14.0, color: Palette.lightTextColor);
    if (this.attributes.bold != null) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    if (this.attributes.italic != null) {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }
    if (this.attributes.color != null) {
      style = style.copyWith(color: HexColor(this.attributes.color!));
    }

    if (this.attributes.header == 1) {
      style = style.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      );
    }
    if (this.attributes.header == 2) {
      style = style.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      );
    }

    if (this.attributes.strike != null) {
      style = style.copyWith(decoration: TextDecoration.lineThrough);
    }
    if (this.attributes.underline != null) {
      style = style.copyWith(decoration: TextDecoration.underline);
    }

    return style;
  }

  //information type
  static String list = "0";
  static String image = "1";
  static String text = "2";
  static String title = "3";
}

class ContentAttributes {
  String? align;
  bool? bold;
  bool? italic;
  String? color;
  int? header;
  String? image;
  String? list;
  String? link;
  bool? strike;
  bool? underline;
  int? indent;

  ContentAttributes(
      {this.align,
      this.bold,
      this.image,
      this.header,
      this.color,
      this.list,
      this.italic,
      this.indent,
      this.underline,
      this.strike,
      this.link});
  factory ContentAttributes.fromJson(Map<String, dynamic> json) {
    return ContentAttributes(
        align: json["align"],
        bold: json["bold"],
        list: json["list"],
        image: json["image"],
        italic: json["italic"],
        color: json["color"],
        link: json["link"],
        header: json["header"],
        strike: json["strike"],
        indent: json["intent"],
        underline: json["underline"]);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
