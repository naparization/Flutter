import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final/home.dart';
import 'package:projeto_final/telaCadastro.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmarAtendimento extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final Map<String, dynamic> servico;
  final Map<String, dynamic> barbeiro;
  final Map<String, dynamic> horario;
  final DateTime diaDoMes;
  const ConfirmarAtendimento({
    super.key,
    required this.barbeiro,
    required this.horario,
    required this.servico,
    required this.usuario,
    required this.diaDoMes,
  });

  @override
  State<ConfirmarAtendimento> createState() => _ConfirmarAtendimentoState();
}

class _ConfirmarAtendimentoState extends State<ConfirmarAtendimento> {
  @override
  Widget build(BuildContext context) {
    final dataFormatada = DateFormat('yyyy-MM-dd').format(widget.diaDoMes);
    final dataExibicao = DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(widget.diaDoMes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmar Informações'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Barbeiro:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.barbeiro['nome'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'Serviço:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.servico['nome'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'Data e Horário:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '$dataExibicao | ${widget.horario['horario_inicio']}:00 - ${widget.horario['horario_fim']}:00',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final supabase = Supabase.instance.client;

              final horarioEmUso = await supabase
                  .from('atendimento')
                  .select('id')
                  .eq('id_barbeiro', widget.barbeiro['id'])
                  .eq('dia_do_mes', dataFormatada)
                  .gte('horario_inicio', widget.horario['horario_inicio'])
                  .lte('horario_fim', widget.horario['horario_fim'])
                  .eq('finalizado', false);

              if (horarioEmUso.isEmpty) {
                await supabase.from('atendimento').insert({
                  'id_usuario': widget.usuario['id'],
                  'id_barbeiro': widget.barbeiro['id'],
                  'id_servico': widget.servico['id'],
                  'id_dia_semana': widget.horario["dias_semana"]["id"],
                  'horario_inicio': widget.horario['horario_inicio'],
                  'horario_fim': widget.horario['horario_fim'],
                  'dia_do_mes': dataFormatada,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Cadastro realizado com sucesso!"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return Home(usuario: widget.usuario);
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Horário já marcado."),
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                  ),
                );
              }
            },
            child: Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return TelaDeCadastro();
                  },
                ),
              );
            },
            child: Text("Cancelar"),
          ),
        ],
      ),
    );
  }
}
