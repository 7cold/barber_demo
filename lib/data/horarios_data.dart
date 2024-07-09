import 'package:flutter/material.dart';

class HorarioData {
  int? idHorario;
  TimeOfDay? horario;

  HorarioData({this.idHorario, this.horario});

  HorarioData.fromJson(Map<String, dynamic> json) {
    idHorario = json['id_horario'] ?? 0;
    horario = TimeOfDay(
      hour: int.parse(json['horario'].toString().substring(0, 2)),
      minute: int.parse(json['horario'].toString().substring(3, 5)),
    );
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
