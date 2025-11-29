import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/account/account_model.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:rxdart/rxdart.dart';

class AccountBloc{
  final Repository _repository = Repository();
  final _fetchAccountSubject = BehaviorSubject<AccountModel>();
  Stream<AccountModel> get getAccountStream => _fetchAccountSubject.stream;

  getAccount()async{
    HttpResult result  = await _repository.account();
    if(result.isSuccess){
      var data = AccountModel.fromJson(result.result);
      _fetchAccountSubject.sink.add(data);
    }
  }
}
final accountBloc = AccountBloc();