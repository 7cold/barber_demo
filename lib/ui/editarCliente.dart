// ignore_for_file: file_names

import 'package:barbearia/const/widget.dart';
import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditarCliente extends StatefulWidget {
  final ClienteData clienteData;

  const EditarCliente({super.key, required this.clienteData});

  @override
  State<EditarCliente> createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    TextEditingController nome = TextEditingController(text: widget.clienteData.nome);
    MaskedTextController telefone = MaskedTextController(text: widget.clienteData.telefone, mask: '(00) 00000-0000');

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton.icon(
              onPressed: () {
                widget.clienteData.nome = nome.text;
                widget.clienteData.telefone = telefone.text;

                c.editCliente(widget.clienteData);
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Salvar"),
            ),
          ),
        ],
      ),
      body: c.loading.value == true
          ? WidgetsExtras.loadingCenter
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: !context.isPhone ? 600 : context.width,
                    child: Column(
                      children: [
                        TextField(
                          controller: nome,
                          decoration: const InputDecoration(filled: true, hintText: "Nome"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: telefone,
                          decoration: const InputDecoration(filled: true, hintText: "Telefone"),
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
