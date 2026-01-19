import 'package:cafeapp/src/bloc/food/categories_bloc.dart';
import 'package:cafeapp/src/bloc/food/food_bloc.dart';
import 'package:cafeapp/src/bloc/order/order_bloc.dart'; // Make sure this exports OrderDetailBloc or similar
import 'package:cafeapp/src/model/http_result.dart';
import 'package:cafeapp/src/model/food/categories_model.dart';
import 'package:cafeapp/src/model/food/food_model.dart';
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:cafeapp/src/theme/app_style.dart';
import 'package:cafeapp/src/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class FoodsScreen extends StatefulWidget {
  final int placeId;
  final String placeName;
  final int orderId;
  const FoodsScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    this.orderId = 0,
  });

  @override
  State<FoodsScreen> createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  final Map<int, double> _selectedQuantities = {};
  final Map<int, String> _itemWeightTypes =
      {}; // To track chosen weight type per item
  bool _isOrdering = false;

  void _updateQuantity(int id, double delta, {String? type}) {
    setState(() {
      double current = _selectedQuantities[id] ?? 0;
      double next = current + delta;
      if (next <= 0) {
        _selectedQuantities.remove(id);
        _itemWeightTypes.remove(id);
      } else {
        _selectedQuantities[id] = double.parse(next.toStringAsFixed(1));
        if (type != null) _itemWeightTypes[id] = type;
      }
    });
  }

  void _showOrderSummary(List<FoodsModel> allFoods) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final selectedItems = _selectedQuantities.entries.map((e) {
          final food = allFoods.firstWhere((f) => f.id == e.key);
          final type = _itemWeightTypes[e.key] ?? food.weightType;
          return {
            'name': food.name,
            'qty': e.value,
            'type': type,
            'total': (e.value * food.price).toInt(),
          };
        }).toList();

        int grandTotal = selectedItems.fold(
          0,
          (sum, item) => sum + (item['total'] as int),
        );

        return Container(
          height: 0.7.sh,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
              Text(
                "Tanlangan taomlar",
                style: AppStyle.font800(
                  AppColors.white,
                ).copyWith(fontSize: 20.sp),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: selectedItems.isEmpty
                    ? Center(
                        child: Text(
                          "Hali hech narsa tanlanmagan",
                          style: AppStyle.font800(AppColors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedItems.length,
                        itemBuilder: (context, index) {
                          final item = selectedItems[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              item['name'] as String,
                              style: AppStyle.font800(AppColors.white),
                            ),
                            subtitle: Text(
                              "${item['type'] == 'kg' ? item['qty'] : (item['qty'] as double).toInt()} ${item['type'] == 'kg' ? 'kg' : 'ta'}",
                              style: AppStyle.font400(AppColors.grey),
                            ),
                            trailing: Text(
                              "${item['total']} so'm",
                              style: AppStyle.font800(AppColors.buttonColor),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(color: Colors.grey),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Jami:",
                      style: AppStyle.font800(
                        AppColors.white,
                      ).copyWith(fontSize: 18.sp),
                    ),
                    Text(
                      "$grandTotal so'm",
                      style: AppStyle.font800(
                        AppColors.buttonColor,
                      ).copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Yopish", style: AppStyle.font800(AppColors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFoodDetail(Food food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              String selectedType =
                  _itemWeightTypes[food.id] ??
                  (food.weightType == 'kg' ? 'kg' : 'pors');
              double currentQty = _selectedQuantities[food.id] ?? 1.0;

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      food.name,
                      style: AppStyle.font800(
                        AppColors.white,
                      ).copyWith(fontSize: 20.sp),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _typeChoice(
                          label: "Porsiya",
                          isSelected: selectedType == 'pors',
                          onTap: () {
                            setModalState(() {
                              selectedType = 'pors';
                              currentQty = currentQty.toInt().toDouble();
                              if (currentQty < 1) currentQty = 1;
                              _updateQuantity(food.id, 0, type: 'pors');
                              _selectedQuantities[food.id] = currentQty;
                            });
                          },
                        ),
                        SizedBox(width: 12.w),
                        _typeChoice(
                          label: "Kilogramm",
                          isSelected: selectedType == 'kg',
                          onTap: () {
                            setModalState(() {
                              selectedType = 'kg';
                              _updateQuantity(food.id, 0, type: 'kg');
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    if (selectedType == 'kg')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (currentQty > 0.1) {
                                setModalState(() {
                                  currentQty = double.parse(
                                    (currentQty - 0.1).toStringAsFixed(1),
                                  );
                                });
                                _updateQuantity(food.id, -0.1, type: 'kg');
                              } else {
                                setModalState(() {
                                  currentQty = 0;
                                });
                                _updateQuantity(
                                  food.id,
                                  -currentQty,
                                  type: 'kg',
                                );
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.buttonColor,
                              size: 30.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              currentQty.toStringAsFixed(1),
                              style: AppStyle.font800(
                                AppColors.white,
                              ).copyWith(fontSize: 24.sp),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                currentQty = double.parse(
                                  (currentQty + 0.1).toStringAsFixed(1),
                                );
                              });
                              _updateQuantity(food.id, 0.1, type: 'kg');
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: AppColors.buttonColor,
                              size: 30.sp,
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (currentQty > 1) {
                                setModalState(() {
                                  currentQty -= 1;
                                });
                                _updateQuantity(food.id, -1, type: 'pors');
                              }
                            },
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: AppColors.buttonColor,
                              size: 30.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              currentQty.toInt().toString(),
                              style: AppStyle.font800(
                                AppColors.white,
                              ).copyWith(fontSize: 24.sp),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() {
                                currentQty += 1;
                              });
                              _updateQuantity(food.id, 1, type: 'pors');
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: AppColors.buttonColor,
                              size: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 16.h),
                    Text(
                      "Jami: ${(currentQty * food.price).toInt()} so'm",
                      style: AppStyle.font800(
                        AppColors.buttonColor,
                      ).copyWith(fontSize: 18.sp),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "OK",
                        style: AppStyle.font800(AppColors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _typeChoice({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonColor : AppColors.inputColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.grey,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.font800(
            isSelected ? AppColors.black : AppColors.grey,
          ).copyWith(fontSize: 14.sp),
        ),
      ),
    );
  }

  @override
  void initState() {
    categoriesBloc.getAllCategories();
    foodBloc.getAllFood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: Rx.combineLatest2(
        categoriesBloc.getCategoriesStream,
        foodBloc.getFoodsStream,
        (List<CategoriesModel> categories, List<FoodsModel> foods) => {
          'categories': categories,
          'foods': foods,
        },
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.buttonColor),
            ),
          );
        }
        final categories =
            snapshot.data!['categories'] as List<CategoriesModel>;
        final allFoods = snapshot.data!['foods'] as List<FoodsModel>;

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              foregroundColor: AppColors.white,
              title: Text(widget.placeName),
              actions: [
                if (_selectedQuantities.isNotEmpty)
                  Badge(
                    label: Text(_selectedQuantities.length.toString()),
                    backgroundColor: AppColors.buttonColor,
                    textColor: AppColors.black,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => _showOrderSummary(allFoods),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => _showOrderSummary(allFoods),
                  ),
                SizedBox(width: 8.w),
              ],
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.inputColor,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w, right: 8.w),
                  child: TabBar.secondary(
                    padding: const EdgeInsets.only(bottom: 10),
                    labelColor: AppColors.black,
                    indicatorPadding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.start,
                    overlayColor: WidgetStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                    labelPadding: EdgeInsets.symmetric(
                      vertical: 12.w,
                      horizontal: 12.w,
                    ),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: AppColors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.buttonColor,
                    ),
                    isScrollable: true,
                    tabs: categories
                        .map((category) => Text(category.name))
                        .toList(),
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                TabBarView(
                  children: categories.map((category) {
                    final categoryFoods = allFoods
                        .where((food) => food.categoryId == category.id)
                        .toList();

                    if (categoryFoods.isEmpty) {
                      return Center(
                        child: Text(
                          "Hozircha taomlar yo'q",
                          style: AppStyle.font800(AppColors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: categoryFoods.length,
                      itemBuilder: (context, index) {
                        final food = categoryFoods[index];
                        final quantity = _selectedQuantities[food.id] ?? 0;
                        return InkWell(
                          onTap: () {
                            final foodItem = Food(
                              id: food.id,
                              name: food.name,
                              price: food.price,
                              categoryId: food.categoryId,
                              description: food.description,
                              defaultFood: food.defaultFood,
                              priceKg: food.priceKg,
                              image: food.image,
                              status: food.status,
                              weightType: food.weightType,
                            );
                            _showFoodDetail(foodItem);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            width: 1.sw,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.inputColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70.r,
                                  height: 70.r,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.inputColor,
                                  ),
                                  child: food.image != "" && food.image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            food.image.toString(),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.fastfood_sharp,
                                                      size: 34,
                                                      color: AppColors.grey,
                                                    ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.fastfood_sharp,
                                          size: 34,
                                          color: AppColors.grey,
                                        ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: AppStyle.font800(
                                          AppColors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        "${food.price} so'm",
                                        style: AppStyle.font800(
                                          AppColors.buttonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (quantity > 0)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _updateQuantity(
                                          food.id,
                                          (_itemWeightTypes[food.id] ??
                                                      food.weightType) ==
                                                  'kg'
                                              ? -0.1
                                              : -1,
                                        ),
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: AppColors.grey,
                                          size: 24.sp,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        child: Text(
                                          (_itemWeightTypes[food.id] ??
                                                      food.weightType) ==
                                                  'kg'
                                              ? quantity.toStringAsFixed(1)
                                              : quantity.toInt().toString(),
                                          style: AppStyle.font800(
                                            AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                IconButton(
                                  onPressed: () => _updateQuantity(
                                    food.id,
                                    (_itemWeightTypes[food.id] ??
                                                food.weightType) ==
                                            'kg'
                                        ? 0.1
                                        : 1,
                                  ),
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: AppColors.buttonColor,
                                    size: 28.sp,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                if (_selectedQuantities.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ButtonWidget(
                      text: "Buyurtma berish",
                      textColor: AppColors.black,
                      backgroundColor: AppColors.buttonColor,
                      isLoad: _isOrdering,
                      onTap: () async {
                        setState(() => _isOrdering = true);
                        final items = _selectedQuantities.entries.map((e) {
                          final foodId = e.key;
                          final quantity = e.value;
                          final weightType =
                              _itemWeightTypes[foodId] ??
                              allFoods
                                  .firstWhere((f) => f.id == foodId)
                                  .weightType;
                          final price = allFoods
                              .firstWhere((f) => f.id == foodId)
                              .price;

                          return {
                            "food_id": foodId,
                            "weight_type": weightType,
                            "quantity": quantity,
                            "price": price,
                          };
                        }).toList();

                        final orderData = {
                          "place_id": widget.placeId,
                          "order_type": "waiter",
                          "items": items,
                        };

                        final HttpResult result;
                        if (widget.orderId > 0) {
                          result = await orderDetailBloc.updateOrder(
                            orderData,
                            widget.orderId,
                          );
                        } else {
                          result = await orderDetailBloc.postOrder(orderData);
                        }

                        setState(() => _isOrdering = false);

                        if (result.isSuccess) {
                          setState(() {
                            _selectedQuantities.clear();
                            _itemWeightTypes.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Buyurtma muvaffaqiyatli yuborildi!",
                              ),
                            ),
                          );
                          Navigator.pop(context);
                          orderDetailBloc.getAllOrderDetail(
                            widget.orderId > 0
                                ? widget.orderId
                                : result.result['id'],
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Xatolik: ${result.result ?? 'Yuborib bo\'lmadi'}",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
