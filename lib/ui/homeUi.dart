// ignore_for_file: file_names
import 'package:barbearia/const/const.dart';
import 'package:barbearia/ui/cadastroCliente.dart';
import 'package:barbearia/ui/cadastroHorario.dart';
import 'package:barbearia/ui/agendaUi.dart';
import 'package:barbearia/ui/clientesUi.dart';
import 'package:barbearia/ui/configuracoesUi.dart';
import 'package:barbearia/ui/financeiroUi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    late RxInt index = 0.obs;
    late RxBool pesquisar = false.obs;
    TextEditingController textEditingController = TextEditingController();

    return Obx(
      () => Scaffold(
        floatingActionButton: index.value == 2 || index.value == 3
            ? const SizedBox()
            : FloatingActionButton(
                disabledElevation: 0,
                tooltip: index.value == 0 && DateTime.now().isAfter(c.dataSelect.value.add(const Duration(days: 1))) ? "Escolha uma data valida" : "",
                onPressed: () {
                  if (index.value == 0) {
                    Get.to(() => const CadastroHorario());
                  } else if (index.value == 1) {
                    Get.to(() => const CadastroCliente());
                  } else {}
                },
                child: const Icon(Icons.add)),
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: pesquisar.value == true && index.value == 1
                ? TextField(
                    onChanged: (_) {
                      c.searchController.value = _;
                    },
                    controller: textEditingController,
                  )
                : Text(Preferencias.nomeApp),
            actions: index.value == 1 || index.value == 0
                ? [
                    index.value == 1
                        ? IconButton(
                            onPressed: () {
                              pesquisar.value = !pesquisar.value;
                              textEditingController.clear();
                              c.searchController.value = "";
                            },
                            icon: pesquisar.value == true ? const Icon(Icons.clear_rounded) : const Icon(Icons.search))
                        : const SizedBox(),
                    index.value == 1
                        ? Tooltip(
                            message: "Atualizar lista de Clientes",
                            child: IconButton(
                                onPressed: () {
                                  c.getClientes();
                                },
                                icon: const Icon(Icons.refresh_rounded)),
                          )
                        : Tooltip(
                            message: "Atualizar Agendamentos",
                            child: IconButton(
                                onPressed: () async {
                                  await c.getAgenda();
                                },
                                icon: const Icon(Icons.refresh_rounded)),
                          ),
                  ]
                : []),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int i) {
            index.value = i;
          },
          selectedIndex: index.value,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Agenda',
            ),
            const NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person),
              label: 'Clientes',
            ),
            NavigationDestination(
              icon: Badge(
                  isLabelVisible:
                      c.agenda.where((p0) => p0.status == "aberto").where((p0) => DateTime.now().isAfter(p0.dtAgenda ?? DateTime.now())).isNotEmpty
                          ? true
                          : false,
                  child: const Icon(Icons.attach_money_rounded)),
              label: 'Financeiro',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
        ),
        body: c.loading.value == true
            ? const Center(child: CircularProgressIndicator())
            : [
                const AgendaUi(),
                const ClientesUi(),
                const FinanceiroUi(),
                const ConfiguracoesUi(),
              ][index.value],
      ),
    );
  }
}
