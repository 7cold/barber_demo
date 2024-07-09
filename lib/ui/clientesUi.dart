// ignore_for_file: file_names

import 'package:barbearia/controller/functions.dart';
import 'package:barbearia/data/clientes_data.dart';
import 'package:barbearia/ui/clientesUiDetails.dart';
import 'package:barbearia/ui/editarCliente.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/controller.dart';

class ClientesUi extends StatelessWidget {
  const ClientesUi({super.key});

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    void showModalInfo(ClienteData clienteData) {
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
                  "Detalhes",
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
                              await c.deleteCliente(clienteData);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text("Deletar"))),
                    Flexible(
                        child: TextButton.icon(
                            onPressed: () async {
                              Get.to(() => EditarCliente(
                                    clienteData: clienteData,
                                  ));

                              if (!context.mounted) return;
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text("Editar")))
                  ],
                ),
                const Spacer(flex: 2),
              ],
            )),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(
        () => Center(
          child: c.clientes.isEmpty
              ? const Text("Nenhum Cliente Cadastrado")
              : ListView.builder(
                  itemCount: c.clientes.where((p0) => p0.nome!.isCaseInsensitiveContainsAny(c.searchController.value)).toList().length,
                  itemBuilder: (_, index) {
                    ClienteData clienteData =
                        c.clientes.where((p0) => p0.nome!.isCaseInsensitiveContainsAny(c.searchController.value)).toList()[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.width > 900 ? context.width / 3 : 10),
                      child: Card(
                          child: InkWell(
                              splashColor: Theme.of(context).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Get.to(() => DetalhesCliente(clienteData));
                              },
                              onLongPress: () {
                                showModalInfo(clienteData);
                              },
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        Text(clienteData.nome ?? ""),
                                        Text(clienteData.telefone ?? ""),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Tooltip(
                                      message: "Enviar Mensagem WhatsApp",
                                      child: CircleAvatar(
                                        child: IconButton(
                                          onPressed: () {
                                            var tel = clienteData.telefone
                                                ?.replaceAll("(", "")
                                                .replaceAll(")", "")
                                                .replaceAll("-", "")
                                                .replaceAll(" ", "")
                                                .toString();
                                            launchUrl(Uri.parse("https://wa.me/+55$tel"));
                                          },
                                          icon: const FaIcon(size: 17, FontAwesomeIcons.whatsapp),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 60,
                                    child: Tooltip(
                                      message: "Próximos Atendimentos",
                                      child: CircleAvatar(
                                        child: Text(FuncExtras().atendFuturos(clienteData)),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
