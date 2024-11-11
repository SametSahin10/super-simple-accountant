import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';

enum ChartGrouping { daily, weekly, monthly }

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesStateModel = ref.watch(entriesStateNotifierProvider);

    if (entriesStateModel.widgetState == WidgetState.loading) {
      return const CircularProgressIndicator();
    }

    final entries = entriesStateModel.entries;

    if (entries.isEmpty) {
      // TODO: Show a nice animation here.
      return Center(
        child: Text(
          context.l10n.no_entries_found,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveAppBar(
        context: context,
        title: context.l10n.reports_screen_title,
        showAppIcon: false,
      ),
      body: EntriesBarChart(entries: entries),
    );
  }
}

class EntriesBarChart extends ConsumerStatefulWidget {
  final List<Entry> entries;

  const EntriesBarChart({super.key, required this.entries});

  @override
  ConsumerState<EntriesBarChart> createState() => _EntriesBarChartState();
}

class _EntriesBarChartState extends ConsumerState<EntriesBarChart> {
  ChartGrouping _grouping = ChartGrouping.daily;

  @override
  Widget build(BuildContext context) {
    try {
      final groupedEntries = _groupEntries();
      final currencyFormatter = ref.watch(currencyFormatterProvider);

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _ChartContainer(
                groupedEntries: groupedEntries,
                currencyFormatter: currencyFormatter!,
                grouping: _grouping,
              ),
            ),
            _GroupingButtons(
              currentGrouping: _grouping,
              onGroupingChanged: (grouping) {
                setState(() => _grouping = grouping);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return const Center(child: Text('Error loading chart'));
    }
  }

  Map<int, double> _groupEntries() {
    switch (_grouping) {
      case ChartGrouping.daily:
        return _groupEntriesByDay();
      case ChartGrouping.weekly:
        return _groupEntriesByWeek();
      case ChartGrouping.monthly:
        return _groupEntriesByMonth();
    }
  }

  Map<int, double> _groupEntriesByDay() {
    return widget.entries.fold<Map<int, double>>(
        {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0}, (map, entry) {
      final dayOfWeek = entry.createdAt.weekday;
      map[dayOfWeek] = (map[dayOfWeek] ?? 0) + entry.amount;
      return map;
    });
  }

  Map<int, double> _groupEntriesByWeek() {
    return widget.entries.fold<Map<int, double>>({1: 0, 2: 0, 3: 0, 4: 0},
        (map, entry) {
      final weekOfMonth = (entry.createdAt.day / 7).ceil();
      map[weekOfMonth] = (map[weekOfMonth] ?? 0) + entry.amount;
      return map;
    });
  }

  Map<int, double> _groupEntriesByMonth() {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 5, 1);

    final initialMap =
        Map.fromEntries(List.generate(6, (i) => MapEntry(now.month - i, 0.0)));

    return widget.entries
        .where((entry) => entry.createdAt.isAfter(sixMonthsAgo))
        .fold<Map<int, double>>(initialMap, (map, entry) {
      final month = entry.createdAt.month;
      map[month] = (map[month] ?? 0) + entry.amount;
      return map;
    });
  }
}

class _ChartContainer extends StatelessWidget {
  final Map<int, double> groupedEntries;
  final NumberFormat currencyFormatter;
  final ChartGrouping grouping;

  const _ChartContainer({
    required this.groupedEntries,
    required this.currencyFormatter,
    required this.grouping,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: context.height * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: BarChart(
          swapAnimationDuration: const Duration(milliseconds: 400),
          BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              checkToShowHorizontalLine: (value) => value == 0,
            ),
            borderData: FlBorderData(show: false),
            barTouchData: _buildBarTouchData(context),
            titlesData: _buildTitlesData(context),
            barGroups: _buildBarGroups(context),
          ),
        ),
      ),
    );
  }

  BarTouchData _buildBarTouchData(BuildContext context) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 2,
        getTooltipColor: (_) => Colors.transparent,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final amount = rod.toY;
          if (amount == 0) return null;

          return BarTooltipItem(
            currencyFormatter.format(amount),
            TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    List<String> labels;
    switch (grouping) {
      case ChartGrouping.daily:
        labels = [
          context.l10n.day_of_week_monday,
          context.l10n.day_of_week_tuesday,
          context.l10n.day_of_week_wednesday,
          context.l10n.day_of_week_thursday,
          context.l10n.day_of_week_friday,
          context.l10n.day_of_week_saturday,
          context.l10n.day_of_week_sunday,
        ];
        break;
      case ChartGrouping.weekly:
        final l10n = context.l10n;
        labels = [
          '${l10n.reports_bottom_label_week} 1',
          '${l10n.reports_bottom_label_week} 2',
          '${l10n.reports_bottom_label_week} 3',
          '${l10n.reports_bottom_label_week} 4',
        ];
        break;
      case ChartGrouping.monthly:
        final now = DateTime.now();
        labels = List.generate(6, (i) {
          final month = DateTime(now.year, now.month - i);
          return DateFormat('MMM').format(month);
        }).reversed.toList();
        break;
    }

    return FlTitlesData(
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        drawBelowEverything: true,
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 42,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            final indexOutOfBounds = index < 0 || index >= labels.length;

            if (indexOutOfBounds) {
              FirebaseCrashlytics.instance.recordError(
                'Index out of bounds while rendering '
                'bottom titles: $index. Meta: ${meta.toString()}',
                StackTrace.current,
              );
            }

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 18,
              child: Text(indexOutOfBounds ? '' : labels[index]),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    return groupedEntries.entries.map((e) {
      return BarChartGroupData(
        x: e.key - 1,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: e.value,
            width: 20,
            color: e.value.isNegative ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      );
    }).toList();
  }
}

class _GroupingButtons extends StatelessWidget {
  final ChartGrouping currentGrouping;
  final ValueChanged<ChartGrouping> onGroupingChanged;

  const _GroupingButtons({
    required this.currentGrouping,
    required this.onGroupingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _GroupingButton(
          grouping: ChartGrouping.daily,
          label: context.l10n.reports_screen_grouping_daily,
          isSelected: currentGrouping == ChartGrouping.daily,
          onPressed: onGroupingChanged,
        ),
        _GroupingButton(
          grouping: ChartGrouping.weekly,
          label: context.l10n.reports_screen_grouping_weekly,
          isSelected: currentGrouping == ChartGrouping.weekly,
          onPressed: onGroupingChanged,
        ),
      ],
    );
  }
}

class _GroupingButton extends StatelessWidget {
  final ChartGrouping grouping;
  final String label;
  final bool isSelected;
  final ValueChanged<ChartGrouping> onPressed;

  const _GroupingButton({
    required this.grouping,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
      ),
      onPressed: () => onPressed(grouping),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
