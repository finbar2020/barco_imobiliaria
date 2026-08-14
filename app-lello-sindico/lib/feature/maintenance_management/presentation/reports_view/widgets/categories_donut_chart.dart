import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/task_by_sector_entity.dart';

class CategoriesDonutChart extends StatelessWidget {
  final List<TaskBySectorDataEntity> taskBySectorData;

  const CategoriesDonutChart({
    super.key,
    required this.taskBySectorData,
  });

  // Cores padrão para usar quando não há cor específica
  List<Color> get _defaultColors => [
        Colors.purple,
        Colors.orange,
        Colors.green,
        Colors.teal,
        Colors.blue,
        Colors.lightBlueAccent,
        Colors.grey,
        Colors.lightGreen,
        Colors.yellow,
        Colors.pink,
        Colors.cyan,
        Colors.amber,
      ];

  // Converte cor hex string para Color
  Color _parseColor(String colorHex, int fallbackIndex) {
    try {
      if (colorHex.isNotEmpty) {
        // Remove o # se presente
        String hexColor = colorHex.replaceAll('#', '');

        // Adiciona FF no início se não tiver alpha
        if (hexColor.length == 6) {
          hexColor = 'FF$hexColor';
        }

        return Color(int.parse(hexColor, radix: 16));
      }
    } catch (e) {
      // Se der erro, usa cor padrão
    }
    return _getColorForIndex(fallbackIndex);
  }

  Color _getColorForIndex(int index) {
    return _defaultColors[index % _defaultColors.length];
  }

  @override
  Widget build(BuildContext context) {
    // Converter os dados da API para o formato do gráfico
    final categorias = taskBySectorData.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return {
        "label": item.name,
        "valor": item.value,
        "cor": _parseColor(item.color, index), // Usar cor da API
      };
    }).toList();

    int total =
        categorias.fold(0, (sum, item) => sum + (item["valor"] as int? ?? 0));

    if (categorias.isEmpty) {
      final categoriasDefault = [
        {"label": "Manutenção", "valor": 0, "cor": _getColorForIndex(0)},
        {"label": "Limpeza", "valor": 0, "cor": _getColorForIndex(1)},
        {"label": "Jardinagem", "valor": 0, "cor": _getColorForIndex(2)},
      ];
      return _buildChart(categoriasDefault, 0);
    }

    return _buildChart(categorias, total);
  }

  Widget _buildChart(List<Map<String, dynamic>> categorias, int total) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Título
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categorias de ordens de serviço",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            /// Gráfico
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  total > 0
                      ? PieChart(
                          PieChartData(
                            centerSpaceRadius: 50,
                            sectionsSpace: 2,
                            borderData: FlBorderData(show: false),
                            sections: categorias.map((cat) {
                              final valor = cat["valor"] as int;
                              return PieChartSectionData(
                                value: valor.toDouble(),
                                color: cat["cor"] as Color,
                                radius: 40,
                                showTitle: false,
                              );
                            }).toList(),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 2),
                          ),
                        ),

                  /// Total no centro
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "TOTAL",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "$total",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Legenda customizada
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: categorias.map((cat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color:
                            total > 0 ? cat["cor"] as Color : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${cat["valor"]} - ${cat["label"]}",
                      style: TextStyle(
                        fontSize: 12,
                        color: total > 0 ? null : Colors.grey[600],
                      ),
                    ),
                  ],
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
