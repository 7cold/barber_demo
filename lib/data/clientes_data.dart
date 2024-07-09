class ClienteData {
  int? id;
  String? nome;
  String? telefone;

  ClienteData({this.id, this.nome, this.telefone});

  ClienteData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    nome = json['nome'];
    telefone = json['telefone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['telefone'] = telefone;
    return data;
  }
}
