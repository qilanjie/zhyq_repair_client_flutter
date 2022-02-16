import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioUtil{
  // 单例模式
  static final DioUtil _instance = DioUtil._internal();
  factory DioUtil() => _instance;
  DioUtil._internal(){
    init();
  }

 late  Dio _dio;

  // 初始化请求配置
  init()  async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    BaseOptions baseOptions = BaseOptions(
      baseUrl: "http://127.0.0.1:8888/api/private/v1/",
      headers:{"authorization":prefs.getString('token')},
      connectTimeout: 5000,
    );
    _dio = Dio(baseOptions);
  }

  // 请求(默认post)
  Future dio_requset(String url,{String method = "post", Map<String,dynamic>? params}) async{
    Options options = Options(method: method);
    try{
      final result = await _dio.request(url,queryParameters: params,options: options);
      return result;
    } on DioError catch(error){
      throw error;
    }
  }
}