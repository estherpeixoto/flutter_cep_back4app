class ViaCepModel {
  String? cep;
  String? logradouro;
  String? localidade;
  String? uf;

  ViaCepModel({
    String? cep,
    String? logradouro,
    String? localidade,
    String? uf,
  });

  ViaCepModel.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    logradouro = json['logradouro'];
    localidade = json['localidade'];
    uf = json['uf'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['localidade'] = localidade;
    data['uf'] = uf;

    return data;
  }
}
