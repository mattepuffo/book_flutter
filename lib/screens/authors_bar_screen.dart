import 'package:book_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/book.dart';

class AuthorsBarScreen extends StatefulWidget {
  static const routeName = '/authors_bar';

  const AuthorsBarScreen({super.key});

  @override
  State<AuthorsBarScreen> createState() => _AuthorsBarScreenState();
}

class _AuthorsBarScreenState extends State<AuthorsBarScreen> {
  final utils = Utils();
  late List<Color> barColors = utils.barColors;

  static const double barRowHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final objArgs = ModalRoute.of(context)?.settings.arguments;
    final List<Book> books = (objArgs as List<Book>?) ?? [];

    if (books.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Nessun dato trovato")),
      );
    }

    final Map<String, int> data = {};
    for (var b in books) {
      final name = b.author ?? "Ignoto";
      data[name] = (data[name] ?? 0) + 1;
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<String> authorNames = sortedEntries.map((e) => e.key).toList();
    final double maxX = sortedEntries.first.value.toDouble() + 2;

    final double chartHeight = authorNames.length * barRowHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Grafico Autori"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: chartHeight,
            child: BarChart(
              BarChartData(
                rotationQuarterTurns: 1,
                barTouchData: const BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideVertically: true,
                    fitInsideHorizontally: true,
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxX,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 140,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= authorNames.length) {
                          return const SizedBox();
                        }

                        return RotatedBox(
                          quarterTurns: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              authorNames[index],
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: authorNames.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: sortedEntries[entry.key].value.toDouble(),
                        color: barColors[entry.key % barColors.length],
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
