import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dio_util.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 var _queryInfo= {
  "search_key": "",
  'search_date': "",
  'search_content': "",
  'pagenum': 1,
  'pagesize': 5,
  };
 var total=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("维修设备页"),
      ),
      backgroundColor: Colors.white,
      body: ElevatedButton(
        onPressed: () async {

          var result =
              await DioUtil().dio_requset("equipments", method: "post", params:_queryInfo  //buzhidao
          );
          var person = json.decode(result.toString());
          print(person);
        },
        child: Text("Click"),
      ),
    );
  }
}
