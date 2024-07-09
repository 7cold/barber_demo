// ignore_for_file: file_names

import 'package:barbearia/const/widgetCardDetail.dart';
import 'package:barbearia/data/agenda_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

class FinanceiroUiConcluir extends StatelessWidget {
  const FinanceiroUiConcluir({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Controller c = Get.put(Controller());

      RxList<AgendaData> verifAberto =
          c.agenda.where((p0) => p0.status == "aberto").where((p0) => DateTime.now().isAfter(p0.dtAgenda ?? DateTime.now())).toList().obs;

      verifAberto.sort((a, b) => b.dtAgenda!.compareTo(a.dtAgenda ?? DateTime.now()));

      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Visibility(visible: false, child: Text(c.agenda.length.toString())),
          title: const Text("Agendamentos Abertos"),
          actions: [Visibility(visible: false, child: Text(c.agenda.length.toString()))],
        ),
        body: verifAberto.isEmpty
            ? const Center(
                child: Text("Nenhum horário em aberto"),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                    child: Center(
                  child: SizedBox(
                      width: !context.isPhone ? 600 : context.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: verifAberto.map((agendaData) => WidgetCardDetail().card(context, agendaData, showName: true)).toList())),
                )),
              ),
      );
    });
  }
}
