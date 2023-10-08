import 'package:cep_back4app/models/cep_back4app_model.dart';
import 'package:cep_back4app/pages/cadastrar_cep.dart';
import 'package:cep_back4app/pages/editar_cep.dart';
import 'package:cep_back4app/repositories/back4app/cep_back4app_repository.dart';
import 'package:flutter/material.dart';

class ListarCep extends StatefulWidget {
  const ListarCep({Key? key}) : super(key: key);

  @override
  State<ListarCep> createState() => _ListarCepState();
}

class _ListarCepState extends State<ListarCep> {
  var loading = false;
  var cepBack4AppRepository = CepBack4AppRepository();
  var _cepsBack4AppModel = CepsBack4AppModel([]);

  @override
  void initState() {
    super.initState();
    fetchCeps();
  }

  void fetchCeps() async {
    setState(() {
      loading = true;
    });

    _cepsBack4AppModel = await cepBack4AppRepository.getCeps();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de CEP'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastrarCep()),
          );

          fetchCeps();
        },
        label: const Text('Cadastrar'),
        icon: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            loading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _cepsBack4AppModel.ceps.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var cep = _cepsBack4AppModel.ceps[index];

                        return Dismissible(
                          onDismissed:
                              (DismissDirection dismissDirection) async {
                            // @done Deletar CEP do Back4App
                            await cepBack4AppRepository.delete(cep.objectId);

                            fetchCeps();
                          },
                          key: Key(cep.cep),
                          child: ListTile(
                              title: Text(
                                '${cep.logradouro}, ${cep.localidade} - ${cep.uf}',
                              ),
                              subtitle: Text(cep.cep),
                              trailing: IconButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarCep(cep)),
                                  );

                                  fetchCeps();
                                },
                                icon: const Icon(Icons.edit),
                              )),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
