import 'package:flutter/material.dart';
import 'package:projeto_final/telaCadastro.dart';

class ConfirmarAtendimento extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final Map<String, dynamic> servico;
  final Map<String, dynamic> barbeiro;
  final Map<String, dynamic> horario;
  const ConfirmarAtendimento({super.key, required this.barbeiro, required this.horario, required this.servico, required this.usuario});

  @override
  State<ConfirmarAtendimento> createState() => _ConfirmarAtendimentoState();
}

class _ConfirmarAtendimentoState extends State<ConfirmarAtendimento> {
  @override
  Widget build(BuildContext context) {
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
                'Horário:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${widget.horario['horario_inicio']} - ${widget.horario['horario_fim']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Confirmar')),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
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
