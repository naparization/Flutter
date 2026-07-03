import 'package:flutter/material.dart';
import 'package:projeto_final/escolher_servico.dart';
import 'package:projeto_final/horario_funcionamento.dart';
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
    final dados = await supabase.from('atendimento').select('*').eq('id_usuario', widget.usuario['id']).eq('finalizado', false);

    setState(() {
      listaAtendimentos = dados;
      print(listaAtendimentos);
    });
  }

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
            ListTile(
              title: const Text("Serviços"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Home(
                        usuario: widget.usuario,
                      );
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
                      return Home(
                        usuario: widget.usuario,
                      );
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
                      title: Text('#${horario['id']} -'),
                      subtitle: Text(
                        'placeholder',
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
