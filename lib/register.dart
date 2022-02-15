import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dio_util.dart';

class Register extends StatelessWidget {
  var loginForm = {
    'userName': "",
    'userPassword': '',
    'name': '',
    'department': '',
    'mobile': ''
  };
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册"),
      ),
      body: Scrollbar(child: SingleChildScrollView(child: Form(
    key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          Divider(
            height: 8,
            color: Color.fromARGB(0, 0, 0, 0),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "images/logo.png",
              ),
              backgroundColor: Colors.transparent,
              radius: 60.0,
            ),
          ),
          Divider(
            height: 8,
            color: Color.fromARGB(0, 0, 0, 0),
          ),
          Align(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "账号",
                      prefixIcon: new Icon(Icons.person),
                    ),
                    validator: (v) {
                      return v!.trim().length > 0 ? null : "账号不能为空";
                    },
                    onSaved: (value) {
                      loginForm['userName'] = value!;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "密码",
                      prefixIcon: new Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (v) {
                      return v!.trim().length > 5 ? null : "密码不能少于6位";
                    },
                    onSaved: (value) {
                      loginForm['userPassword'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "姓名",
                      prefixIcon: new Icon(Icons.face),
                    ),
                    validator: (v) {
                      return v!.trim().length > 0 ? null : "姓名不能为空";
                    },
                    onSaved: (value) {
                      loginForm['name'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "部门",
                      prefixIcon: new Icon(Icons.list),
                    ),
                    validator: (v) {
                      return v!.trim().length > 0 ? null : "部门不能为空";
                    },
                    onSaved: (value) {
                      loginForm['department'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "电话",
                      prefixIcon: new Icon(Icons.phone),
                    ),
                    validator: (v) {
                      // 正则匹配手机号
                      RegExp exp = RegExp(
                          r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
                      if (v!.isEmpty) {
                        return '电话不能为空!';
                      } else if (!exp.hasMatch(v)) {
                        return '请输入正确手机号!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      loginForm['mobile'] = value!;
                    },
                  ),
                ]),
              )),
          Align(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: MaterialButton(
                color: Colors.blue,
                minWidth: double.infinity,
                textColor: Colors.white,
                onPressed: () async {
                  if ((_formKey.currentState as FormState).validate()) {
                    //验证通过提交数据


                    _formKey.currentState?.save();

                    print(loginForm);
                    var result =
                        await DioUtil().dio_requset("register", method: "post", params: loginForm//buzhidao
                    );
                    var person = json.decode(result.toString());
                    print(person);

                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text(
                        person['meta']['msg'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      // duration: const Duration(seconds: 2),
                    ));
                    if(person['meta']['status']==200){
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: Text(
                  '注册',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    ))
          )
    );
}}
