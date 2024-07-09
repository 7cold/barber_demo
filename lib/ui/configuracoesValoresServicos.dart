// ignore_for_file: file_names
import 'package:barbearia/const/widget.dart';
import 'package:barbearia/data/servicos_data.dart';
import 'package:barbearia/ui/cadastroServicos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

final Controller c = Get.put(Controller());

class ConfigValoresServicos extends StatefulWidget {
  const ConfigValoresServicos({super.key});

  @override
  State<ConfigValoresServicos> createState() => _ConfigValoresServicosState();
}

class _ConfigValoresServicosState extends State<ConfigValoresServicos> {
  RxBool loadAtivo = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serviços Prestados"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const CadastroServico());
              },
              icon: const Icon(Icons.add)),
          const Tooltip(
              message: "Configure os serviços prestados para seus clientes.",
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.info_outline),
              ))
        ],
      ),
      body: Obx(
        () => c.loading.value == true
            ? WidgetsExtras.loadingCenter
            : c.servicos.isEmpty
                ? const Center(
                    child: Text("Nenhum Serviço Cadastrado"),
                  )
                : Center(
                    child: SizedBox(
                      width: !context.isPhone ? 600 : context.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    children: c.servicos
                                        .map(
                                          (ServicosData servicosData) => SizedBox(
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
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal: 10,
                                                                      vertical: 2,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(servicosData.corServico ?? 0xff000000),
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      servicosData.nome ?? "",
                                                                      style: const TextStyle(
                                                                        color: Colors.white,
                                                                        shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset.zero)],
                                                                      ),
                                                                    )),
                                                                const SizedBox(height: 5),
                                                                Text("Valor: ${c.real.format(servicosData.valor)}"),
                                                                Text("Tempo: ${servicosData.tempo}"),
                                                                Text("Qtd.: ${servicosData.qtd}"),
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    const Text("Ativo:  "),
                                                                    loadAtivo.value == true
                                                                        ? SizedBox(
                                                                            height: 18,
                                                                            width: 18,
                                                                            child: WidgetsExtras.loadingCenter,
                                                                          )
                                                                        : SizedBox(
                                                                            height: 28,
                                                                            child: FittedBox(
                                                                              fit: BoxFit.fill,
                                                                              child: Switch(
                                                                                  value: servicosData.ativo ?? true,
                                                                                  onChanged: (_) async {
                                                                                    loadAtivo.value = true;
                                                                                    servicosData.ativo = _;
                                                                                    await c.supabase.from('servicos').update({
                                                                                      "ativo": _,
                                                                                    }).eq('id', servicosData.id ?? 0);
                                                                                    c.servicos
                                                                                        .where((p0) => p0.id == servicosData.id)
                                                                                        .forEach((e) => e = servicosData);
                                                                                    loadAtivo.value = false;
                                                                                  }),
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Tooltip(
                                                              message: "Apagar",
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  c.deleteServico(servicosData);
                                                                },
                                                                icon: const Icon(size: 18, Icons.delete),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
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
