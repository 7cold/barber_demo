import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class WidgetsExtras {
  static Widget loadingCenter = const Center(
    child: CircularProgressIndicator(),
  );

  static ToastificationItem toastCadastrado = toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    context: Get.context, // optional if you use ToastificationWrapper
    title: const Text("Cadastrado com sucesso!"),
    autoCloseDuration: const Duration(seconds: 5),
  );

  static ToastificationItem toastDeletado = toastification.show(
    type: ToastificationType.success,
    style: ToastificationStyle.flatColored,
    context: Get.context, // optional if you use ToastificationWrapper
    title: const Text("Deletado com sucesso!"),
    autoCloseDuration: const Duration(seconds: 5),
  );
}
