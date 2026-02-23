import 'package:flutter/material.dart';

import '../../data/repositories/invoice_repository.dart';
import '../../domain/invoice_entity.dart';

class InvoiceViewModel extends ChangeNotifier {
  final InvoiceRepository _repository;
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  InvoiceViewModel(this._repository);

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();
    _invoices = await _repository.fetchInvoices();
    _isLoading = false;
    notifyListeners();
  }
}
