// ignore_for_file: file_names

import 'package:barbearia/const/upperCase.dart';
import 'package:barbearia/const/widget.dart';
import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CadastroCliente extends StatefulWidget {
  const CadastroCliente({super.key});

  @override
  State<CadastroCliente> createState() => _CadastroClienteState();
}

TextEditingController nome = TextEditingController();
MaskedTextController telefone = MaskedTextController(mask: '(00) 00000-0000');
final Controller c = Get.put(Controller());
GlobalKey<FormState> formKey = GlobalKey<FormState>();

@override
void dispose() {
  nome.dispose();
  telefone.dispose();
}

class _CadastroClienteState extends State<CadastroCliente> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Cadastro de Clientes"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilledButton.icon(
                onPressed: () {
                  final FormState? form = formKey.currentState;
                  if (form!.validate()) {
                    c.createCliente(ClienteData.fromJson({'nome': nome.value.text, 'telefone': telefone.value.text})).whenComplete(() {
                      nome.text = "";
                      telefone.text = "";
                    });
                  } else {}
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text("Salvar"),
              ),
            ),
          ],
        ),
        body: c.loading.value == true
            ? WidgetsExtras.loadingCenter
            : Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: !context.isPhone ? 600 : context.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            inputFormatters: [FirstLetterTextFormatter()],
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: "Nome",
                            ),
                            controller: nome,
                            validator: (value) => value!.isEmpty ? 'Nome não pode estar vazio' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: "Telefone",
                            ),
                            controller: telefone,
                            validator: (value) => value!.isEmpty ? 'Telefone não pode estar vazio' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
