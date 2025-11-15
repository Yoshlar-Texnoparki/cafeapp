
import 'package:cafeapp/src/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: filled ? 18 : 14,
            height: filled ? 18 : 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? Theme.of(context).primaryColor : Colors.transparent,
              border: Border.all(
                color: filled ? Theme.of(context).primaryColor : Colors.grey.shade400,
                width: 1.5,
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
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: child ?? Text(label, style: const TextStyle(fontSize: 24)),
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
            const SizedBox(height: 24),
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: -8,
                            blurRadius: 10,
                            color: Colors.grey
                        )
                      ],
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                const SizedBox(height: 18),
                Text('Parol kiriting', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                _buildPinDots(),
                const SizedBox(height: 8),
                if (_pin.isNotEmpty)
                  Text('$_pin', style: const TextStyle(fontSize: 12, color: Colors.transparent)),
              ],
            ),

            // Numpad
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  _buildNumberRow(['1', '2', '3']),
                  const SizedBox(height: 12),
                  _buildNumberRow(['4', '5', '6']),
                  const SizedBox(height: 12),
                  _buildNumberRow(['7', '8', '9']),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // optional clear placeholder
                      GestureDetector(
                        onLongPress: _clearAll,
                        child: Container(
                          height: 72,
                          width: 72,
                          alignment: Alignment.center,
                          child: const Text(''),
                        ),
                      ),
                      _numButton('0', onPressed: () => _addDigit('0')),
                      GestureDetector(
                        onTap: _deleteDigit,
                        onLongPress: _clearAll,
                        child: Container(
                          height: 72,
                          width: 72,
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