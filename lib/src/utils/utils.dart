class Utils{


static  String formatNumber(num number) {
    if (number == number.toInt()) {
      return number.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]} ');
    } else {
      return number.toStringAsFixed(1).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'), (Match match) => '${match[1]} ');
    }
  }
}