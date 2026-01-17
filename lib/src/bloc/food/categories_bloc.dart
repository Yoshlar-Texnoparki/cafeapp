import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/food/categories_model.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:rxdart/rxdart.dart';

class CategoriesBloc {
  final Repository _repository = Repository();
  final _fetchCategoriesSubject = BehaviorSubject<List<CategoriesModel>>();
  Stream<List<CategoriesModel>> get getCategoriesStream => _fetchCategoriesSubject.stream;

  getAllCategories()async{
    HttpResult result = await _repository.allCategories();
    if(result.isSuccess){
      var data = categoriesModelFromJson(json.encode(result.result));
      _fetchCategoriesSubject.sink.add(data);
    }
  }
}
CategoriesBloc categoriesBloc = CategoriesBloc();