import 'package:cep_back4app/models/cep_back4app_model.dart';
import 'package:cep_back4app/models/via_cep_model.dart';
import 'package:cep_back4app/repositories/back4app/back4app_dio_custom.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CepBack4AppRepository {
  final _customDio = Back4AppCustomDio();

  CepBack4AppRepository();

  Future<CepBack4AppModel> findCep(ViaCepModel viaCepModel) async {
    var result = await _customDio.dio.get(
      '/cep',
      options: Options(contentType: Headers.formUrlEncodedContentType),
      queryParameters: {
        'where': {
          'cep': viaCepModel.cep,
          'logradouro': viaCepModel.logradouro,
          'localidade': viaCepModel.localidade,
          'uf': viaCepModel.uf,
        }
      },
    );

    if (result.data['results'].asMap().containsKey(0)) {
      return CepBack4AppModel.fromJson(result.data['results'][0]);
    }

    return CepBack4AppModel.empty();
  }

  Future<CepsBack4AppModel> getCeps() async {
    var result = await _customDio.dio.get('/cep');
    return CepsBack4AppModel.fromJson(result.data);
  }

  Future<void> create(CepBack4AppModel cepBack4AppModel) async {
    debugPrint(cepBack4AppModel.toString());

    try {
      await _customDio.dio.post(
        '/cep',
        data: cepBack4AppModel.toJsonEndpoint(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(CepBack4AppModel cepBack4AppModel) async {
    try {
      var response = await _customDio.dio.put(
        '/cep/${cepBack4AppModel.objectId}',
        data: cepBack4AppModel.toJsonEndpoint(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String objectId) async {
    try {
      var response = await _customDio.dio.delete('/cep/$objectId');
    } catch (e) {
      rethrow;
    }
  }
}
