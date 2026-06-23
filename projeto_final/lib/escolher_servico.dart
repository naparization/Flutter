import 'package:flutter/material.dart';

class EscolherServico extends StatefulWidget {
  const EscolherServico({super.key});

  @override
  State<EscolherServico> createState() => _EscolherServicoState();
}

class _EscolherServicoState extends State<EscolherServico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione o Serviço:'),
      ),
    );
  }
}
