import 'package:flutter/material.dart';
import 'package:projeto_final/escolher_servico.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const Home({
    super.key,
    required this.usuario,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaAtendimentos = [];
  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<void> carregarServicos() async {
    final dados = await supabase.from('atendimento').select('*, barbeiro:usuarios!atendimento_id_barbeiro_fkey(*), servicos(nome, valor), dias_semana(nome)').eq('id_usuario', widget.usuario['id']).eq('finalizado', false);

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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                children: [
                  Text('Tela do Usuário'),
                ],
              ),
            ),
            
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(60.0),

              child: Card(
                child: ListTile(
                  title: Text(widget.usuario['nome']),
                  subtitle: Text('Usuário'),
                  minLeadingWidth: 50,
                ),
              ),
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
                        '${horario['barbeiro']['nome']} | ${horario['dias_semana']['nome']} ${horario['horario_inicio']}:00 - ${horario['horario_fim']}:00 | R\$${horario['servicos']['valor']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(onPressed: () async {
                            try {
                            double comissao = horario['servicos']['valor'] * 0.20;
                            await supabase.from('atendimento').update({'finalizado': true}).eq('id', horario['id']);
                            await supabase.from('usuarios').update({'comissao': horario['barbeiro']['comissao'] + comissao}).eq('id', horario['barbeiro']['id']);
                            carregarServicos();
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Agendamento Finalizado."),
                              backgroundColor: Colors.green,
                        ),
                      );
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('aaa'),
                              backgroundColor: Colors.red,
                        ),
                      );
                            }

                          }, icon: Icon(Icons.check, color: Colors.green,), tooltip:'Finalizar Agendamento'),

                          IconButton(onPressed: () async {
                            try {
                            await supabase.from('atendimento').delete().eq('id', horario['id']);
                            carregarServicos();
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Agendamento cancelado."),
                              backgroundColor: Colors.green,
                        ),
                      );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ocorreu um erro."),
                              backgroundColor: Colors.red,
                        ),
                      );
                            }
                            
                          }, icon: Icon(Icons.cancel, color: Colors.red,), tooltip: 'Cancelar Agendamento',)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EscolherServico(
                  usuario: widget.usuario,
                );
              },
            ),
          );
        },
        tooltip: 'Agendar Horário',
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 29, 116, 87),
        ),
      ),
    );
  }
}
