import 'dart:math' as math;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide WidgetState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/admob_config.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/currency_formatter.dart';
import 'package:super_simple_accountant/enums.dart';
import 'package:super_simple_accountant/extensions.dart';
import 'package:super_simple_accountant/models/entry.dart';
import 'package:super_simple_accountant/state/entries_state_notifier.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:super_simple_accountant/widgets/banner_ad_widget.dart';
import 'package:super_simple_accountant/widgets/responsive_app_bar.dart';
import 'package:lottie/lottie.dart';

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/sleeping_cat.json',
              width: context.width * 0.8,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                context.l10n.no_entries_found,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: ResponsiveAppBar(
        context: context,
        title: context.l10n.reports_screen_title,
        showAppIcon: false,
      ),
      body: Column(
        children: [
          BannerAdWidget(
            adUnitId: getAdUnitId(AdUnit.reportsScreenBanner),
          ),
          Expanded(child: EntriesBarChart(entries: entries)),
        ],
      ),
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

      return Column(
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
              FirebaseAnalytics.instance.logEvent(
                name: AnalyticsEvents.reportsScreenGroupingChanged,
                parameters: {
                  AnalyticsParameters.grouping: grouping.name,
                },
              );

              setState(() => _grouping = grouping);
            },
          ),
          const SizedBox(height: 24),
        ],
      );
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return const Center(child: Text('Error loading chart'));
    }
  }

  Map<DateTime, double> _groupEntries() {
    switch (_grouping) {
      case ChartGrouping.daily:
        return _groupEntriesByDay();
      case ChartGrouping.weekly:
        return _groupEntriesByWeek();
      case ChartGrouping.monthly:
        return _groupEntriesByMonth();
    }
  }

  Map<DateTime, double> _groupEntriesByDay() {
    final groupedByDay = <DateTime, double>{};

    for (var entry in widget.entries) {
      final day = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      groupedByDay[day] = (groupedByDay[day] ?? 0) + entry.amount;
    }

    return groupedByDay;
  }

  Map<DateTime, double> _groupEntriesByWeek() {
    final groupedByWeek = <DateTime, double>{};

    for (var entry in widget.entries) {
      // Get start of the week (Monday)
      final weekStart =
          entry.createdAt.subtract(Duration(days: entry.createdAt.weekday - 1));
      final week = DateTime(weekStart.year, weekStart.month, weekStart.day);
      groupedByWeek[week] = (groupedByWeek[week] ?? 0) + entry.amount;
    }

    return groupedByWeek;
  }

  Map<DateTime, double> _groupEntriesByMonth() {
    final groupedByMonth = <DateTime, double>{};

    for (var entry in widget.entries) {
      final month = DateTime(entry.createdAt.year, entry.createdAt.month);
      groupedByMonth[month] = (groupedByMonth[month] ?? 0) + entry.amount;
    }

    return groupedByMonth;
  }
}

class _ChartContainer extends StatelessWidget {
  final Map<DateTime, double> groupedEntries;
  final CurrencyFormatter currencyFormatter;
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(context.width, groupedEntries.length * 60.0),
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
        labels = groupedEntries.keys.map((date) {
          return DateFormat('E, MMM d').format(date);
        }).toList();
        break;

      case ChartGrouping.weekly:
        labels = groupedEntries.keys.map((date) {
          final weekStart = date;
          final weekEnd = weekStart.add(const Duration(days: 6));
          if (weekStart.month == weekEnd.month) {
            // Same month: "Oct 1-7"
            return '${DateFormat('MMM d').format(weekStart)}-${DateFormat('d').format(weekEnd)}';
          } else {
            // Different months: "Sep 29-Oct 5"
            return '${DateFormat('MMM d').format(weekStart)}-${DateFormat('MMM d').format(weekEnd)}';
          }
        }).toList();
        break;

      case ChartGrouping.monthly:
        labels = groupedEntries.keys.map((date) {
          return DateFormat('MMM yyyy').format(date);
        }).toList();
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
          reservedSize: 60,
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

            final rotateLabels = labels.length > 5;

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 32,
              child: Transform.rotate(
                angle: rotateLabels ? -30 * math.pi / 180 : 0,
                child: Text(
                  indexOutOfBounds ? '' : labels[index],
                  style: TextStyle(fontSize: rotateLabels ? 10 : 12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    return groupedEntries.entries.map((e) {
      return BarChartGroupData(
        x: groupedEntries.keys.toList().indexOf(e.key),
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
        _GroupingButton(
          grouping: ChartGrouping.monthly,
          label: context.l10n.reports_screen_grouping_monthly,
          isSelected: currentGrouping == ChartGrouping.monthly,
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
