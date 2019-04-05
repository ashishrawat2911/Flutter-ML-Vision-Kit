// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ml_vision_example/detail_page.dart';
import 'package:firebase_ml_vision_example/homepage.dart';
import 'package:firebase_ml_vision_example/Constant.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: HomePage(),
    routes: <String, WidgetBuilder>{
      DETAIL_PAGE: (BuildContext context) => DetailPage()
    },
  ));
}
