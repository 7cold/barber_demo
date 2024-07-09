import 'package:barbearia/data/agenda_data.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

final Controller c = Get.find();

class FuncExtras {
  String atendFuturos(ClienteData clienteData) => c.agenda
      .where((p0) => p0.idCliente == clienteData.id)
      .where((p0) => p0.status == "aberto")
      .where((p0) => p0.dtAgenda!.isAfter(
            DateTime.now(),
          ))
      .length
      .toString();

  opcoesDetalhesClientes(AgendaData agendaData, context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
              child: Column(
            children: [
              const Spacer(flex: 1),
              const Text(
                "Opções do Agendamento",
                style: TextStyle(fontSize: 16.5),
              ),
              const Spacer(flex: 2),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Flexible(
                      child: TextButton.icon(
                          onPressed: () async {
                            agendaData.status = "concluido";
                            await c.editHorarioStatus(agendaData, "concluido");
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_rounded),
                          label: const Text("Concluído"))),
                  Flexible(
                      child: TextButton.icon(
                          onPressed: c.agenda
                                  .where((p0) => p0.status != "concluido")
                                  .where((p0) => p0.status != "cancelado")
                                  .map((element) => element.dtAgenda)
                                  .toList()
                                  .contains(agendaData.dtAgenda)
                              ? null
                              : () async {
                                  agendaData.status = "aberto";
                                  await c.editHorarioStatus(agendaData, "aberto");
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                          icon: const Icon(Icons.lock_open_rounded),
                          label: const Text("Aberto"))),
                  Flexible(
                      child: TextButton.icon(
                          onPressed: () async {
                            agendaData.status = "cancelado";
                            await c.editHorarioStatus(agendaData, "cancelado");
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text("Cancelado"))),
                ],
              ),
              const Spacer(flex: 1),
              Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                direction: Axis.horizontal,
                children: [
                  Flexible(
                      child: TextButton.icon(
                          onPressed: () async {
                            await c.deleteHorario(agendaData);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text("Deletar"))),
                ],
              ),
              const Spacer(flex: 2),
            ],
          )),
        );
      },
    );
  }
}
