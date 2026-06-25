import 'package:flutter/material.dart';
import 'package:projeto_final/escolher_barbeiro.dart';
import 'package:projeto_final/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscolherServico extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const EscolherServico({super.key, required this.usuario});

  @override
  State<EscolherServico> createState() => _EscolherServicoState();
}

class _EscolherServicoState extends State<EscolherServico> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaServicos = [];
  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<void> carregarServicos() async {
    final dados = await supabase.from('servicos').select('*');
    setState(() {
      listaServicos = List<Map<String, dynamic>>.from(dados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o Serviço:'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listaServicos.length,
              itemBuilder: (context, index) {
                final servico = listaServicos[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      servico["nome"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(servico["descricao"]),
                    trailing: Text(
                      'R\$ ${servico["valor"]}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return EscolherBarbeiro(
                              usuario: widget.usuario,
                              servico: servico,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
