// ignore_for_file: file_names
import 'package:barbearia/data/horarios_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

class ConfiguracoesHorarios extends StatelessWidget {
  const ConfiguracoesHorarios({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Rxn<TimeOfDay> selectedDate = Rxn<TimeOfDay>();

    selectDate(BuildContext context) async {
      var picked = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context,
      );
      if (picked != null && picked != selectedDate) selectedDate.value = picked;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Horários de Atendimento"),
        actions: const [
          Tooltip(
              message: "Configure os horários visiveis para seus clientes.",
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.info_outline),
              ))
        ],
      ),
      body: Obx(
        () => Center(
          child: SizedBox(
            width: !context.isPhone ? 600 : context.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.vertical,
                children: [
                  SizedBox(
                    height: 100,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: selectedDate.value?.minute == null
                                    ? "Selecione"
                                    : c.dateFormatterHora
                                        .format(DateTime(1, 1, 1, selectedDate.value?.hour ?? 00, selectedDate.value?.minute ?? 00))),
                            decoration: InputDecoration(
                              suffix: IconButton(
                                  onPressed: () {
                                    selectDate(context);
                                  },
                                  icon: const Tooltip(message: "Selecionar horário", child: Icon(Icons.timer_sharp))),
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Tooltip(
                          message: "Adicionar Data",
                          child: IconButton(
                              onPressed: selectedDate.value == null
                                  ? null
                                  : () {
                                      c.createHorarioConf(HorarioData(horario: selectedDate.value));
                                    },
                              icon: const Icon(Icons.add)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          children: c.horarios
                              .map(
                                (horarioData) => SizedBox(
                                  width: context.width,
                                  child: Card(
                                    child: InkWell(
                                      splashColor: Theme.of(context).colorScheme.inversePrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(c.dateFormatterHora
                                                      .format(DateTime(1, 1, 1, horarioData.horario!.hour, horarioData.horario!.minute))),
                                                  Tooltip(
                                                    message: "Apagar",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        c.deleteHorarioConf(horarioData);
                                                      },
                                                      icon: const Icon(size: 18, Icons.delete),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
