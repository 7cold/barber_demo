// ignore_for_file: file_names

import 'package:barbearia/data/agenda_data.dart';
import 'package:barbearia/ui/clientesUiDetails.dart';
import 'package:barbearia/ui/editarHorario.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/controller.dart';

class AgendaUi extends StatefulWidget {
  const AgendaUi({super.key});

  @override
  State<AgendaUi> createState() => _AgendaUiState();
}

class _AgendaUiState extends State<AgendaUi> {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Future<void> dialogBuilder(BuildContext context, AgendaData agendaData) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Wrap(
              alignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: [
                Text(agendaData.nomeCliente ?? ""),
                Wrap(
                  children: [
                    IconButton(
                        iconSize: 18,
                        splashRadius: 20,
                        tooltip: "Enviar Mensagem WhatsApp",
                        onPressed: () async {
                          var tel = c.clientes
                              .where((p0) => p0.id == agendaData.idCliente)
                              .first
                              .telefone
                              ?.replaceAll("(", "")
                              .replaceAll(")", "")
                              .replaceAll("-", "")
                              .replaceAll(" ", "")
                              .toString();

                          var text =
                              "Olá, tudo bem? Poderia confirmar seu horário para dia ${c.dateFormatterSimple.format(agendaData.dtAgenda ?? DateTime.now())} (${c.dateFormatterDiaSemana.format(agendaData.dtAgenda ?? DateTime.now())}) as ${c.dateFormatterHora.format(agendaData.hrInicio ?? DateTime.now())}?\n• Serviço: ${agendaData.nomeServico}\n• Valor: R\$ ${c.real.format(agendaData.valorServico)}\nAguardo seu retorno. Obrigado!";
                          await launchUrl(Uri.parse("https://wa.me/+55$tel?text=$text"));
                        },
                        icon: const FaIcon(size: 17, FontAwesomeIcons.whatsapp)),
                  ],
                ),
              ],
            ),
            content: Wrap(
              direction: Axis.vertical,
              children: [
                Text(
                  c.clientes.where((p0) => p0.id == agendaData.idCliente).first.telefone ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Text(agendaData.nomeServico ?? ""),
                Text(c.dateFormatterSimple.format(agendaData.dtAgenda ?? DateTime.now())),
                Text("Inicio: ${c.dateFormatterHora.format(agendaData.hrInicio ?? DateTime.now())}"),
                Text("Fim: ${c.dateFormatterHora.format(agendaData.hrFim ?? DateTime.now())}"),
                Text("R\$ ${c.real.format(agendaData.valorServico)}"),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      IconButton(
                          iconSize: 18,
                          splashRadius: 20,
                          tooltip: "Apagar horário",
                          onPressed: () async {
                            await c.deleteHorario(agendaData);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete_outline_rounded)),
                      IconButton(
                          iconSize: 18,
                          splashRadius: 20,
                          tooltip: "Marcar como Aberto",
                          onPressed: agendaData.status == "aberto"
                              ? null
                              : () {
                                  agendaData.status = "aberto";
                                  c.editHorarioStatus(agendaData, "aberto");
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                          icon: const Icon(Icons.switch_access_shortcut_outlined)),
                      IconButton(
                          iconSize: 18,
                          splashRadius: 20,
                          tooltip: "Cancelar horário",
                          onPressed: agendaData.status == "cancelado"
                              ? null
                              : () {
                                  agendaData.status = "cancelado";
                                  c.editHorarioStatus(agendaData, "cancelado");
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                          icon: const Icon(Icons.cancel_outlined)),
                      IconButton(
                          iconSize: 18,
                          splashRadius: 20,
                          tooltip: "Marcar como Concluído",
                          onPressed: agendaData.status == "cancelado"
                              ? null
                              : () async {
                                  agendaData.status = "concluido";
                                  await c.editHorarioStatus(agendaData, "concluido");
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                          icon: const Icon(Icons.check_rounded)),
                    ],
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: agendaData.dtAgenda!.isBefore(DateTime.now()) || agendaData.status != "aberto"
                    ? null
                    : () {
                        Navigator.pop(context);
                        Get.to(() => EditarHorario(agendaData: agendaData));
                      },
                child: const Text('Editar Horário'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  Get.to(() => DetalhesCliente(c.clientes.where((p0) => p0.id == agendaData.idCliente).first));
                },
                child: const Text('Info. Cliente'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Voltar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 3,
          child: Obx(
            () => SfCalendarTheme(
              data: SfCalendarThemeData.raw(
                trailingDatesBackgroundColor: context.theme.highlightColor,
                leadingDatesBackgroundColor: context.theme.highlightColor,
              ),
              child: SfCalendar(
                appointmentTimeTextFormat: 'HH:mm',
                maxDate: DateTime.now().add(const Duration(days: 45)),
                showDatePickerButton: true,
                initialDisplayDate: c.dataSelect.value,
                onTap: (calendarTapDetails) {
                  c.dataSelect.value = calendarTapDetails.date!;
                  if (calendarTapDetails.targetElement == CalendarElement.appointment) {
                    AgendaData agendaData = calendarTapDetails.appointments?.first;
                    dialogBuilder(context, agendaData);
                  }
                },
                blackoutDates: c.diasInativos.map((element) => element.data ?? DateTime.now()).toList(),
                view: CalendarView.month,
                monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                ),
                firstDayOfWeek: c.dayInit.value,
                initialSelectedDate: c.dataSelect.value,
                dataSource: MeetingDataSource(c.agenda),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<AgendaData> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].hrInicio;
  }

  @override
  DateTime getEndTime(int index) {
    AgendaData horarioData = appointments![index];
    return horarioData.hrFim!;
  }

  @override
  String getSubject(int index) {
    AgendaData horarioData = appointments![index];
    return horarioData.status == "cancelado"
        ? "${horarioData.nomeCliente ?? ""} - ${horarioData.nomeServico ?? ""} [CANCELADO]"
        : horarioData.status == "concluido"
            ? "${horarioData.nomeCliente ?? ""} - ${horarioData.nomeServico ?? ""} ${horarioData.obsPacote == "[1/1]" ? "" : horarioData.obsPacote} [CONCLUÍDO]"
            : "${horarioData.nomeCliente ?? ""} - ${horarioData.nomeServico ?? ""} ${horarioData.obsPacote == "[1/1]" ? "" : horarioData.obsPacote}";
  }

  @override
  Color getColor(int index) {
    AgendaData horarioData = appointments![index];
    return horarioData.status == "cancelado"
        ? Colors.red
        : horarioData.status == "concluido"
            ? Colors.green.shade300
            : Color(horarioData.corServico ?? 1);
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
