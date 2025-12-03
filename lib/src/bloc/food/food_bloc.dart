import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/food/food_model.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:rxdart/rxdart.dart';

class FoodBloc{
  final Repository _repository = Repository();
  final _fetchFoodsSubject = BehaviorSubject<List<FoodsModel>>();
  Stream<List<FoodsModel>> get getFoodsStream => _fetchFoodsSubject.stream;
  getAllFood()async{
    HttpResult result = await _repository.allFoods();
    if(result.isSuccess){
      var data = foodsModelFromJson(json.encode(result.result));
      _fetchFoodsSubject.sink.add(data);
    }
  }
}
FoodBloc foodBloc = FoodBloc();