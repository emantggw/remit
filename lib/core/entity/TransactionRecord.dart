// Freezed transaction record entity for wallet
// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'TransactionRecord.freezed.dart';
part 'TransactionRecord.g.dart';

@freezed
class TransactionRecord with _$TransactionRecord {
  const factory TransactionRecord({
    required String id,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    @JsonKey(
      toJson: TransactionRecord._dateTimeToTimestamp,
      fromJson: TransactionRecord._timestampToDateTime,
      includeIfNull: false,
    )
    DateTime? timestamp,
    String? note,
    @JsonKey(includeIfNull: false) String? type,
  }) = _TransactionRecord;

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordFromJson(json);

  // Convert DateTime to Firestore-friendly value. When null, use server timestamp placeholder.
  static dynamic _dateTimeToTimestamp(DateTime? dt) {
    if (dt == null) return FieldValue.serverTimestamp();
    return Timestamp.fromDate(dt);
  }

  // Parse Firestore Timestamp (or int) to DateTime
  static DateTime _timestampToDateTime(dynamic ts) {
    if (ts is Timestamp) return ts.toDate();
    if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
    return DateTime.now();
  }
}
