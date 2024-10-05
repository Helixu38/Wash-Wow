extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

String formatCurrency(double amount) {
  // Format the number and replace commas with periods
  String formatted = amount.toStringAsFixed(0).replaceAll(',', '.');
  
  // Add the grouping separators (periods)
  formatted = formatted.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
  
  return formatted;
}
