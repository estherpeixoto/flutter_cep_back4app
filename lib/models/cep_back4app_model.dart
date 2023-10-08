class CepsBack4AppModel {
  List<CepBack4AppModel> ceps = [];

  CepsBack4AppModel(this.ceps);

  CepsBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      ceps = <CepBack4AppModel>[];

      json['results'].forEach((v) {
        ceps.add(CepBack4AppModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = ceps.map((v) => v.toJson()).toList();
    return data;
  }
}

class CepBack4AppModel {
  String objectId = '';
  String cep = '';
  String logradouro = '';
  String localidade = '';
  String uf = '';
  String createdAt = '';
  String updatedAt = '';

  CepBack4AppModel(
    this.objectId,
    this.cep,
    this.logradouro,
    this.localidade,
    this.uf,
    this.createdAt,
    this.updatedAt,
  );

  CepBack4AppModel.create(this.cep, this.logradouro, this.localidade, this.uf);

  CepBack4AppModel.empty();

  CepBack4AppModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    localidade = json['localidade'];
    uf = json['uf'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['objectId'] = objectId;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['localidade'] = localidade;
    data['uf'] = uf;

    return data;
  }
}
