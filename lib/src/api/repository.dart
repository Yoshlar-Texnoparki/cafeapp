import 'package:cafeapp/src/api/api_provider.dart';
import 'package:cafeapp/src/model/http_result.dart';

class Repository{
  final ApiProvider _apiProvider = ApiProvider();
  Future<HttpResult> login(data)async => await _apiProvider.login(data);
  Future<HttpResult> account()async => await _apiProvider.account();
  Future<HttpResult> hallCategory()async => await _apiProvider.hallCategory();
  Future<HttpResult> allCategories()async => await _apiProvider.allCategories();
  Future<HttpResult> allFoods()async => await _apiProvider.allFoods();
  Future<HttpResult> categoriesId(int id)async => await _apiProvider.categoriesId(id);
  Future<HttpResult> foodDetail(int id)async => await _apiProvider.foodDetail(id);
  Future<HttpResult> addOrder(data)async => await _apiProvider.addOrder(data);
  Future<HttpResult> getAOrderId(int id)async => await _apiProvider.getAOrderId(id);
  Future<HttpResult> places()async => await _apiProvider.places();
}