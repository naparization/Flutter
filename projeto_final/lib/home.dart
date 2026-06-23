import 'package:flutter/material.dart';
import 'package:projeto_final/escolher_servico.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('King Barbearia'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [Text('Tela Administrativa')],
              ),
            ),
            ListTile(
              title: Text("Serviços"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Home();
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Horários"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return Home();
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
          children: [Text('Nada por enquanto. (PLACEHOLDER)')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EscolherServico();
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
