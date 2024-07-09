// ignore_for_file: file_names
import 'package:barbearia/controller/controller.dart';
import 'package:barbearia/ui/configuracoesHorarios.dart';
import 'package:barbearia/ui/configuracoesUiDiasInativos.dart';
import 'package:barbearia/ui/configuracoesValoresServicos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final Controller c = Get.put(Controller());

class ConfiguracoesUi extends StatelessWidget {
  const ConfiguracoesUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                opcao(context, () {
                  Get.to(() => const ConfiguracoesUiDiasInativos());
                }, "Conf. Dias Inativos"),
                opcao(context, () {
                  Get.to(() => const ConfiguracoesHorarios());
                }, "Conf. Horários de Atendimento"),
                opcao(context, () {
                  Get.to(() => const ConfigValoresServicos());
                }, "Conf. Serviços Prestados"),
                opcaoSwitch(context),
                opcao(context, () {
                  c.logout();
                }, "Logout"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget opcao(BuildContext context, func, String title) {
    return SizedBox(
      width: !context.isPhone ? 600 : context.width,
      child: Card(
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
          onTap: func,
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
                      Text(title),
                      const Icon(size: 18, Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget opcaoSwitch(BuildContext context) {
    return SizedBox(
      width: !context.isPhone ? 600 : context.width,
      child: Card(
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.isDarkMode ? Get.changeThemeMode(ThemeMode.light) : Get.changeThemeMode(ThemeMode.dark);
            c.box.value.write("theme", Get.isDarkMode ? false : true);
          },
          child: Padding(
            padding: const EdgeInsets.all(3.0),
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
                      const Text("Modo Escuro"),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                              value: Get.isDarkMode,
                              onChanged: (_) {
                                _ == true ? Get.changeThemeMode(ThemeMode.dark) : Get.changeThemeMode(ThemeMode.light);
                                c.box.value.write("theme", Get.isDarkMode ? false : true);
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
