// ignore_for_file: file_names

import 'package:barbearia/const/widget.dart';
import 'package:barbearia/const/widgetCardDetail.dart';
import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:barbearia/ui/editarCliente.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetalhesCliente extends StatelessWidget {
  final ClienteData clienteData;

  const DetalhesCliente(this.clienteData, {super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(clienteData.nome ?? ""),
          actions: [
            Tooltip(
              message: "Editar Cliente",
              child: IconButton(
                  onPressed: () {
                    Get.to(() => EditarCliente(clienteData: clienteData));
                  },
                  icon: const Icon(Icons.edit_outlined)),
            ),
            Tooltip(
              message: "Atualizar Agenda",
              child: IconButton(
                  onPressed: () {
                    c.getAgenda();
                  },
                  icon: const Icon(Icons.refresh_outlined)),
            )
          ],
        ),
        body: c.loading.value == true
            ? WidgetsExtras.loadingCenter
            : c.agenda.where((p0) => p0.idCliente == clienteData.id).isEmpty
                ? const Center(
                    child: Text("Nenhum horário cadastrado"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: c.agenda
                              .where((p0) => p0.idCliente == clienteData.id)
                              .map((agendaData) => WidgetCardDetail().card(context, agendaData, showName: false))
                              .toList()
                              .reversed
                              .toList(),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
