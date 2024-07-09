// ignore: file_names
class DiasInativosData {
  int? id;
  DateTime? data;
  String? obs;

  DiasInativosData({
    this.id,
    this.data,
    this.obs,
  });

  DiasInativosData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    data = DateTime.parse(json['data']);
    obs = json['obs'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id_agenda'] = id;
  //   data['id_cliente'] = idCliente;
  //   data['nome'] = nomeCliente;
  //   data['id_servico'] = idServico;
  //   data['dt_agenda'] = dtAgenda;
  //   data['dt_agenda'] = hrInicio;
  //   data['dt_agenda'] = hrFim;
  //   return data;
  // }
}
