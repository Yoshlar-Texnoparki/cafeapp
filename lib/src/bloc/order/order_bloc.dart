import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/order/order_detail.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc{
  final Repository _repository = Repository();
  final _fetchOrderDetailSubject = BehaviorSubject<OrderDetailModel>();
  Stream<OrderDetailModel> get getOrderDetailStream => _fetchOrderDetailSubject.stream;


  getAllOrderDetail(id)async{
    HttpResult result = await _repository.getAOrderId(id);
    if(result.isSuccess){
      try{
        var data = OrderDetailModel.fromJson(result.result);
        _fetchOrderDetailSubject.sink.add(data);
      }catch(e){
        // _fetchOrderDetailSubject.close();
        // _fetchOrderDetailSubject.sink.add(OrderDetailModel.fromJson({}));
        print(e);
      }
    }
  }
}

OrderDetailBloc orderDetailBloc = OrderDetailBloc();