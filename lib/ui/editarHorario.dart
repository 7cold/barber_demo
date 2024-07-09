// ignore_for_file: file_names

import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/agenda_data.dart';
import 'package:barbearia/data/horarios_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EditarHorario extends StatefulWidget {
  final AgendaData agendaData;

  const EditarHorario({super.key, required this.agendaData});

  @override
  State<EditarHorario> createState() => _EditarHorarioState();
}

final Controller c = Get.put(Controller());
GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
RxList diasSelect = [].obs;
DateRangePickerController controller = DateRangePickerController();

class _EditarHorarioState extends State<EditarHorario> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilledButton.icon(
                onPressed:
                    diasSelect.isEmpty || diasSelect.map((element) => TimeOfDay.fromDateTime(element)).contains(const TimeOfDay(hour: 0, minute: 0))
                        ? null
                        : () {
                            widget.agendaData.dtAgenda = diasSelect.first;
                            widget.agendaData.hrInicio = diasSelect.first;
                            widget.agendaData.hrFim = diasSelect.first.add(Duration(minutes: widget.agendaData.tempoServico ?? 0));

                            c.editHorario(widget.agendaData);
                          },
                icon: const Icon(Icons.check_rounded),
                label: const Text("Editar"),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: widget.agendaData.nomeCliente,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    direction: Axis.horizontal,
                    children: [
                      Chip(elevation: 2, label: Text(widget.agendaData.nomeServico ?? "")),
                      Chip(elevation: 2, label: Text("R\$ ${c.real.format(widget.agendaData.valorServico)}")),
                      Chip(elevation: 2, label: Text(c.dateFormatterSimple.format(widget.agendaData.dtAgenda ?? DateTime.now()))),
                      Chip(elevation: 2, label: Text(c.dateFormatterHora.format(widget.agendaData.hrInicio ?? DateTime.now()))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: SizedBox(
                      height: 300,
                      child: SfDateRangePickerTheme(
                        data: SfDateRangePickerThemeData(
                          headerBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          activeDatesTextStyle: const TextStyle(fontWeight: FontWeight.w600),
                          disabledDatesTextStyle: TextStyle(fontWeight: FontWeight.w100, color: Theme.of(context).highlightColor),
                        ),
                        child: SfDateRangePicker(
                          maxDate: DateTime.now().add(const Duration(days: 45)),
                          allowViewNavigation: false,
                          enablePastDates: false,
                          key: ValueKey(controller.selectedDates?.length ?? 0),
                          controller: controller,
                          selectableDayPredicate: (dateTime) {
                            if (dateTime.weekday == 7 || dateTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                              return false;
                            }

                            if (c.diasInativos.map((element) => element.data).contains(dateTime)) {
                              return false;
                            }
                            {
                              if (controller.selectedDates?.isEmpty == null) {
                                return true;
                              }

                              return controller.selectedDates!.length < (1) || controller.selectedDates!.any((element) => element == dateTime);
                            }
                          },
                          backgroundColor: Colors.transparent,
                          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                            if (args.value is List<DateTime>) {
                              diasSelect.clear();
                              diasSelect.value = args.value;
                            } else if (args.value is DateTime) {
                              diasSelect.clear();
                              diasSelect.add(args.value);
                            }
                          },
                          selectionMode: DateRangePickerSelectionMode.multiple,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: diasSelect.map((_) {
                      DateTime dia = _;
                      return Card(
                        child: ExpansionTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(c.dateFormatterSimple.format(dia)),
                          ),
                          subtitle: dia.hour == 0
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(color: Colors.amber[800], borderRadius: BorderRadius.circular(8)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            "Sem horário definido",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Chip(
                                        elevation: 2,
                                        label: Text(
                                          c.dateFormatterHora.format(dia),
                                        )),
                                  ],
                                ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children: List.generate(
                                  c.horarios.length,
                                  (index) {
                                    HorarioData horarioData = c.horarios[index];
                                    DateTime dt = DateTime(
                                      dia.year,
                                      dia.month,
                                      dia.day,
                                      horarioData.horario!.hour,
                                      horarioData.horario!.minute,
                                    );

                                    if (c.agenda.map((element) => element.dtAgenda).toList().contains(dt)) {
                                      return const SizedBox();
                                    } else if (dt.isBefore(DateTime.now())) {
                                      return const SizedBox();
                                    } else {
                                      // chip horarios disponiveis para agendamento
                                      return ChoiceChip(
                                        label: Text(horarioData.horario!.format(context).toString()),
                                        selected: dt == dia ? true : false,
                                        onSelected: (bool selected) {
                                          diasSelect[diasSelect.indexWhere((element) => element == _)] = DateTime(
                                            dia.year,
                                            dia.month,
                                            dia.day,
                                            horarioData.horario!.hour,
                                            horarioData.horario!.minute,
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
