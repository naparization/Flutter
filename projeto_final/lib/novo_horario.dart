

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NovoHorario extends StatefulWidget {
  const NovoHorario({super.key});

  @override
  State<NovoHorario> createState() => _NovoHorarioState();
}

class _NovoHorarioState extends State<NovoHorario> {
  var formKey = GlobalKey<FormState>();
  final List<String> horarios = ["08:00", "09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00", "18:00"];

  String? horarioInicio;
  String? horarioFim;

  List<Map<String, dynamic>> diasSemana = [];
  int? diaSemanaId; // Armazena o ID selecionado

  @override
  void initState() {
    super.initState();
    _carregarDiasSemana();
  }

  Future<void> _carregarDiasSemana() async {
    final response = await Supabase.instance.client.from('dias_semana').select('id, nome').order('id');

    setState(() {
      diasSemana = List<Map<String, dynamic>>.from(response);
    });
  }

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
              Text('Dia da Semana'),
              diasSemana.isEmpty
                  ? CircularProgressIndicator()
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: diasSemana.map((dia) {
                        final int id = dia['id'];
                        final String nome = dia['nome'];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: diaSemanaId == id,
                              onChanged: (valor) => setState(() {
                                diaSemanaId = valor == true ? id : null;
                              }),
                            ),
                            Text(nome),
                          ],
                        );
                      }).toList(),
                    ),
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
              ElevatedButton(
                onPressed: () async {
                  // 1. Valida o formulário e os campos obrigatórios antes de qualquer coisa
                  if (!(formKey.currentState!.validate())) return;

                  if (diaSemanaId == null || horarioInicio == null || horarioFim == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Selecione dia da semana, horário início e fim"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final supabase = Supabase.instance.client;

                  // 2. Verifica se já existe horário cadastrado nesse dia para esse funcionário
                  final horarioEmUso = await supabase.from("horarios_funcionario").select().eq("dia_semana", diaSemanaId!).eq("funcionario_id", 1);

                  if (horarioEmUso.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Você já tem um horário cadastrado nesse dia"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // 3. Só chega aqui se passou nas duas validações
                  try {
                    await supabase.from('horarios_funcionario').insert({
                      'horario_inicio': horarioInicio,
                      'horario_fim': horarioFim,
                      'dia_semana': diaSemanaId,
                      'funcionario_id': 1,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cadastro realizado com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  } on PostgrestException catch (e) {
                    if (e.code == "23505") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Login já está em uso"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Falha ao realizar cadastro"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text("Cadastrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
