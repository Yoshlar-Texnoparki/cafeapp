import 'dart:convert';
import 'package:cafeapp/src/api/repository.dart';
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/order/order_detail.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc {
  final Repository _repository = Repository();
  final _fetchOrderDetailSubject = PublishSubject<OrderDetailModel>();
  final _fetchOrderHistorySubject = PublishSubject<List<OrderDetailModel>>();

  Stream<OrderDetailModel> get getOrderDetailStream =>
      _fetchOrderDetailSubject.stream;

  Stream<List<OrderDetailModel>> get getOrderHistoryStream =>
      _fetchOrderHistorySubject.stream;

  getAllOrderDetail(id) async {
    HttpResult result = await _repository.getAOrderId(id);
    if (result.isSuccess) {
      try {
        var data = OrderDetailModel.fromJson(result.result);
        _fetchOrderDetailSubject.sink.add(data);
      } catch (e) {
        // _fetchOrderDetailSubject.close();
        // _fetchOrderDetailSubject.sink.add(OrderDetailModel.fromJson({}));
        print(e);
      }
    }
  }

  getAllOrders() async {
    HttpResult result = await _repository.getAOrderId(0);
    if (result.isSuccess) {
      try {
        List<OrderDetailModel> orders = [];
        if (result.result is List) {
          orders = (result.result as List)
              .map((item) => OrderDetailModel.fromJson(item))
              .toList();
        }
        _fetchOrderHistorySubject.sink.add(orders);
      } catch (e) {
        print('Error parsing order history: $e');
        _fetchOrderHistorySubject.sink.add([]);
      }
    } else {
      _fetchOrderHistorySubject.sink.add([]);
    }
  }

  Future<HttpResult> postOrder(Map<String, dynamic> data) async {
    return await _repository.addOrder(data);
  }

  Future<HttpResult> updateOrder(Map<String, dynamic> data, int id) async {
    return await _repository.updateOrder(json.encode(data), id);
  }
}

OrderDetailBloc orderDetailBloc = OrderDetailBloc();
