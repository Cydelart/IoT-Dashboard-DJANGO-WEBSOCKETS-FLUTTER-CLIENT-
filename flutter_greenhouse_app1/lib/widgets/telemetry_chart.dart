import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/telemetry.dart';

class TelemetryChart extends StatelessWidget {
  final List<Telemetry> telemetry;

  const TelemetryChart({super.key, required this.telemetry});

  @override
  Widget build(BuildContext context) {
    if (telemetry.isEmpty) {
      return const Center(child: Text("No telemetry data"));
    }

    // On veut le plus ancien à gauche, le plus récent à droite
    final data = telemetry.reversed.toList();

    final spots = <FlSpot>[];
    double minY = data.first.value;
    double maxY = data.first.value;

    for (var i = 0; i < data.length; i++) {
      final t = data[i];
      final x = i.toDouble();
      final y = t.value;

      spots.add(FlSpot(x, y));

      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }

    // un peu de marge en haut/bas
    final yPadding = (maxY - minY).abs() * 0.1;
    final chartMinY = minY - yPadding;
    final chartMaxY = maxY + yPadding;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
        minY: chartMinY,
        maxY: chartMaxY,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (spots.length / 4).clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) {
                  return const SizedBox.shrink();
                }
                final t = data[index];
                // Afficher juste l'heure (HH:mm)
                final timeString =
                    "${t.timestamp.hour.toString().padLeft(2, '0')}:${t.timestamp.minute.toString().padLeft(2, '0')}";
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(timeString, style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, applyCutOffY: true),
          ),
        ],
      ),
    );
  }
}
