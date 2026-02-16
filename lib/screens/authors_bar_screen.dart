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

    final topTenEntries = sortedEntries.take(10).toList();
    final List<String> authorNames = topTenEntries.map((e) => e.key).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Grafico Autori"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            barTouchData: const BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                fitInsideVertically: true,
                fitInsideHorizontally: true,
              ),
            ),
            alignment: BarChartAlignment.spaceAround,
            maxY: (topTenEntries
                    .map((e) => e.value)
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble() +
                2),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= authorNames.length ||
                        value.toInt() < 0) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        authorNames[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: authorNames.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: topTenEntries[entry.key].value.toDouble(),
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
    );
  }
}
