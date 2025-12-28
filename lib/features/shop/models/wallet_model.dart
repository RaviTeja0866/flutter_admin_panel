import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WalletTransactionModel {
  final String id;               // Firestore document ID
  final String title;            // Refund, Cashback, Promo
  final String subtitle;         // Credited to wallet, etc.
  final DateTime date;           // Timestamp of transaction
  final double amount;           // +200 or -50
  final bool isCredit;           // true = credit, false = debit
  final String source;           // refund / promo / adjustment
  final String? orderId;         // linked order (optional)
  final String? note;            // extra details (optional)
  final DateTime? expiryDate;    // optional expiry for promo credits

  WalletTransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.source,
    this.orderId,
    this.note,
    this.expiryDate,
  });

  // Empty model
  static WalletTransactionModel empty() => WalletTransactionModel(
    id: "",
    title: "",
    subtitle: "",
    date: DateTime.now(),
    amount: 0.0,
    isCredit: true,
    source: "",
    orderId: null,
    note: null,
    expiryDate: null,
  );

  // Convert Firestore → Model (from DocumentSnapshot)
  factory WalletTransactionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) return WalletTransactionModel.empty();

    return WalletTransactionModel(
      id: document.id,
      title: data['title'] ?? "",
      subtitle: data['subtitle'] ?? "",
      date: (data['date'] as Timestamp).toDate(),
      amount: (data['amount'] as num).toDouble(),
      isCredit: data['isCredit'] ?? true,
      source: data['source'] ?? "",
      orderId: data['orderId'],
      note: data['note'],
      expiryDate: data['expiryDate'] != null
          ? (data['expiryDate'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Firestore → Model (from Map) - NEEDED FOR REPOSITORY
  factory WalletTransactionModel.fromMap(Map<String, dynamic> map) {
    return WalletTransactionModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      subtitle: map['subtitle'] ?? "",
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      isCredit: map['isCredit'] ?? true,
      source: map['source'] ?? "",
      orderId: map['orderId'],
      note: map['note'],
      expiryDate: map['expiryDate'] != null
          ? (map['expiryDate'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Model → Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'isCredit': isCredit,
      'source': source,
      'orderId': orderId,
      'note': note,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
    };
  }

  // Get color based on transaction type
  Color getColor() {
    return isCredit ? Colors.teal : Colors.red;
  }

  // Get amount with sign
  String getAmountWithSign() {
    final sign = isCredit ? '+' : '-';
    return '$sign${amount.toStringAsFixed(0)}';
  }

  // Check if expired
  bool isExpired() {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  // Check if expiring soon (within 30 days)
  bool isExpiringSoon() {
    if (expiryDate == null) return false;
    final now = DateTime.now();
    final thirtyDaysLater = now.add(const Duration(days: 30));
    return expiryDate!.isAfter(now) && expiryDate!.isBefore(thirtyDaysLater);
  }
}