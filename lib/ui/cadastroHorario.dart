// ignore_for_file: file_names

import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:barbearia/data/agenda_data.dart';
import 'package:barbearia/data/horarios_data.dart';
import 'package:barbearia/data/servicos_data.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CadastroHorario extends StatefulWidget {
  const CadastroHorario({super.key});

  @override
  State<CadastroHorario> createState() => _CadastroHorarioState();
}

final Controller c = Get.put(Controller());
GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
Rxn<ClienteData> clienteSelect = Rxn<ClienteData>();
Rxn<ServicosData> servicosSelect = Rxn<ServicosData>();
RxList diasSelect = [].obs;
DateRangePickerController controller = DateRangePickerController();

class _CadastroHorarioState extends State<CadastroHorario> {
  @override
  void dispose() {
    clienteSelect.value = null;
    servicosSelect.value = null;
    controller.dispose();
    diasSelect.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilledButton.icon(
                onPressed: diasSelect.map((element) => TimeOfDay.fromDateTime(element)).contains(const TimeOfDay(hour: 0, minute: 0)) ||
                        diasSelect.isEmpty ||
                        clienteSelect.value == null ||
                        servicosSelect.value?.qtd != diasSelect.length
                    ? null
                    : () async {
                        num t = 0;
                        for (DateTime element in diasSelect) {
                          t = t + 1;
                          await c.createHorario(
                            AgendaData(
                                dtAgenda: element,
                                obsPacote: "[${"$t/${diasSelect.length}"}]",
                                idCliente: clienteSelect.value?.id,
                                idServico: servicosSelect.value?.id,
                                corServico: servicosSelect.value?.corServico,
                                nomeCliente: clienteSelect.value?.nome,
                                nomeServico: servicosSelect.value?.nome,
                                tempoServico: servicosSelect.value?.tempo,
                                valorServico: servicosSelect.value!.qtd! > 1
                                    ? (servicosSelect.value!.valor! / (servicosSelect.value?.qtd ?? 1))
                                    : servicosSelect.value!.valor!,
                                hrFim: element.add(Duration(minutes: servicosSelect.value?.tempo ?? 0)),
                                hrInicio: element,
                                status: "aberto"),
                          );
                        }
                      },
                icon: const Icon(Icons.check_rounded),
                label: const Text("Agendar"),
              ),
            ),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: !context.isPhone ? 600 : context.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: DropDownSearchField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: TextEditingController(text: clienteSelect.value?.nome),
                              decoration: const InputDecoration(hintText: "Cliente", filled: true),
                            ),
                            suggestionsCallback: (pattern) async {
                              return c.clientes.where((ClienteData option) {
                                return option.nome.toString().toLowerCase().contains(pattern.toLowerCase());
                              });
                            },
                            itemBuilder: (context, data) {
                              return ListTile(
                                title: Text(data.nome ?? ""),
                                subtitle: Text(c.maskFormatter.maskText(data.telefone ?? "")),
                              );
                            },
                            onSuggestionSelected: (data) {
                              clienteSelect.value = data;
                            },
                            displayAllSuggestionWhenTap: true),
                      ),
                      const SizedBox(height: 12),
                      DropDownSearchField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: TextEditingController(text: servicosSelect.value?.nome),
                          decoration: const InputDecoration(hintText: "Serviço", filled: true),
                        ),
                        suggestionsCallback: (pattern) async {
                          return c.servicos.where((p0) => p0.ativo == true).where((ServicosData servicoNome) {
                            return servicoNome.nome.toString().toLowerCase().contains(pattern.toLowerCase());
                          });
                        },
                        itemBuilder: (context, data) {
                          return ListTile(title: Text(data.nome ?? ""), subtitle: Text("R\$ ${c.real.format(data.valor ?? 0)}"));
                        },
                        onSuggestionSelected: (data) {
                          diasSelect.clear();
                          servicosSelect.value = data;
                        },
                        displayAllSuggestionWhenTap: true,
                      ),
                      const SizedBox(height: 12),
                      servicosSelect.value?.qtd == null
                          ? const SizedBox()
                          : Card(
                              child: SizedBox(
                                height: 300,
                                child: SfDateRangePickerTheme(
                                  data: SfDateRangePickerThemeData(
                                    headerBackgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                    activeDatesTextStyle: const TextStyle(fontWeight: FontWeight.w600),
                                    disabledDatesTextStyle: TextStyle(fontWeight: FontWeight.w100, color: context.theme.highlightColor),
                                  ),
                                  child: SfDateRangePicker(
                                    key: ValueKey(controller.selectedDates?.length ?? 0),
                                    maxDate: DateTime.now().add(const Duration(days: 45)),
                                    allowViewNavigation: false,
                                    controller: controller,
                                    selectableDayPredicate: (date) {
                                      if (date.weekday == 7 || date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                                        return false;
                                      }
                                      if (c.diasInativos.map((element) => element.data).contains(date)) {
                                        return false;
                                      }
                                      {
                                        if (controller.selectedDates?.length == null) {
                                          return true;
                                        }

                                        return controller.selectedDates!.length < (servicosSelect.value?.qtd ?? 0) ||
                                            controller.selectedDates!.any((element) => element == date);
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
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(c.dateFormatterSimple.format(dia)),
                              ),
                              subtitle: dia.hour == 0
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(color: Colors.amber[700], borderRadius: BorderRadius.circular(8)),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                              child: Text(
                                                "Escolha um Horário",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            )),
                                      ],
                                    )
                                  : Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 6,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(8)),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                              child: Text(
                                                c.dateFormatterHora.format(dia),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                              ),
                                            )),
                                        Container(
                                          decoration: BoxDecoration(color: Colors.green[500], borderRadius: BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                            child: (servicosSelect.value?.qtd ?? 0) > 1
                                                ? Text(
                                                    "Unit. no Pacote: R\$ ${c.real.format((servicosSelect.value!.valor! / (servicosSelect.value?.qtd ?? 1)))}",
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                  )
                                                : Text(
                                                    "R\$ ${c.real.format(servicosSelect.value?.valor ?? 0)}",
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    runSpacing: 6,
                                    spacing: 5,
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

                                        if (c.agenda
                                            .where((p0) => p0.status != "cancelado")
                                            .map((element) => element.dtAgenda)
                                            .toList()
                                            .contains(dt)) {
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
        ),
      ),
    );
  }
}
