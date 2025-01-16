import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/models/entry.dart';

part 'entries_state_model.freezed.dart';
part 'entries_state_model.g.dart';

@freezed
class EntriesStateModel with _$EntriesStateModel {
  factory EntriesStateModel({
    required List<Entry> entries,
    required WidgetState widgetState,
    required bool isSyncing,
  }) = _EntriesStateModel;

  factory EntriesStateModel.initial() {
    return EntriesStateModel(
      entries: [],
      widgetState: WidgetState.initial,
      isSyncing: false,
    );
  }

  factory EntriesStateModel.fromJson(Map<String, dynamic> json) =>
      _$EntriesStateModelFromJson(json);
}
