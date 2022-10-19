import 'package:flutter/widgets.dart';

class Asset {
 
  const Asset({
    required this.name,
    required this.path,
    required this.size,
  });

  
  final String name;

 
  final String path;


  final Size size;
}