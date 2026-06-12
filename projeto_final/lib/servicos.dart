import 'package:flutter/material.dart';
import 'package:projeto_final/home.dart';
import 'package:projeto_final/novo_servico.dart';

class Servicos extends StatefulWidget {
  const Servicos({super.key});

  @override
  State<Servicos> createState() => _ServicosState();
}

class _ServicosState extends State<Servicos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        title: Text('Serviços'),
        centerTitle: true,
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NovoServico();
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
