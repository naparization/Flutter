import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'novo_servico.dart';

class Servicos extends StatefulWidget {
  const Servicos({super.key});

  @override
  State<Servicos> createState() => _ServicosState();
}

class _ServicosState extends State<Servicos> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaServicos = [];

  @override
  void initState() {
    super.initState();
    carregarServicos();
  }

  Future<void> carregarServicos() async {
  try {
    final dados = await supabase
        .from('servicos')
        .select('*');

    debugPrint(dados.toString());

    setState(() {
      listaServicos = List<Map<String, dynamic>>.from(dados);
    });
  } catch (e) {
    debugPrint("ERRO: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        title: const Text("Serviços"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: ListView.builder(
          itemCount: listaServicos.length,

          itemBuilder: (context, index) {

            final servico = listaServicos[index];

            return Card(
  child: ListTile(
    title: Text(
      servico["nome"],
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),

    subtitle: Text(servico["descricao"]),

    trailing: Text(
      "R\$ ${servico["valor"]}",
      style: const TextStyle(
        fontSize: 18,
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),

    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NovoServico(servico: servico),
        ),
      );

      carregarServicos();
    },
  ),
);
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
        child: const Icon(Icons.add),

        onPressed: () async {

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NovoServico(),
            ),
          );

          carregarServicos();

        },
      ),

    );
  }
}