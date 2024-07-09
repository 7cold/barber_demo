import 'package:barbearia/ui/homeUi.dart';
import 'package:barbearia/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';

final Controller c = Get.put(Controller());

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return c.supabase.auth.currentSession != null ? const HomeUi() : const Login();
  }
}
