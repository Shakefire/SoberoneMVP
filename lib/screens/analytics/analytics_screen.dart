import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_formatter.dart';
import '../../models/check_in.dart';
import '../../models/health_milestone.dart';
import '../../providers/check_in_provider.dart';
import '../../providers/sobriety_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkInProvider = context.watch<CheckInProvider>();
    final sobrietyProvider = context.watch<SobrietyProvider>();
    final elapsed = sobrietyProvider.profile.elapsedDuration;
    final entries = checkInProvider.entries;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recovery Insights', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // 1. Top Stat Cards (Avg Craving & Total Check-ins)
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Avg Craving (7d)',
                  value: checkInProvider.averageCravingLast7Days.toStringAsFixed(1),
                  subtitle: 'Scale of 1 - 10',
                  icon: Icons.speed_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'Total Check-ins',
                  value: '${entries.length}',
                  subtitle: 'Days logged',
                  icon: Icons.event_available_rounded,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Craving & Mood Trend Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Craving Levels (Last 7 Days)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '1 (Calm) - 10 (High)',
                      style: TextStyle(fontSize: 11, color: AppColors.textMutedDark),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 180,
                  child: entries.isEmpty
                      ? const Center(child: Text('No check-in data yet'))
                      : _buildLineChart(entries),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Top Trigger Breakdown
          _buildTriggersSection(checkInProvider.triggerFrequency),
          const SizedBox(height: 16),

          // 4. Biological Recovery Timeline
          _buildHealthTimeline(elapsed),
          const SizedBox(height: 16),

          // 5. Recent Journal & Reflection Logs
          _buildCheckInHistory(entries),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMutedDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<CheckInEntry> entries) {
    final recent = entries.take(7).toList().reversed.toList();
    final spots = <FlSpot>[];

    for (int i = 0; i < recent.length; i++) {
      spots.add(FlSpot(i.toDouble(), recent[i].cravingLevel.toDouble()));
    }

    if (spots.isEmpty) {
      return const Center(child: Text('Add check-ins to see trends'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Colors.white10,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              reservedSize: 28,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < recent.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'D${recent.length - index}',
                      style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (recent.length - 1).toDouble().clamp(1.0, 6.0),
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.primaryLight,
                strokeWidth: 2,
                strokeColor: AppColors.backgroundDark,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withAlpha(80),
                  AppColors.primary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersSection(Map<String, int> triggers) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frequent Craving Triggers',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Knowing your triggers helps you prepare ahead.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 16),
          if (triggers.isEmpty)
            const Text('No triggers logged yet. Keep going!', style: TextStyle(color: AppColors.textMutedDark))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: triggers.entries.map((entry) {
                return Chip(
                  backgroundColor: AppColors.surfaceDarkLight.withAlpha(60),
                  side: const BorderSide(color: AppColors.borderDark),
                  avatar: CircleAvatar(
                    backgroundColor: AppColors.secondary.withAlpha(40),
                    child: Text(
                      '${entry.value}',
                      style: const TextStyle(fontSize: 10, color: AppColors.secondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  label: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildHealthTimeline(Duration elapsed) {
    final healthList = HealthMilestone.defaultHealthMilestones;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biological Recovery Timeline',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.monitor_heart_rounded, color: AppColors.danger, size: 20),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Physical regeneration milestones unlocked by your body.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 16),
          ...healthList.map((item) {
            final isDone = item.isComplete(elapsed);
            final progress = item.progress(elapsed);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.success.withAlpha(30) : AppColors.surfaceDarkLight.withAlpha(60),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.check_circle_rounded : item.icon,
                      color: isDone ? AppColors.success : AppColors.textMutedDark,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDone ? Colors.white : AppColors.textSecondaryDark,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDone ? AppColors.success : AppColors.textMutedDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMutedDark),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDone ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCheckInHistory(List<CheckInEntry> entries) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Journal & Check-in History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          if (entries.isEmpty)
            const Text('No entries yet.', style: TextStyle(color: AppColors.textMutedDark))
          else
            ...entries.take(5).map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withAlpha(120),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(entry.mood.emoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              entry.mood.label,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          TimeFormatter.formatDate(entry.timestamp),
                          style: const TextStyle(fontSize: 12, color: AppColors.textMutedDark),
                        ),
                      ],
                    ),
                    if (entry.note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        entry.note,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark),
                      ),
                    ],
                    if (entry.gratitude.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        '✨ ${entry.gratitude}',
                        style: const TextStyle(fontSize: 12, color: AppColors.primaryLight, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
