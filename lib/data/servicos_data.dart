class ServicosData {
  int? id;
  String? nome;
  int? corServico;
  bool? ativo;
  num? valor;
  int? tempo;
  int? qtd;

  ServicosData({
    this.id,
    this.nome,
    this.valor,
    this.tempo,
    this.qtd,
    this.corServico,
    this.ativo,
  });

  ServicosData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    nome = json['ser_nome'];
    corServico = int.parse(json['ser_cor']);
    valor = json['ser_valor'];
    tempo = json['ser_tempo'];
    qtd = json['ser_qtd'];
    ativo = json['ativo'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['ser_nome'] = nome;
  //   data['ser_valor'] = valor;
  //   data['ser_tempo'] = tempo;
  //   return data;
  // }
}
