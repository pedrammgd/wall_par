import 'package:flutter/material.dart';

class Category {
  String name;
  AssetImage image;

  Category({
    required this.name,
    required this.image,
  });
}

List<Category> categoryList = [
  Category(
    image: AssetImage("assets/image/hollywood.jpg"),
    name: "Dark",
  ),
  Category(
    image: AssetImage("assets/image/Christmas.jpeg"),
    name: "Christmas",
  ),
  Category(
    image: AssetImage("assets/image/art.jpg"),
    name: "Art",
  ),
  Category(
    image: AssetImage("assets/image/animal.jpg"),
    name: "Animals",
  ),
  Category(
    image: AssetImage("assets/image/pizza.jpg"),
    name: "Food",
  ),
  Category(
    image: AssetImage("assets/image/travel.jpg"),
    name: "Travel",
  ),
  Category(
    image: AssetImage("assets/image/Architecture.jpg"),
    name: "Architecture",
  ),
];
