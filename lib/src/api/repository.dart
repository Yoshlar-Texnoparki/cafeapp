import 'package:cafeapp/src/api/api_provider.dart';
import 'package:cafeapp/src/model/http_result.dart';

class Repository{
  final ApiProvider _apiProvider = ApiProvider();
  Future<HttpResult> login(Map data)async => await _apiProvider.login(data);
}