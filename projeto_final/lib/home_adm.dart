import 'package:flutter/material.dart';
import 'package:projeto_final/home.dart';
import 'package:projeto_final/servicos.dart';

class HomeAdmin extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const HomeAdmin({super.key, required this.usuario});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('King Barbearia'),
        backgroundColor: const Color.fromARGB(255, 255, 162, 40),
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
                      return Servicos();
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
        child: Text('${widget.usuario["nome"]}'),
      ),
    );
  }
}
