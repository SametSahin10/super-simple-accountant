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
      body: DailyBarChart(entries: entries),
    );
  }
}

class DailyBarChart extends ConsumerStatefulWidget {
  final List<Entry> entries;

  const DailyBarChart({super.key, required this.entries});

  @override
  ConsumerState<DailyBarChart> createState() => _DailyBarChartState();
}

class _DailyBarChartState extends ConsumerState<DailyBarChart> {
  ChartGrouping _grouping = ChartGrouping.daily;

  @override
  Widget build(BuildContext context) {
    final groupedEntries = _groupEntries();
    final currencyFormatter = ref.watch(currencyFormatterProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Container(
                height: context.height * 0.5,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: BarChart(
                  swapAnimationDuration: const Duration(milliseconds: 400),
                  BarChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData:
                        _buildBarTouchData(context, currencyFormatter!),
                    titlesData: _buildTitlesData(),
                    barGroups: _buildBarGroups(context, groupedEntries),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGroupingButton(
                ChartGrouping.daily,
                context.l10n.reports_screen_grouping_daily,
              ),
              _buildGroupingButton(
                ChartGrouping.weekly,
                context.l10n.reports_screen_grouping_weekly,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGroupingButton(ChartGrouping grouping, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _grouping == grouping
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
      ),
      onPressed: () => setState(() => _grouping = grouping),
      child: Text(
        label,
        style: TextStyle(
          color: _grouping == grouping
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
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

  BarTouchData _buildBarTouchData(
    BuildContext context,
    NumberFormat currencyFormatter,
  ) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipPadding: EdgeInsets.zero,
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

  FlTitlesData _buildTitlesData() {
    List<String> labels;
    switch (_grouping) {
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
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            return Text(labels[index]);
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    BuildContext context,
    Map<int, double> groupedEntries,
  ) {
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
