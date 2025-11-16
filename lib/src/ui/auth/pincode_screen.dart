
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinCodeScreen extends StatefulWidget {
  final int length;
  final void Function(String pin)? onCompleted;
  final String title;

  const PinCodeScreen({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.title = 'Kafe App',
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String _pin = '';

  void _addDigit(String d) {
    if (_pin.length >= widget.length) return;
    setState(() => _pin += d);
    if (_pin.length == widget.length) {
      Future.delayed(const Duration(milliseconds: 150), () {
        widget.onCompleted?.call(_pin);
      });
    }
  }

  void _deleteDigit() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  void _clearAll() {
    setState(() => _pin = '');
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        final filled = i < _pin.length;
        return Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: filled ? 18.sp : 14.sp,
            height: filled ? 18.sp : 14.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? Theme.of(context).primaryColor : Colors.transparent,
              border: Border.all(
                color: filled ? Theme.of(context).primaryColor : Colors.grey.shade400,
                width: 1.5.sp,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _numButton(String label, {VoidCallback? onPressed, Widget? child}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 72.sp,
        width: 72.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: child ?? Text(label, style:  TextStyle(fontSize: 24.sp)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 24.sp),
            Column(
              children: [
                Container(
                  width: 120.sp,
                  height: 120.sp,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: -8,
                            blurRadius: 10,
                            color: Colors.grey
                        )
                      ],
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10.r)
                  ),
                ),
                SizedBox(height: 18.sp),
                Text('Parol kiriting', style: Theme.of(context).textTheme.bodyLarge),
                SizedBox(height: 16.sp),
                _buildPinDots(),
                SizedBox(height: 8.sp),
                if (_pin.isNotEmpty)
                  Text('$_pin', style:  TextStyle(fontSize: 12.sp, color: Colors.transparent)),
              ],
            ),

            // Numpad
            Padding(
              padding:  EdgeInsets.only(bottom: 24.0.sp),
              child: Column(
                children: [
                  _buildNumberRow(['1', '2', '3']),
                  SizedBox(height: 12.sp),
                  _buildNumberRow(['4', '5', '6']),
                  SizedBox(height: 12.sp),
                  _buildNumberRow(['7', '8', '9']),
                  SizedBox(height: 12.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // optional clear placeholder
                      GestureDetector(
                        onLongPress: _clearAll,
                        child: Container(
                          height: 72.sp,
                          width: 72.sp,
                          alignment: Alignment.center,
                          child: const Text(''),
                        ),
                      ),
                      _numButton('0', onPressed: () => _addDigit('0')),
                      GestureDetector(
                        onTap: _deleteDigit,
                        onLongPress: _clearAll,
                        child: Container(
                          height: 72.sp,
                          width: 72.sp,
                          alignment: Alignment.center,
                          child: const Icon(Icons.backspace_outlined),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) {
        return _numButton(d, onPressed: () => _addDigit(d));
      }).toList(),
    );
  }
}