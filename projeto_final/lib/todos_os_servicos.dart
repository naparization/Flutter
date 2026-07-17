import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodosOsServicos extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const TodosOsServicos({
    super.key,
    required this.usuario,
  });

  @override
  State<TodosOsServicos> createState() => _TodosOsServicosState();
}

class _TodosOsServicosState extends State<TodosOsServicos> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaAtendimentos = [];
  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<void> carregarServicos() async {
    final dados = await supabase
        .from('atendimento')
        .select('*, barbeiro:usuarios!atendimento_id_barbeiro_fkey(*), servicos(nome, valor), dias_semana(nome)')
        .eq('id_usuario', widget.usuario['id'])
        .eq('finalizado', false);

    setState(() {
      listaAtendimentos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('King Barbearia'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(60.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listaAtendimentos.length,
                itemBuilder: (context, index) {
                  final horario = listaAtendimentos[index];
                  return Card(
                    child: ListTile(
                      title: Text('#${horario['id']} - ${horario['servicos']['nome']}'),
                      subtitle: Text(
                        '${horario['barbeiro']['nome']} | ${horario['dia_do_mes']} | ${horario['dias_semana']['nome']} ${horario['horario_inicio']}:00 - ${horario['horario_fim']}:00 | R\$${horario['servicos']['valor']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
