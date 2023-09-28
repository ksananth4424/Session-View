import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/screens/sessions_screen/session_review/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarGraph extends StatelessWidget {
  final Map<String, dynamic> tags;
  const BarGraph({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(tags: tags);
    barData.initializeBarData();

    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
              maxY: tags[reviewCountField] + 0.0,
              minY: -tags[reviewCountField] + 0.0,
              barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String tip;
                  switch (group.x.toInt()) {
                    case 0:
                      tip = 'Management';
                      break;
                    case 1:
                      tip = 'Overall Management';
                      break;
                    case 2:
                      tip = 'Topic Level';
                      break;
                    case 3:
                      tip = 'Length of Session';
                      break;
                    case 4:
                      tip = 'Informative';
                      break;
                    case 5:
                      tip = 'Beginner Friendly';
                      break;
                    default:
                      tip = '';
                      break;
                  }
                  return BarTooltipItem(
                    tip,
                    GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.1,
                    ),
                  );
                },
              )),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              barGroups: barData.barData
                  .map(
                    (data) => BarChartGroupData(
                      x: data.x,
                      barRods: [
                        BarChartRodData(
                          toY: data.y / 1.0,
                          width: 25,
                          borderRadius: BorderRadius.circular(2),
                        )
                      ],
                    ),
                  )
                  .toList()),
        ),
      ),
    );
  }
}
