import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NovoServico extends StatefulWidget {
  const NovoServico({super.key});

  @override
  State<NovoServico> createState() => _NovoServicoState();
}

class _NovoServicoState extends State<NovoServico> {
  var formKey = GlobalKey<FormState>();
  var nomeController = TextEditingController();
  var valorController = TextEditingController();
  var descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor de Serviço'),
        backgroundColor: Color.fromARGB(255, 255, 162, 40),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              TextFormField(
                controller: nomeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nome Completo",
                  hintText: 'Teste',
                ),
              ),
              TextFormField(
                controller: valorController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Valor (R\$)",
                  hintText: '0,00',
                ),
              ),
              TextFormField(
                controller: descricaoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Descrição",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final supabase = Supabase.instance.client;
                      String valor = valorController.text;
                      valor = valor.replaceAll(',', '.');
                      await supabase.from('servicos').insert({
                        'nome': nomeController.text,
                        'valor': valor,
                        'descricao': descricaoController.text,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Serviço registrado."),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Falha ao criar serviço."),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
