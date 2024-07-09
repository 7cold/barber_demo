import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/servicos_data.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:get/get.dart';

class CadastroServico extends StatefulWidget {
  const CadastroServico({super.key});

  @override
  State<CadastroServico> createState() => _CadastroServicoState();
}

final Controller c = Get.put(Controller());
TextEditingController nomeSer = TextEditingController();
MoneyMaskedTextController valorSer = MoneyMaskedTextController();
TextEditingController tempoSer = TextEditingController();
TextEditingController qtdSer = TextEditingController();
RxBool isPacote = false.obs;
late Color selectColor;
GlobalKey<FormState> formKey_ = GlobalKey<FormState>();

class _CadastroServicoState extends State<CadastroServico> {
  @override
  void initState() {
    selectColor = Colors.blue;
    super.initState();
  }

  @override
  void dispose() {
    nomeSer.clear();
    valorSer.clear();
    tempoSer.clear();
    qtdSer.clear();
    isPacote.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Serviço"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilledButton.icon(
                onPressed: () {
                  final FormState? form = formKey_.currentState;

                  if (form!.validate()) {
                    c
                        .createServico(
                            ServicosData.fromJson({
                              'ser_nome': nomeSer.value.text.capitalizeFirst,
                              'ser_valor': valorSer.numberValue,
                              'ser_cor': "123",
                              'ser_tempo': int.parse(tempoSer.value.text),
                              'ser_qtd': isPacote.value == true ? int.parse(qtdSer.value.text) : 1,
                              'ativo': true,
                            }),
                            selectColor.hexAlpha.toString())
                        .whenComplete(() {
                      nomeSer.clear();
                      valorSer.updateValue(0.0);
                      tempoSer.clear();
                      qtdSer.clear();
                    });
                  }
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text("Salvar"),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey_,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nomeSer,
                      validator: (value) => value!.isEmpty ? 'Nome não pode estar vazio' : null,
                      decoration: const InputDecoration(
                        hintText: "Nome Serviço",
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: valorSer,
                      validator: (value) => value == "0,00" ? 'Valor não pode estar vazio' : null,
                      textAlign: TextAlign.start,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Valor Serviço",
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: tempoSer,
                      validator: (value) => value!.isEmpty ? 'Tempo não pode estar vazio' : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: "Tempo (Minutos)",
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Este serviços será um pacote?"),
                        Checkbox(
                            value: isPacote.value,
                            onChanged: (_) {
                              isPacote.value = _!;
                            }),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPacote.value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: qtdSer,
                        validator: (value) => value!.isEmpty ? 'Qtd. não pode estar vazio' : null,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: "Qtd. Serviços (Pacote)",
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Card(
                        elevation: 2,
                        child: ColorPicker(
                          color: selectColor,
                          onColorChanged: (Color x) => setState(() {
                            selectColor = x;
                          }),
                          width: 44,
                          height: 44,
                          borderRadius: 22,
                          subheading: Text(
                            'Tons',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          heading: Text(
                            'Selecione uma cor',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
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
