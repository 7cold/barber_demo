import 'package:barbearia/data/clientes_data.dart';
import 'package:barbearia/data/agenda_data.dart';
import 'package:barbearia/data/diasInativos_data.dart';
import 'package:barbearia/data/horarios_data.dart';
import 'package:barbearia/data/servicos_data.dart';
import 'package:barbearia/data/user_data.dart';
import 'package:barbearia/ui/login.dart';
import 'package:barbearia/ui/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class Controller extends GetxController {
  @override
  onInit() async {
    box.value.read("theme") == true
        ? Get.changeThemeMode(ThemeMode.dark)
        : box.value.read("theme") == null
            ? Get.changeThemeMode(ThemeMode.light)
            : Get.changeThemeMode(ThemeMode.light);

    loadData();

    super.onInit();
  }

  SupabaseClient supabase = Supabase.instance.client;
  Rxn<UserData> currentUser = Rxn<UserData>();
  RxList<ClienteData> clientes = <ClienteData>[].obs;
  RxList<UserData> users = <UserData>[].obs;
  RxList<ServicosData> servicos = <ServicosData>[].obs;
  RxList<HorarioData> horarios = <HorarioData>[].obs;
  RxList<AgendaData> agenda = <AgendaData>[].obs;
  RxList<DiasInativosData> diasInativos = <DiasInativosData>[].obs;

  Rx<GetStorage> box = GetStorage().obs;

  RxString searchController = "".obs;

  RxBool modoEscuro = false.obs;
  RxInt dayInit = 7.obs;

  Rx<DateTime> dataSelect = DateTime.now().obs;

  RxBool loading = false.obs;

  DateFormat dateFormatterSimple = DateFormat('dd/MM/yyyy', 'pt_br');
  DateFormat dateFormatterDiaSemana = DateFormat('EEEE', 'pt_br');
  DateFormat dateFormatterHora = DateFormat('HH:mm', 'pt_br');

  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatterReal = MaskTextInputFormatter(
    mask: '',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  NumberFormat real = NumberFormat("#,##0.00", "pt_BR");

  Future getClientes() async {
    loading.value = true;
    clientes.clear();
    final data = await supabase.from('clientes').select();

    for (var x in data) {
      ClienteData clienteData = ClienteData.fromJson(x);
      clientes.add(clienteData);
    }
    clientes.refresh();
    clientes.sort((a, b) => a.nome!.compareTo(b.nome ?? ""));
    loading.value = false;
  }

  Future getUser() async {
    loading.value = true;
    users.clear();
    final data = await supabase.from('usuarios').select();
    for (var x in data) {
      UserData userData = UserData.fromJson(x);
      users.add(userData);
    }
    loading.value = false;
  }

  Future getServicos() async {
    loading.value = true;
    servicos.clear();
    final data = await supabase.from('servicos').select();
    for (var x in data) {
      ServicosData servicosData = ServicosData.fromJson(x);
      servicos.add(servicosData);
    }
    loading.value = false;
  }

  Future getHorarios() async {
    loading.value = true;
    horarios.clear();
    final data = await supabase.from('horarios').select();
    for (var x in data) {
      HorarioData horarioData = HorarioData.fromJson(x);
      horarios.add(horarioData);
    }
    loading.value = false;
  }

  Future getDiasInativos() async {
    loading.value = true;
    diasInativos.clear();
    final data = await supabase.from('diasInativos').select();
    for (var x in data) {
      DiasInativosData diasInativosData = DiasInativosData.fromJson(x);
      diasInativos.add(diasInativosData);
    }
    loading.value = false;
  }

  Future getAgenda() async {
    loading.value = true;
    agenda.clear();
    final data = await supabase.from('agenda').select('*, servicos(*), clientes(*)');
    for (var x in data) {
      AgendaData agendaData = AgendaData.fromJson(x);
      agenda.add(agendaData);
    }
    loading.value = false;
  }

  Future createCliente(ClienteData clienteData) async {
    loading.value = true;
    var data = await supabase.from('clientes').insert({
      "nome": clienteData.nome,
      "telefone": clienteData.telefone,
    }).select();
    clienteData.id = data[0]['id'];
    clientes.add(clienteData);
    clientes.sort((a, b) => a.nome!.compareTo(b.nome ?? ""));
    loading.value = false;
    Get.back();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createServico(ServicosData servicosData, String cor) async {
    loading.value = true;
    await supabase.from('servicos').insert({
      'ser_nome': servicosData.nome,
      'ser_cor': "0xff$cor",
      'ser_valor': servicosData.valor,
      'ser_tempo': servicosData.tempo,
      'ser_qtd': servicosData.qtd,
      'ativo': true,
    }).select();
    await getServicos();
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createDiasInativos(DiasInativosData dData) async {
    loading.value = true;
    var data = await supabase.from('diasInativos').insert({
      "data": dData.data?.toIso8601String(),
      "obs": dData.obs,
    }).select();
    dData.id = data[0]['id'];
    diasInativos.add(dData);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createServicos(ServicosData servicosData) async {
    loading.value = true;
    var data = await supabase.from('servicos').insert({
      "ser_nome": servicosData.nome,
      "ser_valor": servicosData.valor,
      "ser_tempo": servicosData.tempo,
      "ser_qtd": servicosData.qtd,
      "ser_cor": servicosData.corServico,
    }).select();
    servicosData.id = data[0]['id'];
    servicos.add(servicosData);
    loading.value = false;

    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createHorario(AgendaData agendaData) async {
    loading.value = true;
    var data = await supabase.from('agenda').insert({
      "obs_pacote": agendaData.obsPacote,
      "id_cliente": agendaData.idCliente.toString(),
      "id_servico": agendaData.idServico.toString(),
      "valor_servico": agendaData.valorServico,
      "dt_agenda": agendaData.dtAgenda?.toIso8601String(),
    }).select();
    agendaData.id = data[0]['id'];
    agenda.add(agendaData);
    loading.value = false;
    Get.back();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future createHorarioConf(HorarioData horarioData) async {
    loading.value = true;
    var data = await supabase.from('horarios').insert({
      "horario": dateFormatterHora.format(DateTime(
        2024,
        1,
        1,
        horarioData.horario!.hour,
        horarioData.horario!.minute,
      )),
    }).select();
    horarioData.idHorario = data[0]['id_horario'];
    horarios.add(horarioData);
    loading.value = false;
    horarios.sort(
        (a, b) => ((a.horario?.hour ?? 0) + (a.horario?.minute ?? 0) / 60.0).compareTo(((b.horario?.hour ?? 0) + (b.horario?.minute ?? 0) / 60.0)));
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Cadastrado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future deleteCliente(ClienteData clienteData) async {
    loading.value = true;
    await supabase.from('clientes').delete().eq('id', clienteData.id ?? 0);
    clientes.removeWhere((element) => element.id == clienteData.id);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future deleteServico(ServicosData servicosData) async {
    loading.value = true;
    try {
      await supabase.from('servicos').delete().eq('id', servicosData.id ?? 0);
      servicos.removeWhere((element) => element.id == servicosData.id);
      toastification.show(
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        context: Get.context, // optional if you use ToastificationWrapper
        title: const Text("Deletado com sucesso!"),
        autoCloseDuration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar("Error", "Não é possível deletar este serviços, pois, tem registros com relação entre serviços e clientes.",
          backgroundColor: Colors.amber);
    }

    loading.value = false;
  }

  Future deleteDiasInativos(DiasInativosData dData) async {
    loading.value = true;
    await supabase.from('diasInativos').delete().eq('id', dData.id ?? 0);
    diasInativos.removeWhere((element) => element.id == dData.id);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future deleteHorario(AgendaData agendaData) async {
    loading.value = true;
    await supabase.from('agenda').delete().eq('id_agenda', agendaData.id ?? 0);
    agenda.removeWhere((element) => element.id == agendaData.id);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future deleteHorarioConf(HorarioData horarioData) async {
    loading.value = true;
    await supabase.from('horarios').delete().eq('id_horario', horarioData.idHorario ?? 0);
    horarios.removeWhere((element) => element.idHorario == horarioData.idHorario);
    loading.value = false;
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Deletado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  Future editCliente(ClienteData clienteData) async {
    loading.value = true;
    await supabase.from('clientes').update({
      "nome": clienteData.nome,
      "telefone": clienteData.telefone,
    }).eq('id', clienteData.id ?? 0);
    clientes.where((p0) => p0.id == clienteData.id).forEach((e) => e = clienteData);
    Get.back();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Alterado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
  }

  Future editHorario(AgendaData agendaData) async {
    loading.value = true;
    await supabase.from('agenda').update({
      "dt_agenda": agendaData.dtAgenda?.toIso8601String(),
    }).eq('id_agenda', agendaData.id ?? 0);
    agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
    Get.back();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Alterado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
    agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
    agenda.refresh();
    loading.value = false;
  }

  Future editHorarioStatus(AgendaData agendaData, String status) async {
    loading.value = true;
    await supabase.from('agenda').update({
      "status": status,
    }).eq('id_agenda', agendaData.id ?? 0);
    agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Alterado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    loading.value = false;
    agenda.where((p0) => p0.id == agendaData.id).forEach((e) => e = agendaData);
    agenda.refresh();
    loading.value = false;
  }

  login(String userx, String pass) async {
    try {
      await supabase.auth.signInWithPassword(
        email: userx,
        password: pass,
      );

      Get.offAll(const Root());
    } on AuthException catch (e) {
      if (e.statusCode == "400") Get.snackbar("Error", "E-mail ou Senhas Icorretos!", backgroundColor: Colors.amber);
    }
  }

  logout() async {
    loading.value = true;
    await supabase.auth.signOut();
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      context: Get.context, // optional if you use ToastificationWrapper
      title: const Text("Logout efetuado com sucesso!"),
      autoCloseDuration: const Duration(seconds: 5),
    );
    Get.offAll(const Login());
    loading.value = false;
  }

  loadData() async {
    await getClientes();
    await getServicos();
    await getAgenda();
    await getHorarios();
    await getDiasInativos();
  }
}
