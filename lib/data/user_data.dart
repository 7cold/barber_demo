class UserData {
  int? id;
  String? user;
  String? pass;
  String? nivel;

  UserData({
    this.id,
    this.user,
    this.pass,
    this.nivel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'pass': pass,
        'nivel': nivel,
      };

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = json['user'];
    pass = json['pass'];
    nivel = json['nivel'];
  }
}
