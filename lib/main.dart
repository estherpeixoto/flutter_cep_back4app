import 'package:cep_back4app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
 * @done Criar uma aplicação Flutter
 * @done Criar uma classe de CEP no Back4App
 * @done Consulte um Cep no ViaCep, após retornado se não existir no Back4App, realizar o cadastro
 * @done Listar os CEPs cadastrados em forma de lista, possibilitando a alteração e exclusão do CEP
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}
