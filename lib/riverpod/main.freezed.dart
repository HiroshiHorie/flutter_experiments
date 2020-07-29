// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'main.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$SampleStateTearOff {
  const _$SampleStateTearOff();

  _SampleState call({int counter1 = 0, int counter2 = 0}) {
    return _SampleState(
      counter1: counter1,
      counter2: counter2,
    );
  }
}

// ignore: unused_element
const $SampleState = _$SampleStateTearOff();

mixin _$SampleState {
  int get counter1;
  int get counter2;

  $SampleStateCopyWith<SampleState> get copyWith;
}

abstract class $SampleStateCopyWith<$Res> {
  factory $SampleStateCopyWith(
          SampleState value, $Res Function(SampleState) then) =
      _$SampleStateCopyWithImpl<$Res>;
  $Res call({int counter1, int counter2});
}

class _$SampleStateCopyWithImpl<$Res> implements $SampleStateCopyWith<$Res> {
  _$SampleStateCopyWithImpl(this._value, this._then);

  final SampleState _value;
  // ignore: unused_field
  final $Res Function(SampleState) _then;

  @override
  $Res call({
    Object counter1 = freezed,
    Object counter2 = freezed,
  }) {
    return _then(_value.copyWith(
      counter1: counter1 == freezed ? _value.counter1 : counter1 as int,
      counter2: counter2 == freezed ? _value.counter2 : counter2 as int,
    ));
  }
}

abstract class _$SampleStateCopyWith<$Res>
    implements $SampleStateCopyWith<$Res> {
  factory _$SampleStateCopyWith(
          _SampleState value, $Res Function(_SampleState) then) =
      __$SampleStateCopyWithImpl<$Res>;
  @override
  $Res call({int counter1, int counter2});
}

class __$SampleStateCopyWithImpl<$Res> extends _$SampleStateCopyWithImpl<$Res>
    implements _$SampleStateCopyWith<$Res> {
  __$SampleStateCopyWithImpl(
      _SampleState _value, $Res Function(_SampleState) _then)
      : super(_value, (v) => _then(v as _SampleState));

  @override
  _SampleState get _value => super._value as _SampleState;

  @override
  $Res call({
    Object counter1 = freezed,
    Object counter2 = freezed,
  }) {
    return _then(_SampleState(
      counter1: counter1 == freezed ? _value.counter1 : counter1 as int,
      counter2: counter2 == freezed ? _value.counter2 : counter2 as int,
    ));
  }
}

class _$_SampleState with DiagnosticableTreeMixin implements _SampleState {
  _$_SampleState({this.counter1 = 0, this.counter2 = 0})
      : assert(counter1 != null),
        assert(counter2 != null);

  @JsonKey(defaultValue: 0)
  @override
  final int counter1;
  @JsonKey(defaultValue: 0)
  @override
  final int counter2;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SampleState(counter1: $counter1, counter2: $counter2)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SampleState'))
      ..add(DiagnosticsProperty('counter1', counter1))
      ..add(DiagnosticsProperty('counter2', counter2));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SampleState &&
            (identical(other.counter1, counter1) ||
                const DeepCollectionEquality()
                    .equals(other.counter1, counter1)) &&
            (identical(other.counter2, counter2) ||
                const DeepCollectionEquality()
                    .equals(other.counter2, counter2)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(counter1) ^
      const DeepCollectionEquality().hash(counter2);

  @override
  _$SampleStateCopyWith<_SampleState> get copyWith =>
      __$SampleStateCopyWithImpl<_SampleState>(this, _$identity);
}

abstract class _SampleState implements SampleState {
  factory _SampleState({int counter1, int counter2}) = _$_SampleState;

  @override
  int get counter1;
  @override
  int get counter2;
  @override
  _$SampleStateCopyWith<_SampleState> get copyWith;
}
