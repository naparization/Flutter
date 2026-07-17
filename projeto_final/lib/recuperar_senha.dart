import 'package:flutter/material.dart';
import 'package:projeto_final/home.dart';
import 'package:projeto_final/home_adm.dart';
import 'package:projeto_final/telaCadastro.dart';
import 'package:projeto_final/telaLogin.dart';
import 'package:projeto_final/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  var CPFController = TextEditingController();
  var senhaController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20),
        title: Text('Recuperar Senha'),
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
                    controller: CPFController,
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
                        final supabase = Supabase.instance.client;
                        final usuarios = await supabase.from("usuarios").select().eq("cpf", CPFController.text);
                        if (usuarios.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Credenciais inválidas"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          final senha = Utils.gerarMd5(senhaController.text);
                          await supabase.from('usuarios').update({'senha': senha}).eq('cpf', CPFController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Senha alterada com sucesso."),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return TelaDeLogin();
                              },
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Atualizar"),
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
