// ignore: file_names
import 'package:barbearia/controller/functions.dart';
import 'package:barbearia/data/agenda_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetCardDetail {
  Widget card(BuildContext context, AgendaData agendaData, {required bool showName}) => Stack(
        children: [
          SizedBox(
            width: !context.isPhone ? 600 : context.width,
            child: Card(
              child: InkWell(
                splashColor: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  FuncExtras().opcoesDetalhesClientes(agendaData, context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      showName == true
                          ? Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  agendaData.nomeCliente ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    agendaData.nomeServico ?? "",
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              agendaData.nomeServico ?? "",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Wrap(
                          direction: Axis.vertical,
                          children: [
                            Text(c.dateFormatterSimple.format(agendaData.dtAgenda ?? DateTime.now())),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    radius: 2,
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                Text(c.dateFormatterHora.format(agendaData.hrInicio ?? DateTime.now())),
                                const SizedBox(width: 8),
                                const Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: CircleAvatar(
                                    radius: 2,
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                                Text(c.dateFormatterHora.format(agendaData.hrFim ?? DateTime.now())),
                              ],
                            ),
                            Text("R\$ ${c.real.format(agendaData.valorServico)}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              width: 85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: agendaData.status == "aberto"
                    ? Colors.amber
                    : agendaData.status == "concluido"
                        ? Colors.green
                        : agendaData.status == "cancelado"
                            ? Colors.red
                            : Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Center(
                child: Text(
                  agendaData.status.toString().capitalizeFirst ?? "",
                  style: TextStyle(fontWeight: FontWeight.w500, color: agendaData.status == "aberto" ? Colors.black54 : Colors.white),
                ),
              ),
            ),
          ),
          agendaData.status == "aberto" && agendaData.dtAgenda!.isBefore(DateTime.now())
              ? Positioned(
                  right: 20,
                  top: 50,
                  child: Tooltip(
                    message: "Dias em aberto",
                    child: Container(
                      width: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Center(
                        child: Text(
                          DateTime.now().difference(agendaData.dtAgenda ?? DateTime.now()).inDays == 0
                              ? "1"
                              : DateTime.now().difference(agendaData.dtAgenda ?? DateTime.now()).inDays.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      );
}
