// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entries_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntriesStateModelImpl _$$EntriesStateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EntriesStateModelImpl(
      entries: (json['entries'] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toList(),
      widgetState: $enumDecode(_$WidgetStateEnumMap, json['widgetState']),
    );

Map<String, dynamic> _$$EntriesStateModelImplToJson(
        _$EntriesStateModelImpl instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'widgetState': _$WidgetStateEnumMap[instance.widgetState]!,
    };

const _$WidgetStateEnumMap = {
  WidgetState.initial: 'initial',
  WidgetState.loading: 'loading',
  WidgetState.loaded: 'loaded',
  WidgetState.error: 'error',
};
