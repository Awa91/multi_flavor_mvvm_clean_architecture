class InvoiceItem {
  final String description;
  final double quantity;
  final double unitPrice;

  InvoiceItem(
      {required this.description,
      required this.quantity,
      required this.unitPrice});

  double get total => quantity * unitPrice;
}
