

import 'package:default_proyect/ui/components/crop_component.dart';
import 'package:flutter/material.dart';

class DefaultProvider extends ChangeNotifier {

  List<CropComponent> childrens = [];

  addChildren(CropComponent widget){
    childrens.add(widget);
    notifyListeners();
  }

}