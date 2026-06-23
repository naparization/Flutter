import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NovoServico extends StatefulWidget {
  final Map<String, dynamic>? servico;

  const NovoServico({super.key, this.servico});

  @override
  State<NovoServico> createState() => _NovoServicoState();
}

class _NovoServicoState extends State<NovoServico> {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final valorController = TextEditingController();
  final descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.servico != null) {
      nomeController.text = widget.servico!['nome'];
      valorController.text = widget.servico!['valor'].toString();
      descricaoController.text = widget.servico!['descricao'];
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    valorController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        title: Text(
          widget.servico == null ? "Novo Serviço" : "Editar Serviço",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o nome";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valor",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe o valor";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Informe a descrição";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    try {
                      String valor = valorController.text.replaceAll(',', '.');

                      if (widget.servico == null) {
                        await supabase.from('servicos').insert({
                          'nome': nomeController.text,
                          'valor': valor,
                          'descricao': descricaoController.text,
                        });
                      } else {
                        await supabase
                            .from('servicos')
                            .update({
                              'nome': nomeController.text,
                              'valor': valor,
                              'descricao': descricaoController.text,
                            })
                            .eq('id', widget.servico!['id']);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  child: Text(
                    widget.servico == null ? "Cadastrar" : "Salvar Alterações",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
