import 'package:flutter/material.dart';

class NovoServico extends StatefulWidget {
  const NovoServico({super.key});

  @override
  State<NovoServico> createState() => _NovoServicoState();
}

class _NovoServicoState extends State<NovoServico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor de Serviço'),
        backgroundColor: Color.fromARGB(255, 255, 162, 40),
      ),
      body: Center(
        child: Form(child: ),
      ),
    );
  }
}
