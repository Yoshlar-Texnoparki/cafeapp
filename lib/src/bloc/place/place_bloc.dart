import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/place/place_model.dart';
import 'package:rxdart/rxdart.dart';

class PlaceBloc{
  final Repository _repository = Repository();
  final _fetchPlaceSubject = BehaviorSubject<List<PlaceModel>>();
  Stream<List<PlaceModel>> get getPlaceStream => _fetchPlaceSubject.stream;

  getPlaceAll()async{
    HttpResult result = await _repository.places();
    if(result.isSuccess){
      var data = placeModelFromJson(result.result);
      _fetchPlaceSubject.sink.add(data);
    }
  }
}
final placeBloc = PlaceBloc();