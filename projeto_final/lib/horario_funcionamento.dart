import 'package:flutter/material.dart';
import 'package:projeto_final/home.dart';
import 'package:projeto_final/novo_horario.dart';

class HorarioFuncionamento extends StatefulWidget {
  const HorarioFuncionamento({super.key});

  @override
  State<HorarioFuncionamento> createState() => _HorarioFuncionamentoState();
}

class _HorarioFuncionamentoState extends State<HorarioFuncionamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horários de Funcionamento'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [Text('Nada por enquanto. (PLACEHOLDER)')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NovoHorario();
              },
            ),
          );
        },
        tooltip: 'Novo Serviço',
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 139, 89, 22),
        ),
      ),
    );
  }
}
