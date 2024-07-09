// ignore_for_file: file_names

import 'package:barbearia/ui/financeiro/finan.abertosUI.dart';
import 'package:barbearia/ui/financeiroUIConcluir.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

final Controller c = Get.put(Controller());

class FinanceiroUi extends StatelessWidget {
  const FinanceiroUi({super.key});

  @override
  Widget build(BuildContext context) {
    // RxString filtro = "30 Dias".obs;

    RxInt aberto = c.agenda.where((p0) => p0.status == "aberto").length.obs;

    Rx<num?> vaberto = c.agenda.where((p0) => p0.status == "aberto").isEmpty
        ? 0.obs
        : c.agenda.where((p0) => p0.status == "aberto").map((e) => e.valorServico).reduce((value, element) => (element ?? 0) + (value ?? 0)).obs;

    RxInt cancelado = c.agenda.where((p0) => p0.status == "cancelado").length.obs;
    Rx<num?> vcancelado = c.agenda.where((p0) => p0.status == "cancelado").isEmpty
        ? 0.obs
        : c.agenda.where((p0) => p0.status == "cancelado").map((e) => e.valorServico).reduce((value, element) => (element ?? 0) + (value ?? 0)).obs;

    RxInt concluido = c.agenda.where((p0) => p0.status == "concluido").length.obs;
    Rx<num?> vconcluido = c.agenda.where((p0) => p0.status == "concluido").isEmpty
        ? 0.obs
        : c.agenda.where((p0) => p0.status == "concluido").map((e) => e.valorServico).reduce((value, element) => (element ?? 0) + (value ?? 0)).obs;

    return Obx(
      () => SingleChildScrollView(
        child: Column(children: [
          Wid(qtd: aberto.value, valor: vaberto.value ?? 0, title: "Aberto"),
          Wid(qtd: concluido.value, valor: vconcluido.value ?? 0, title: "Concluído"),
          Wid(qtd: cancelado.value, valor: vcancelado.value ?? 0, title: "Cancelado"),
        ]),
      ),
    );
  }
}

// ignore: must_be_immutable
class Wid extends StatelessWidget {
  RxInt verifAberto = c.agenda.where((p0) => p0.status == "aberto").where((p0) => DateTime.now().isAfter(p0.dtAgenda ?? DateTime.now())).length.obs;

  final int qtd;
  final num valor;
  final String title;

  Wid({super.key, required this.qtd, required this.valor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: !context.isPhone ? 600 : context.width,
        child: Card(
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Get.to(() => const FinanAbertosUi());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w500),
                  ),
                ),
                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            Text(
                              "Num. Agendamento\n ${title}s",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 10),
                            Tooltip(
                              message: title == "Aberto" && verifAberto.value >= 1 ? "Agendamento pendente de conclusão" : "",
                              child: Badge(
                                isLabelVisible: title == "Aberto" && verifAberto.value >= 1 ? true : false,
                                label: Text(verifAberto.value.toString()),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: title == "Aberto" && verifAberto.value >= 1
                                      ? () {
                                          Get.to(() => const FinanceiroUiConcluir());
                                        }
                                      : null,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        qtd.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runAlignment: WrapAlignment.spaceEvenly,
                          direction: Axis.vertical,
                          children: [
                            Text(
                              "Valores ${title}s",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(height: 30),
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  c.real.format(valor),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
