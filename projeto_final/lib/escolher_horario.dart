import 'package:flutter/material.dart';
import 'package:projeto_final/confirmar_atendimento.dart';
import 'package:projeto_final/telaLogin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscolherHorario extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final Map<String, dynamic> servico;
  final Map<String, dynamic> barbeiro;
  const EscolherHorario({super.key, required this.barbeiro, required this.servico, required this.usuario});

  @override
  State<EscolherHorario> createState() => _EscolherHorarioState();
}

class _EscolherHorarioState extends State<EscolherHorario> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaHorarios = [];
  @override
  void initState() {
    super.initState();
    carregarHorarios();
  }

  Future<void> carregarHorarios() async {
    final dados = await supabase
        .from('horarios_funcionario')
        .select('*, dias_semana(id, nome)')
        .eq('funcionario_id', widget.barbeiro['id'])
        .eq('disponivel', true)
        .order('dia_semana', ascending: true);

    List<Map<String, dynamic>> horariosExpandidos = [];

    for (final linha in dados) {
      final inicio = linha['horario_inicio'] as int;
      final fim = linha['horario_fim'] as int;

      for (int hora = inicio; hora < fim; hora++) {
        horariosExpandidos.add({
          ...linha,
          'horario_inicio': hora,
          'horario_fim': hora + 1,
        });
      }
    }

    setState(() {
      listaHorarios = horariosExpandidos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolher Horário'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listaHorarios.length,
              itemBuilder: (context, index) {
                final horario = listaHorarios[index];
                return Card(
                  child: ListTile(
                    title: Text('${horario["dias_semana"]?["nome"] ?? "Não declarado"}'),
                    subtitle: Text(
                      '${horario["horario_inicio"]}:00 - ${horario["horario_inicio"] + 1}:00',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ConfirmarAtendimento(
                              usuario: widget.usuario,
                              horario: horario,
                              barbeiro: widget.barbeiro,
                              servico: widget.servico,
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
