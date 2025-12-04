import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../models/student_note_model.dart';

class ProgressChartScreen extends StatefulWidget {
  final List<StudentNote> notes;

  const ProgressChartScreen({
    super.key,
    required this.notes,
  });

  @override
  State<ProgressChartScreen> createState() => _ProgressChartScreenState();
}

class _ProgressChartScreenState extends State<ProgressChartScreen> {
  late String _selectedAspect;
  final List<String> _aspects = ['Agama', 'Jati Diri', 'STEM', 'Pancasila'];

  @override
  void initState() {
    super.initState();
    _selectedAspect = _aspects[0];
  }

  List<double> _getValuesByAspect(String aspect) {
    final values = <double>[];
    for (var note in widget.notes) {
      double value = 0;
      switch (aspect) {
        case 'Agama':
          value = _nilaiToDouble(note.nilaiAgama);
          break;
        case 'Jati Diri':
          value = _nilaiToDouble(note.nilaiJatiDiri);
          break;
        case 'STEM':
          value = _nilaiToDouble(note.nilaiSTEM);
          break;
        case 'Pancasila':
          value = _nilaiToDouble(note.nilaiPancasila);
          break;
      }
      values.add(value);
    }
    return values;
  }

  double _nilaiToDouble(String nilai) {
    switch (nilai) {
      case 'Sangat Baik':
        return 4.0;
      case 'Baik':
        return 3.0;
      case 'Cukup':
        return 2.0;
      case 'Kurang':
        return 1.0;
      default:
        return 0.0;
    }
  }

  Map<String, int> _countNilaiByAspect(String aspect) {
    int sangat = 0, baik = 0, cukup = 0, kurang = 0;
    
    for (var note in widget.notes) {
      String nilai = '';
      switch (aspect) {
        case 'Agama':
          nilai = note.nilaiAgama;
          break;
        case 'Jati Diri':
          nilai = note.nilaiJatiDiri;
          break;
        case 'STEM':
          nilai = note.nilaiSTEM;
          break;
        case 'Pancasila':
          nilai = note.nilaiPancasila;
          break;
      }
      
      switch (nilai) {
        case 'Sangat Baik':
          sangat++;
          break;
        case 'Baik':
          baik++;
          break;
        case 'Cukup':
          cukup++;
          break;
        case 'Kurang':
          kurang++;
          break;
      }
    }
    
    return {'sangat': sangat, 'baik': baik, 'cukup': cukup, 'kurang': kurang};
  }

  @override
  Widget build(BuildContext context) {
    final values = _getValuesByAspect(_selectedAspect);
    final counts = _countNilaiByAspect(_selectedAspect);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grafik Perkembangan Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selector Aspek
            const Text(
              'Pilih Aspek Perkembangan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _aspects.map((aspect) {
                  final isSelected = _selectedAspect == aspect;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedAspect = aspect);
                      },
                      label: Text(aspect),
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: AppTheme.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            // Statistik
            _buildStatisticCards(counts),
            const SizedBox(height: 32),
            // Line Chart
            const Text(
              'Perkembangan Nilai',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 300,
                  child: values.isEmpty
                      ? const Center(
                          child: Text('Belum ada data untuk grafik'),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 1,
                              verticalInterval: 1,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      'Ke-${(value + 1).toInt()}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                  interval: 1,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    switch (value.toInt()) {
                                      case 1:
                                        return const Text('Kurang');
                                      case 2:
                                        return const Text('Cukup');
                                      case 3:
                                        return const Text('Baik');
                                      case 4:
                                        return const Text('Sangat');
                                      default:
                                        return const Text('');
                                    }
                                  },
                                  interval: 1,
                                  reservedSize: 50,
                                ),
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  values.length,
                                  (index) => FlSpot(
                                    index.toDouble(),
                                    values[index],
                                  ),
                                ),
                                isCurved: true,
                                color: AppTheme.primaryBlue,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter:
                                      (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 5,
                                      color: AppTheme.primaryBlue,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppTheme.primaryBlue.withOpacity(0.1),
                                ),
                              ),
                            ],
                            minY: 0,
                            maxY: 4,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Bar Chart untuk distribusi
            const Text(
              'Distribusi Predikat',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (widget.notes.length.toDouble() > 0)
                          ? widget.notes.length.toDouble()
                          : 5,
                      barGroups: [
                        _makeGroupData(0, counts['sangat']?.toDouble() ?? 0,
                            'Sangat', Colors.green),
                        _makeGroupData(1, counts['baik']?.toDouble() ?? 0,
                            'Baik', Colors.blue),
                        _makeGroupData(2, counts['cukup']?.toDouble() ?? 0,
                            'Cukup', Colors.amber),
                        _makeGroupData(3, counts['kurang']?.toDouble() ?? 0,
                            'Kurang', Colors.red),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Sangat Baik',
                                      style: TextStyle(fontSize: 12));
                                case 1:
                                  return const Text('Baik',
                                      style: TextStyle(fontSize: 12));
                                case 2:
                                  return const Text('Cukup',
                                      style: TextStyle(fontSize: 12));
                                case 3:
                                  return const Text('Kurang',
                                      style: TextStyle(fontSize: 12));
                                default:
                                  return const Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 11),
                              );
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCards(Map<String, int> counts) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(
          'Sangat Baik',
          counts['sangat']?.toString() ?? '0',
          Colors.green,
        ),
        _buildStatCard(
          'Baik',
          counts['baik']?.toString() ?? '0',
          Colors.blue,
        ),
        _buildStatCard(
          'Cukup',
          counts['cukup']?.toString() ?? '0',
          Colors.amber,
        ),
        _buildStatCard(
          'Kurang',
          counts['kurang']?.toString() ?? '0',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withOpacity(0.1),
          border: Border.all(
            color: color.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y,
    String label,
    Color color,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
