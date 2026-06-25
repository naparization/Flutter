import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'novo_horario.dart';

class HorarioFuncionamento extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const HorarioFuncionamento({
    super.key,
    required this.usuario,
  });

  @override
  State<HorarioFuncionamento> createState() =>
      _HorarioFuncionamentoState();
}

class _HorarioFuncionamentoState extends State<HorarioFuncionamento> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> horarios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    carregarHorarios();
  }

  Future<void> carregarHorarios() async {
    final int funcionarioId = widget.usuario['id'];

    final data = await supabase
        .from('horarios_funcionario')
        .select()
        .eq('funcionario_id', funcionarioId)
        .order('dia_semana');

    setState(() {
      horarios = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horários de Funcionamento'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : horarios.isEmpty
              ? const Center(
                  child: Text("Nenhum horário cadastrado"),
                )
              : ListView.builder(
                  itemCount: horarios.length,
                  itemBuilder: (context, index) {
                    final h = horarios[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(
                          "Dia: ${h['dia_semana']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${h['horario_inicio']} - ${h['horario_fim']}",
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NovoHorario(),
            ),
          );

          setState(() {
            loading = true;
          });

          carregarHorarios();
        },
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        child: const Icon(Icons.add),
      ),
    );
  }
}