// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'TransactionRecord.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionRecord _$TransactionRecordFromJson(Map<String, dynamic> json) {
  return _TransactionRecord.fromJson(json);
}

/// @nodoc
mixin _$TransactionRecord {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(
      toJson: TransactionRecord._dateTimeToTimestamp,
      fromJson: TransactionRecord._timestampToDateTime,
      includeIfNull: false)
  DateTime? get timestamp => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(includeIfNull: false)
  String? get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionRecordCopyWith<TransactionRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionRecordCopyWith<$Res> {
  factory $TransactionRecordCopyWith(
          TransactionRecord value, $Res Function(TransactionRecord) then) =
      _$TransactionRecordCopyWithImpl<$Res, TransactionRecord>;
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      double amount,
      String currency,
      @JsonKey(
          toJson: TransactionRecord._dateTimeToTimestamp,
          fromJson: TransactionRecord._timestampToDateTime,
          includeIfNull: false)
      DateTime? timestamp,
      String? note,
      @JsonKey(includeIfNull: false) String? type});
}

/// @nodoc
class _$TransactionRecordCopyWithImpl<$Res, $Val extends TransactionRecord>
    implements $TransactionRecordCopyWith<$Res> {
  _$TransactionRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? amount = null,
    Object? currency = null,
    Object? timestamp = freezed,
    Object? note = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionRecordImplCopyWith<$Res>
    implements $TransactionRecordCopyWith<$Res> {
  factory _$$TransactionRecordImplCopyWith(_$TransactionRecordImpl value,
          $Res Function(_$TransactionRecordImpl) then) =
      __$$TransactionRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      double amount,
      String currency,
      @JsonKey(
          toJson: TransactionRecord._dateTimeToTimestamp,
          fromJson: TransactionRecord._timestampToDateTime,
          includeIfNull: false)
      DateTime? timestamp,
      String? note,
      @JsonKey(includeIfNull: false) String? type});
}

/// @nodoc
class __$$TransactionRecordImplCopyWithImpl<$Res>
    extends _$TransactionRecordCopyWithImpl<$Res, _$TransactionRecordImpl>
    implements _$$TransactionRecordImplCopyWith<$Res> {
  __$$TransactionRecordImplCopyWithImpl(_$TransactionRecordImpl _value,
      $Res Function(_$TransactionRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? amount = null,
    Object? currency = null,
    Object? timestamp = freezed,
    Object? note = freezed,
    Object? type = freezed,
  }) {
    return _then(_$TransactionRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionRecordImpl implements _TransactionRecord {
  const _$TransactionRecordImpl(
      {required this.id,
      required this.fromUserId,
      required this.toUserId,
      required this.amount,
      required this.currency,
      @JsonKey(
          toJson: TransactionRecord._dateTimeToTimestamp,
          fromJson: TransactionRecord._timestampToDateTime,
          includeIfNull: false)
      this.timestamp,
      this.note,
      @JsonKey(includeIfNull: false) this.type});

  factory _$TransactionRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  @JsonKey(
      toJson: TransactionRecord._dateTimeToTimestamp,
      fromJson: TransactionRecord._timestampToDateTime,
      includeIfNull: false)
  final DateTime? timestamp;
  @override
  final String? note;
  @override
  @JsonKey(includeIfNull: false)
  final String? type;

  @override
  String toString() {
    return 'TransactionRecord(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, amount: $amount, currency: $currency, timestamp: $timestamp, note: $note, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fromUserId, toUserId, amount,
      currency, timestamp, note, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionRecordImplCopyWith<_$TransactionRecordImpl> get copyWith =>
      __$$TransactionRecordImplCopyWithImpl<_$TransactionRecordImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionRecordImplToJson(
      this,
    );
  }
}

abstract class _TransactionRecord implements TransactionRecord {
  const factory _TransactionRecord(
          {required final String id,
          required final String fromUserId,
          required final String toUserId,
          required final double amount,
          required final String currency,
          @JsonKey(
              toJson: TransactionRecord._dateTimeToTimestamp,
              fromJson: TransactionRecord._timestampToDateTime,
              includeIfNull: false)
          final DateTime? timestamp,
          final String? note,
          @JsonKey(includeIfNull: false) final String? type}) =
      _$TransactionRecordImpl;

  factory _TransactionRecord.fromJson(Map<String, dynamic> json) =
      _$TransactionRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  @JsonKey(
      toJson: TransactionRecord._dateTimeToTimestamp,
      fromJson: TransactionRecord._timestampToDateTime,
      includeIfNull: false)
  DateTime? get timestamp;
  @override
  String? get note;
  @override
  @JsonKey(includeIfNull: false)
  String? get type;
  @override
  @JsonKey(ignore: true)
  _$$TransactionRecordImplCopyWith<_$TransactionRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
