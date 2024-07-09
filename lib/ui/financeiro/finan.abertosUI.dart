// ignore_for_file: file_names
import 'package:barbearia/const/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../controller/controller.dart';

final Controller c = Get.put(Controller());

class FinanAbertosUi extends StatefulWidget {
  const FinanAbertosUi({super.key});

  @override
  State<FinanAbertosUi> createState() => _FinanAbertosUiState();
}

dataAbertosQtd() {
  Map<String, num> resumo = {};

  for (int mes = 1; mes <= 12; mes++) {
    String mesAno = "$mes/24";
    resumo[mesAno] = 0;
  }

  for (var item in c.agenda.where((p0) => p0.dtAgenda?.year == DateTime.now().year)) {
    String mesAno = "${item.dtAgenda?.month}/${item.dtAgenda?.year.toString().replaceAll("20", "")}";

    if (resumo.containsKey(mesAno)) {
      resumo[mesAno] = resumo[mesAno]! + 1;
    } else {
      resumo[mesAno] = 1;
    }
  }

  List listaResumo = resumo.entries.map((entry) {
    return [entry.key, entry.value];
  }).toList();

  return listaResumo;
}

dataAbertosValores() {
  Map<String, num> resumo = {};

  for (int mes = 1; mes <= 12; mes++) {
    String mesAno = "$mes/24";
    resumo[mesAno] = 0;
  }

  for (var item in c.agenda.where((p0) => p0.dtAgenda?.year == DateTime.now().year)) {
    String mesAno = "${item.dtAgenda?.month}/${item.dtAgenda?.year.toString().replaceAll("20", "")}";

    if (resumo.containsKey(mesAno)) {
      resumo[mesAno] = resumo[mesAno]! + (item.valorServico ?? 1);
    } else {
      resumo[mesAno] = 1;
    }
  }

  List listaResumo = resumo.entries.map((entry) {
    return [entry.key, entry.value];
  }).toList();

  return listaResumo;
}

class _FinanAbertosUiState extends State<FinanAbertosUi> {
  @override
  Widget build(BuildContext context) {
    dataAbertosQtd();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financeiro"),
      ),
      body: Obx(() => c.loading.value == true
          ? WidgetsExtras.loadingCenter
          : Column(
              children: [
//ABERTOS QUANTIDADE
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: Wrap(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Agendamentos Abertos",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: SfCartesianChart(
                            plotAreaBorderColor: Colors.transparent,
                            plotAreaBackgroundColor: Colors.transparent,
                            primaryXAxis: const CategoryAxis(
                              majorTickLines: MajorTickLines(color: Colors.transparent),
                            ),
                            primaryYAxis: const NumericAxis(
                              isVisible: false,
                            ),
                            series: [
                              ColumnSeries(
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                        return Text(
                                          data[1].toString(),
                                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                        );
                                      }),
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  dataSource: dataAbertosQtd(),
                                  enableTooltip: true,
                                  xValueMapper: (sales, _) => sales[0],
                                  yValueMapper: (sales, _) => sales[1])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
//ABERTOS VALORES
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: Wrap(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Valores em Abertos",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: SfCartesianChart(
                            plotAreaBorderColor: Colors.transparent,
                            plotAreaBackgroundColor: Colors.transparent,
                            primaryXAxis: const CategoryAxis(
                              majorTickLines: MajorTickLines(color: Colors.transparent),
                            ),
                            primaryYAxis: const NumericAxis(
                              isVisible: false,
                            ),
                            series: [
                              ColumnSeries(
                                  dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                        return Text(
                                          c.real.format(data[1]),
                                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                        );
                                      }),
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  dataSource: dataAbertosValores(),
                                  enableTooltip: true,
                                  xValueMapper: (sales, _) => sales[0],
                                  yValueMapper: (sales, _) => sales[1])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}
