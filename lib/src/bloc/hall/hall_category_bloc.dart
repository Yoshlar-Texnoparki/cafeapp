import 'dart:convert';

import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/hall/hall_category_model.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/place/place_model.dart';
import 'package:rxdart/rxdart.dart';

class HallAndPlaceModel{
  List<HallCategoryModel> hallCategoryModel;
  List<PlaceModel> placeModel;
  HallAndPlaceModel({required this.hallCategoryModel,required this.placeModel});
}
class HallCategoryAndPlaceBloc{
  final Repository _repository = Repository();
  final _fetchHallCategoryBloc = BehaviorSubject<HallAndPlaceModel>();
  Stream<HallAndPlaceModel> get getHallCategoryStream => _fetchHallCategoryBloc.stream;

  getHallCategoryAndPlace()async{
    HttpResult resultCategory = await _repository.hallCategory();
    HttpResult resultPlace = await _repository.places();
    if(resultCategory.isSuccess){
      var dataCategory = hallCategoryModelFromJson(json.encode(resultCategory.result));
      var dataPlace = placeModelFromJson(json.encode(resultPlace.result));
      // for(int i =0; i<dataCategory.length;i++){
      //   for(int j =0; j<dataPlace.length;j++){
      //     if(dataCategory[i].id == dataPlace[j].hallId){
      //       dataPlace = placeModelFromJson(json.encode(resultPlace.result));
      //     }
      //   }
      // }
      HallAndPlaceModel hallAndPlaceModel = HallAndPlaceModel(hallCategoryModel: dataCategory, placeModel: dataPlace);
      _fetchHallCategoryBloc.sink.add(hallAndPlaceModel);
    }
  }
}
final hallCategoryAndPlaceBloc = HallCategoryAndPlaceBloc();