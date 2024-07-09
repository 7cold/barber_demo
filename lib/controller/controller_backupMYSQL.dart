// import 'package:barbearia/data/clientes_data.dart';
// import 'package:barbearia/data/agenda_data.dart';
// import 'package:barbearia/data/diasInativos_data.dart';
// import 'package:barbearia/data/horarios_data.dart';
// import 'package:barbearia/data/servicos_data.dart';
// import 'package:barbearia/data/user_data.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:barbearia/api/pathAPI.dart';
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Controller extends GetxController {
//   @override
//   onInit() async {
//     loadData();
//     super.onInit();
//   }

//   SupabaseClient supabase = Supabase.instance.client;
//   GetStorage currentUserStorage = GetStorage();
//   Rxn<UserData> currentUser = Rxn<UserData>();
//   RxList<ClienteData> clientes = <ClienteData>[].obs;
//   RxList<UserData> users = <UserData>[].obs;
//   RxList<ServicosData> servicos = <ServicosData>[].obs;
//   RxList<HorarioData> horarios = <HorarioData>[].obs;
//   RxList<AgendaData> agenda = <AgendaData>[].obs;
//   RxList<DiasInativosData> diasInativos = <DiasInativosData>[].obs;

//   RxInt dayInit = 7.obs;

//   Rx<DateTime> dataSelect = DateTime.now().obs;

//   RxBool loading = false.obs;

//   DateFormat dateFormatterSimple = DateFormat('dd/MM/yyyy', 'pt_br');
//   DateFormat dateFormatterDiaSemana = DateFormat('EEEE', 'pt_br');
//   DateFormat dateFormatterHora = DateFormat('HH:mm', 'pt_br');

//   var maskFormatter = MaskTextInputFormatter(
//     mask: '(##) #####-####',
//     filter: {"#": RegExp(r'[0-9]')},
//     type: MaskAutoCompletionType.lazy,
//   );

//   NumberFormat real = NumberFormat("#,##0.00", "pt_BR");

//   Future getClientes() async {
//     loading.value = true;
//     clientes.clear();
//     final response = await http.get(
//       Uri.parse("${Env.URL_PREFIX}/list.php"),
//     );

//     if (response.statusCode == 200) {
//       for (var x in json.decode(response.body)) {
//         ClienteData clienteData = ClienteData.fromJson(x);
//         clientes.add(clienteData);
//       }
//       clientes.refresh();
//       clientes.sort((a, b) => a.nome!.compareTo(b.nome ?? ""));
//       loading.value = false;
//     } else {
//       Get.snackbar("Get Clientes Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future getUsers() async {
//     loading.value = true;
//     users.clear();
//     final response = await http.get(
//       Uri.parse("${Env.URL_PREFIX}/listUsers.php"),
//     );

//     if (response.statusCode == 200) {
//       for (var x in json.decode(response.body)) {
//         UserData userData = UserData.fromJson(x);
//         users.add(userData);
//       }
//       users.refresh();
//       users.sort((a, b) => a.user!.compareTo(b.user ?? ""));
//       loading.value = false;
//     } else {
//       Get.snackbar("Get Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future getServicos() async {
//     loading.value = true;
//     servicos.clear();
//     final response = await http.get(
//       Uri.parse("${Env.URL_PREFIX}/listServicos.php"),
//     );

//     if (response.statusCode == 200) {
//       for (var x in json.decode(response.body)) {
//         ServicosData servicosData = ServicosData.fromJson(x);
//         servicos.add(servicosData);
//       }
//       servicos.refresh();
//       loading.value = false;
//     } else {
//       Get.snackbar("Get Servicos Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future getHorarios() async {
//     loading.value = true;
//     horarios.clear();

//     final data = await supabase.from('horarios').select();

//     for (var x in data) {
//       HorarioData horarioData = HorarioData.fromJson(x);
//       horarios.add(horarioData);
//     }
//     loading.value = false;
//   }

//   Future getDiasInativos() async {
//     loading.value = true;
//     diasInativos.clear();
//     final response = await http.get(
//       Uri.parse("${Env.URL_PREFIX}/listDiasInativos.php"),
//     );

//     if (response.statusCode == 200) {
//       for (var x in json.decode(response.body)) {
//         DiasInativosData dData = DiasInativosData.fromJson(x);
//         diasInativos.add(dData);
//       }
//       diasInativos.refresh();
//       loading.value = false;
//     } else {
//       Get.snackbar("Get Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future getAgenda() async {
//     loading.value = true;
//     agenda.clear();

//     final response = await http.get(
//       Uri.parse("${Env.URL_PREFIX}/listAgenda.php"),
//     );

//     if (response.statusCode == 200) {
//       for (var x in json.decode(response.body)) {
//         AgendaData agendaData = AgendaData.fromJson(x);
//         agenda.add(agendaData);
//       }
//       agenda.refresh();
//       agenda.sort((a, b) => a.dtAgenda!.compareTo(b.dtAgenda ?? DateTime.now()));
//       loading.value = false;
//     } else {
//       Get.snackbar("Get Servicos Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future createCliente(ClienteData clienteData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/createUser.php"),
//       body: {
//         "nome": clienteData.nome,
//         "telefone": clienteData.telefone,
//       },
//     );

//     if (response.statusCode == 200) {
//       clienteData.id = int.parse(json.decode(response.body));
//       clientes.add(clienteData);
//       loading.value = false;
//       Get.back();
//       Get.snackbar("Cadastrado", "Cliente cadastrado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future createDiasInativos(DiasInativosData dData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/createDiasInativos.php"),
//       body: {
//         "data": dData.data?.toIso8601String(),
//         "obs": dData.obs,
//       },
//     );

//     if (response.statusCode == 200) {
//       dData.id = int.parse(json.decode(response.body));
//       diasInativos.add(dData);
//       loading.value = false;
//       Get.snackbar("Cadastrado", "Dia Inativo cadastrado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future createHorario(AgendaData agendaData) async {
//     loading.value = true;

//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/createHorario.php"),
//       body: {
//         "id_cliente": agendaData.idCliente.toString(),
//         "id_servico": agendaData.idServico.toString(),
//         "dt_agenda": agendaData.dtAgenda?.toIso8601String(),
//       },
//     );

//     if (response.statusCode == 200) {
//       agendaData.id = int.parse(json.decode(response.body));
//       agenda.add(agendaData);
//       loading.value = false;
//       Get.back();
//       Get.snackbar("Cadastrado", "Agendamento efetuado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future createHorarioConf(HorarioData horarioData) async {
//     loading.value = true;

//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/createHorarioConf.php"),
//       body: {
//         "horario": DateTime(
//           1,
//           1,
//           1,
//           horarioData.horario!.hour,
//           horarioData.horario!.minute,
//         ).toIso8601String(),
//       },
//     );

//     if (response.statusCode == 200) {
//       horarioData.idHorario = int.parse(json.decode(response.body));
//       horarios.add(horarioData);
//       horarios.sort(
//           (a, b) => ((a.horario?.hour ?? 0) + (a.horario?.minute ?? 0) / 60.0).compareTo(((b.horario?.hour ?? 0) + (b.horario?.minute ?? 0) / 60.0)));
//       loading.value = false;
//       Get.snackbar("Cadastrado", "Horario cadastrado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future deleteCliente(ClienteData clienteData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/deleteUser.php"),
//       body: {
//         "id": clienteData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       clientes.removeWhere((element) => element.id == clienteData.id);
//       loading.value = false;
//       Get.snackbar("Deletado", "Deletado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future deleteDiasInativos(DiasInativosData dData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/deleteDiasInativos.php"),
//       body: {
//         "id": dData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       diasInativos.removeWhere((element) => element.id == dData.id);
//       loading.value = false;
//       Get.snackbar("Deletado", "Deletado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future deleteHorario(AgendaData agendaData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/deleteHorario.php"),
//       body: {
//         "id_agenda": agendaData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       agenda.removeWhere((element) => element.id == agendaData.id);
//       agenda.refresh();
//       loading.value = false;
//       Get.snackbar("Deletado", "Deletado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future deleteHorarioConf(HorarioData horarioData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/deleteHorarioConf.php"),
//       body: {
//         "id": horarioData.idHorario.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       horarios.removeWhere((element) => element.idHorario == horarioData.idHorario);
//       horarios.refresh();
//       loading.value = false;
//       Get.snackbar("Deletado", "Deletado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future editCliente(ClienteData clienteData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/editUser.php"),
//       body: {
//         "nome": clienteData.nome,
//         "telefone": clienteData.telefone,
//         "id": clienteData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       clientes.where((p0) => p0.id == clienteData.id).forEach((e) => e = clienteData);
//       Get.back();
//       Get.snackbar("Sucesso", "Edição realizada com sucesso!", backgroundColor: Colors.green);

//       loading.value = false;
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future editHorario(AgendaData agendaData) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/editHorario.php"),
//       body: {
//         "dt_agenda": agendaData.dtAgenda?.toIso8601String(),
//         "id_agenda": agendaData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
//       agenda.refresh();

//       loading.value = false;

//       Get.back();
//       Get.snackbar("Sucesso", "Edição realizada com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future editHorarioStatus(AgendaData agendaData, String status) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/editStatusHorario.php"),
//       body: {
//         "status": status,
//         "id_agenda": agendaData.id.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
//       agenda.refresh();

//       loading.value = false;
//       Get.snackbar("Alteração Realizada", "Agendamento alterado com sucesso!", backgroundColor: Colors.green);
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//     }
//   }

//   Future<bool> login(String user, String pass) async {
//     loading.value = true;
//     final response = await http.post(
//       Uri.parse("${Env.URL_PREFIX}/login.php"),
//       body: {
//         "user": user,
//         "pass": pass,
//       },
//     );

//     if (response.statusCode == 200) {
//       if (json.decode(response.body) == "fail") {
//         Get.snackbar("Usuario ou Senhas Incorreto", "Error");
//         loading.value = false;
//         return false;
//       } else {
//         UserData userData = UserData.fromJson(json.decode(response.body)[0]);
//         currentUser.value = userData;
//         currentUserStorage.write("user", jsonEncode(userData.toJson()));
//         loading.value = false;
//         Get.snackbar("Login", "Login realizado com sucesso!", backgroundColor: Colors.green);
//         return true;
//       }
//     } else {
//       Get.snackbar("Erro", "message");
//       loading.value = false;
//       return false;
//     }
//   }

//   loadUser() {
//     if (currentUserStorage.read("user") == null) {
//     } else {
//       currentUser.value = UserData.fromJson(json.decode(currentUserStorage.read("user")));
//     }
//   }

//   logout() {
//     loading.value = true;
//     currentUser.value = null;
//     currentUserStorage.remove("user");
//     Get.snackbar("Logout", "Logout com sucesso!", backgroundColor: Colors.amber);
//     loading.value = false;
//   }

//   loadData() async {
//     await loadUser();
//     await getClientes();
//     await getServicos();
//     await getAgenda();
//     await getHorarios();
//     await getDiasInativos();
//   }
// }
