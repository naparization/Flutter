import 'package:flutter/material.dart';
import 'package:projeto_final/escolher_horario.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscolherBarbeiro extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final Map<String, dynamic> servico;
  const EscolherBarbeiro({super.key, required this.usuario, required this.servico});

  @override
  State<EscolherBarbeiro> createState() => _EscolherBarbeiroState();
}

class _EscolherBarbeiroState extends State<EscolherBarbeiro> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaBarbeiros = [];

  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<void> carregarServicos() async {
    final dados = await supabase.from('usuarios').select('*').eq('is_adm', true).eq('inativo', false);
    setState(() {
      listaBarbeiros = List<Map<String, dynamic>>.from(dados);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolher Barbeiro'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listaBarbeiros.length,
              itemBuilder: (context, index) {
                final barbeiro = listaBarbeiros[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      barbeiro["nome"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return EscolherHorario(
                              usuario: widget.usuario,
                              servico: widget.servico,
                              barbeiro: barbeiro,
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
