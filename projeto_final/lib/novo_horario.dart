import 'package:flutter/material.dart';

class NovoHorario extends StatefulWidget {
  const NovoHorario({super.key});

  @override
  State<NovoHorario> createState() => _NovoHorarioState();
}

class _NovoHorarioState extends State<NovoHorario> {
  var formKey = GlobalKey<FormState>();
  final List<String> diasSemana = [
    "Domingo",
    "Segunda",
    "Terça",
    "Quarta",
    "Quinta",
    "Sexta",
    "Sábado",
  ];
  final List<String> horarios = ["08:00", "09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00", "18:00"];

  String? horarioInicio;
  String? horarioFim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro Horários'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text('Horário Início'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: horarios.map((hora) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: horarioInicio == hora,
                        onChanged: (valor) => setState(() {
                          horarioInicio = valor == true ? hora : null;
                        }),
                      ),
                      Text(hora),
                    ],
                  );
                }).toList(),
              ),
              Text('Horário Fim'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: horarios.map((hora) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: horarioFim == hora,
                        onChanged: (valor) => setState(() {
                          horarioFim = valor == true ? hora : null;
                        }),
                      ),
                      Text(hora),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
