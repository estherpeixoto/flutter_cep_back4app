import 'package:cep_back4app/models/cep_back4app_model.dart';
import 'package:cep_back4app/models/via_cep_model.dart';
import 'package:cep_back4app/repositories/back4app/cep_back4app_repository.dart';
import 'package:cep_back4app/repositories/via_cep_repository.dart';
import 'package:flutter/material.dart';

class CadastrarCep extends StatefulWidget {
  const CadastrarCep({Key? key}) : super(key: key);

  @override
  State<CadastrarCep> createState() => _CadastrarCepState();
}

class _CadastrarCepState extends State<CadastrarCep> {
  bool loading = false;
  var viaCepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  var cepBack4AppRepository = CepBack4AppRepository();
  var cepController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar CEP'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
        actions: [
          TextButton(
            onPressed: () async {
              // Validar se o CEP existe
              if (viaCepModel.cep == null) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('CEP inexistente'),
                      action: SnackBarAction(
                        label: 'Tentar novamente',
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              } else {
                var result = await cepBack4AppRepository.findCep(viaCepModel);

                if (result.objectId != '') {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('CEP já está cadastrado'),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                } else {
                  // @done Gravar o CEP no Back4App
                  await cepBack4AppRepository.create(CepBack4AppModel.create(
                    viaCepModel.cep ?? '',
                    viaCepModel.logradouro ?? '',
                    viaCepModel.localidade ?? '',
                    viaCepModel.uf ?? '',
                  ));

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              }
            },
            child: const Text('Cadastrar'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(label: Text('Procurar por CEP')),
              onChanged: (String value) async {
                var cep = value.replaceAll(RegExp(r'[^0-9]'), '');

                if (cep.length == 8) {
                  setState(() {
                    loading = true;
                  });

                  viaCepModel = await viaCepRepository.findCep(cep);
                }

                setState(() {
                  loading = false;
                });
              },
            ),
            const SizedBox(height: 32),
            const Text('Resultado:', style: TextStyle(fontSize: 14)),
            Text(
              viaCepModel.logradouro ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '${viaCepModel.localidade ?? ''} - ${viaCepModel.uf ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            if (loading) const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
