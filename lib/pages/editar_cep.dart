import 'package:cep_back4app/models/cep_back4app_model.dart';
import 'package:cep_back4app/models/via_cep_model.dart';
import 'package:cep_back4app/repositories/back4app/cep_back4app_repository.dart';
import 'package:cep_back4app/repositories/via_cep_repository.dart';
import 'package:flutter/material.dart';

class EditarCep extends StatefulWidget {
  const EditarCep(this.cepBack4AppModel, {Key? key}) : super(key: key);

  final CepBack4AppModel cepBack4AppModel;

  @override
  State<EditarCep> createState() => _EditarCepState();
}

class _EditarCepState extends State<EditarCep> {
  bool loading = false;
  var viaCepModel = ViaCepModel();
  var viaCepRepository = ViaCepRepository();
  var cepBack4AppRepository = CepBack4AppRepository();
  var idController = TextEditingController(text: '');
  var cepController = TextEditingController(text: '');
  var logradouroController = TextEditingController(text: '');
  var localidadeController = TextEditingController(text: '');
  var ufController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    idController.text = widget.cepBack4AppModel.objectId;
    cepController.text = widget.cepBack4AppModel.cep;

    searchCEP(cepController.text);
  }

  void searchCEP(String value) async {
    var cep = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (cep.length == 8) {
      setState(() {
        loading = true;
      });

      viaCepModel = await viaCepRepository.findCep(cep);

      logradouroController.text = viaCepModel.logradouro ?? '';
      localidadeController.text = viaCepModel.localidade ?? '';
      ufController.text = viaCepModel.uf ?? '';
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar CEP'),
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
                // @done Editar o CEP no Back4App
                await cepBack4AppRepository.update(CepBack4AppModel(
                  idController.text,
                  viaCepModel.cep ?? '',
                  viaCepModel.logradouro ?? '',
                  viaCepModel.localidade ?? '',
                  viaCepModel.uf ?? '',
                  widget.cepBack4AppModel.createdAt,
                  widget.cepBack4AppModel.updatedAt,
                ));

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Editar'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(label: Text('ID')),
              enabled: false,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: cepController,
              decoration: const InputDecoration(label: Text('CEP')),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                searchCEP(value);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: logradouroController,
              decoration: const InputDecoration(label: Text('Logradouro')),
              enabled: false,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: localidadeController,
              decoration: const InputDecoration(label: Text('Localidade')),
              enabled: false,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: ufController,
              decoration: const InputDecoration(label: Text('UF')),
              enabled: false,
            ),
            const SizedBox(height: 16),
            if (loading) const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
