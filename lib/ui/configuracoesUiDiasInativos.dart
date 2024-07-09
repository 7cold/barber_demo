// ignore_for_file: file_names
import 'package:barbearia/data/diasInativos_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

class ConfiguracoesUiDiasInativos extends StatelessWidget {
  const ConfiguracoesUiDiasInativos({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    Rxn<DateTime> selectedDate = Rxn<DateTime>();
    Rx<TextEditingController> obs = TextEditingController().obs;

    selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,

        initialDate: selectedDate.value, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.input,
        selectableDayPredicate: (DateTime day) {
          if (!day.isAfter(DateTime.now())) {
            return false;
          }
          return !c.diasInativos.map((element) => element.data).contains(day);
        },
      );
      if (picked != null && picked != selectedDate) selectedDate.value = picked;
    }

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Tooltip(
              message: "Configure os dias inativos de agendamentos para seus clientes.",
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.info_outline),
              ))
        ],
        title: const Text("Dias Inativos"),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              readOnly: true,
                              controller: TextEditingController(text: c.dateFormatterSimple.format(selectedDate.value ?? DateTime.now())),
                              decoration: InputDecoration(
                                suffix: IconButton(
                                    onPressed: () {
                                      selectDate(context);
                                    },
                                    icon: const Icon(Icons.calendar_month)),
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
                                    : () async {
                                        await c
                                            .createDiasInativos(DiasInativosData(
                                              obs: obs.value.text,
                                              data: selectedDate.value,
                                            ))
                                            .whenComplete(() => obs.value.clear());
                                      },
                                icon: const Icon(Icons.add)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: obs.value,
                        decoration: const InputDecoration(
                          hintText: "Observação",
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Expanded(
                    child: c.diasInativos.isEmpty
                        ? const Center(
                            child: Text("Sem datas inativas de agendamento"),
                          )
                        : SingleChildScrollView(
                            child: Column(
                                children: c.diasInativos
                                    .map(
                                      (dData) => SizedBox(
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
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(c.dateFormatterSimple.format(dData.data ?? DateTime.now())),
                                                            Text(dData.obs ?? ""),
                                                          ],
                                                        ),
                                                        Tooltip(
                                                          message: "Apagar",
                                                          child: IconButton(
                                                            onPressed: () {
                                                              c.deleteDiasInativos(dData);
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
