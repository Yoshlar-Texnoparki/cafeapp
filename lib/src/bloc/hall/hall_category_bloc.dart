import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/hall/hall_category_model.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:rxdart/rxdart.dart';

class HallCategoryBloc{
  final Repository _repository = Repository();
  final _fetchHallCategoryBloc = BehaviorSubject<List<HallCategoryModel>>();
  Stream<List<HallCategoryModel>> get getHallCategoryStream => _fetchHallCategoryBloc.stream;

  getHallCategory()async{
    HttpResult result = await _repository.hallCategory();
    if(result.isSuccess){
      var data = hallCategoryModelFromJson(json.encode(result.result));
      _fetchHallCategoryBloc.sink.add(data);
    }
  }
}
final hallCategoryBloc = HallCategoryBloc();