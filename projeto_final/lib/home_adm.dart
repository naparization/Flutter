import 'package:flutter/material.dart';
import 'package:projeto_final/horario_funcionamento.dart';
import 'package:projeto_final/servicos.dart';
import 'package:projeto_final/telaLogin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeAdmin extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const HomeAdmin({
    super.key,
    required this.usuario,
  });

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
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
        .select('*, cliente:usuarios!atendimento_id_usuario_fkey(*), servicos(nome, valor), dias_semana(nome)')
        .eq('id_barbeiro', widget.usuario['id'])
        .eq('finalizado', false)
        .eq('dia_do_mes', DateTime.now());

    setState(() {
      listaAtendimentos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('King Barbearia'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Column(
                children: [
                  Text('Tela Administrativa'),
                ],
              ),
            ),
            ListTile(
              title: const Text("Serviços"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const Servicos();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Horários"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return HorarioFuncionamento(
                        usuario: widget.usuario,
                      );
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return TelaDeLogin();
                    },
                  ),
                );
              },
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
                  subtitle: Text('Barbeiro | Comissão: R\$${widget.usuario['comissao']}'),
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
                        '${horario['cliente']['nome']} | ${horario['dias_semana']['nome']} ${horario['horario_inicio']}:00 - ${horario['horario_fim']}:00',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              try {
                                double comissao = horario['servicos']['valor'] * 0.20;
                                await supabase.from('atendimento').update({'finalizado': true}).eq('id', horario['id']);
                                await supabase
                                    .from('usuarios')
                                    .update({'comissao': widget.usuario['comissao'] + comissao})
                                    .eq('id', widget.usuario['id']);
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
                                    content: Text("Ocorreu um erro."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Finalizar Agendamento',
                          ),
                          IconButton(
                            onPressed: () async {
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
                            },
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Cancelar Agendamento',
                          ),
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
    );
  }
}
