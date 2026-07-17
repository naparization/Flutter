import 'package:flutter/material.dart';
import 'package:projeto_final/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaDeCadastro extends StatefulWidget {
  const TelaDeCadastro({super.key});

  @override
  State<TelaDeCadastro> createState() => _TelaDeCadastroState();
}

class _TelaDeCadastroState extends State<TelaDeCadastro> {
  var cpfController = TextEditingController();
  var senhaController = TextEditingController();
  var nomeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Cadastro'),
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Center(
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
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nome Completo",
                    ),
                  ),
                  TextFormField(
                    controller: cpfController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      } else {
                        value = value.replaceAll("-", "");
                        value = value.replaceAll(".", "");
                        if (value.length > 11 || value.length < 11) {
                          return 'CPF Inválido.';
                        }
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "CPF",
                    ),
                  ),
                  TextFormField(
                    controller: senhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório.';
                      } else if (value.length < 5) {
                        return 'A senha precisa ter pelo menos 5 caractéres.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Senha",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          final supabase = Supabase.instance.client;
                          String valor = cpfController.text;
                          valor = valor.replaceAll("-", "");
                          valor = valor.replaceAll(".", "");
                          await supabase.from('usuarios').insert({
                            'nome': nomeController.text,
                            'cpf': valor,
                            'senha': Utils.gerarMd5(senhaController.text),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Cadastro realizado com sucesso!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        } on PostgrestException catch (e) {
                          if (e.code != null && e.code == "23505") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login já está em uso"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Falha ao realizar cadastro"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Cadastrar"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
