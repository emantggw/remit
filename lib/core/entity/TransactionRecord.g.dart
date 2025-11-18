// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TransactionRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionRecordImpl _$$TransactionRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionRecordImpl(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      timestamp: TransactionRecord._timestampToDateTime(json['timestamp']),
      note: json['note'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$TransactionRecordImplToJson(
    _$TransactionRecordImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'fromUserId': instance.fromUserId,
    'toUserId': instance.toUserId,
    'amount': instance.amount,
    'currency': instance.currency,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'timestamp', TransactionRecord._dateTimeToTimestamp(instance.timestamp));
  val['note'] = instance.note;
  writeNotNull('type', instance.type);
  return val;
}
