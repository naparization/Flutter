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

  String nomeDia(int dia) {
    switch (dia) {
      case 2:
        return 'Segunda-feira';
      case 3:
        return 'Terça-feira';
      case 4:
        return 'Quarta-feira';
      case 5:
        return 'Quinta-feira';
      case 6:
        return 'Sexta-feira';
      case 7:
        return 'Sábado';
      case 8:
        return 'Domingo';
      default:
        return 'Dia inválido';
    }
  }

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

  Future<void> excluirHorario(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir horário'),
        content: const Text(
          'Tem certeza que deseja excluir este horário?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await supabase
        .from('horarios_funcionario')
        .delete()
        .eq('id', id);

    await carregarHorarios();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Horário excluído com sucesso!'),
      ),
    );
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                          nomeDia(h['dia_semana']),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${h['horario_inicio']}:00 - ${h['horario_fim']}:00",
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            excluirHorario(h['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NovoHorario(
                usuario: widget.usuario,
              ),
            ),
          );

          setState(() {
            loading = true;
          });

          carregarHorarios();
        },
      ),
    );
  }
}