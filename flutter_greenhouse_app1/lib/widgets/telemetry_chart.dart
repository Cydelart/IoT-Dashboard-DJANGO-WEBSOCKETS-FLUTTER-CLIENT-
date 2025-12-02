import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
>>>>>>> b8df76b (final version)
import '../models/telemetry.dart';

class TelemetryChart extends StatelessWidget {
  final List<Telemetry> telemetry;
<<<<<<< HEAD

=======
>>>>>>> b8df76b (final version)
  const TelemetryChart({super.key, required this.telemetry});

  @override
  Widget build(BuildContext context) {
    if (telemetry.isEmpty) {
      return const Center(child: Text("No telemetry data"));
    }

<<<<<<< HEAD
    // On veut le plus ancien à gauche, le plus récent à droite
    final data = telemetry.reversed.toList();

    final spots = <FlSpot>[];
    double minY = data.first.value;
    double maxY = data.first.value;

    for (var i = 0; i < data.length; i++) {
      final t = data[i];
      final x = i.toDouble();
=======
    // Plus ancien à gauche, plus récent à droite
    final displayedTelemetry = telemetry.reversed.toList();

    final firstTimestamp = displayedTelemetry.first.timestamp;
    final spots = <FlSpot>[];
    double? minY;
    double? maxY;

    for (var t in displayedTelemetry) {
      final x = t.timestamp.difference(firstTimestamp).inSeconds.toDouble();
>>>>>>> b8df76b (final version)
      final y = t.value;

      spots.add(FlSpot(x, y));

<<<<<<< HEAD
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
    }

    // un peu de marge en haut/bas
    final yPadding = (maxY - minY).abs() * 0.1;
=======
      if (minY == null || y < minY) minY = y;
      if (maxY == null || y > maxY) maxY = y;
    }

    // Marge haut/bas
    final yPadding = (maxY! - minY!).abs() * 0.1;
>>>>>>> b8df76b (final version)
    final chartMinY = minY - yPadding;
    final chartMaxY = maxY + yPadding;

    return LineChart(
      LineChartData(
        minX: 0,
<<<<<<< HEAD
        maxX: spots.length > 1 ? (spots.length - 1).toDouble() : 1,
=======
        maxX: spots.last.x,
>>>>>>> b8df76b (final version)
        minY: chartMinY,
        maxY: chartMaxY,
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        titlesData: FlTitlesData(
<<<<<<< HEAD
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
=======
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (spots.last.x / 4).clamp(1, double.infinity),
              getTitlesWidget: (value, meta) {
                // Trouver la donnée la plus proche
                final index = spots.indexWhere((s) => (s.x - value).abs() < 1);
                if (index == -1) return const SizedBox.shrink();
                final time = displayedTelemetry[index].timestamp;
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 10),
                  ),
>>>>>>> b8df76b (final version)
                );
              },
            ),
          ),
<<<<<<< HEAD
=======
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
>>>>>>> b8df76b (final version)
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
<<<<<<< HEAD
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, applyCutOffY: true),
=======
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.2),
            ),
            isStrokeCapRound: true,
>>>>>>> b8df76b (final version)
          ),
        ],
      ),
    );
  }
}
