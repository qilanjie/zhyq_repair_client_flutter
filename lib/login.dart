import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dio_util.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = '19811031'; //密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮
  var _checkValue = true;

  @override
  void initState() {
    // TODO: implement initState
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }


        // setState(() async {
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //
        //   _userNameController.text=prefs.getString('_username')??'';
        //
        //
        //   _passwordController.text=prefs.getString('_password')??'';
        // });



    });
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      print("单次Frame绘制回调"); //只回调一次
      SharedPreferences prefs = await SharedPreferences.getInstance();

        _userNameController.text=prefs.getString('_username')??'';


        _passwordController.text=prefs.getString('_password')??'';
    });
    //_userNameController.text = "test";
    DioUtil();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  /**
   * 验证用户名
   */
  String? validateUserName(value) {
    // 正则匹配手机号
    // RegExp exp = RegExp(
    //     r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '用户名不能为空!';
    }
    // else if (!exp.hasMatch(value)) {
    //   return '请输入正确手机号';
    // }
    return null;
  }

  /**
   * 验证密码
   */
  String? validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6 || value.trim().length > 18) {
      return '密码长度不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // print(ScreenUtil().scaleHeight);

    // logo 图片区域
    Widget logoImageArea = new Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "images/logo.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );

    //输入文本框区域

    Widget inputTextArea = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              // keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入用户名",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String? value) {
                _username = value!;
              },
            ),
            new TextFormField(
              controller: _passwordController,

              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String? value) {
                _password = value!;
              },
            )
          ],
        ),
      ),
    );

    // 登录按钮区域
    Widget loginButtonArea = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: ElevatedButton(
//  color: Colors.blue[300],
        child: Text(
          "登录",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        // 设置按钮圆角
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () async {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if (_formKey.currentState!.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState!.save();
            print("$_username + $_password");

            SharedPreferences prefs = await SharedPreferences.getInstance();
            if(_checkValue){
              prefs.setString('_username', _username);
              prefs.setString('_password', _password);
            }else
              {
                prefs.setString('_username', '');
                prefs.setString('_password', '');
              }

            //todo 登录操作
            var result =
                await DioUtil().dio_requset("login", method: "post", params: {
              "userName": _username, //admin
              "userPassword": _password
            } //buzhidao
                    );
            // if(result[meta]!=200){
            //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     duration: Duration(seconds: 2),
            //     content: Text('老孟，专注分享Flutter相关技术$result.'),
            //   ));
            // }
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('token',person['data']['token'] );
              DioUtil().init();
              Navigator.of(context).pushNamed('/home');
            }
          }
        },
      ),
    );

    //忘记密码  立即注册
    Widget bottomArea = new Container(
      margin: EdgeInsets.only(right: 20, left: 30),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 160,
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('记住密码'),
              value: _checkValue,
              onChanged: (value) {
                setState(() {
                  _checkValue = value!;
                });
              },
            ),
          ),
          TextButton(
            child: Text(
              "快速注册",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //点击快速注册、执行事件
            onPressed: () {
              Navigator.of(context).pushNamed("/register");
            },
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("用户登陆"),
      ),
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(
              height: 40,
            ),
            logoImageArea,
            new SizedBox(
              height: 70,
            ),
            inputTextArea,
            new SizedBox(
              height: 80,
            ),
            loginButtonArea,
            new SizedBox(
              height: 60,
            ),
            bottomArea,
          ],
        ),
      ),
    );
  }
}
