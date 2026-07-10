import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_final/confirmar_atendimento.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscolherHorario extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final Map<String, dynamic> servico;
  final Map<String, dynamic> barbeiro;
  const EscolherHorario({super.key, required this.barbeiro, required this.servico, required this.usuario});

  @override
  State<EscolherHorario> createState() => _EscolherHorarioState();
}

class _EscolherHorarioState extends State<EscolherHorario> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> listaHorarios = [];
  bool carregando = false;

  DateTime dataSelecionada = DateTime.now();

  // Gera os próximos 14 dias para a faixa de seleção rápida
  final List<DateTime> proximosDias = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  void initState() {
    super.initState();
    carregarHorarios();
  }

  // Converte o weekday do Dart (1=Segunda ... 7=Domingo)
  // para o padrão da tabela dias_semana (ajuste se o seu for diferente,
  // ex: 0=Domingo ... 6=Sábado)
  int converterParaIdDiaSemana(DateTime data) {
    return data.weekday == 7 ? 0 : data.weekday;
  }

  Future<void> carregarHorarios() async {
    setState(() {
      carregando = true;
      listaHorarios = [];
    });

    final idDiaSemana = converterParaIdDiaSemana(dataSelecionada);
    final dataFormatada = DateFormat('yyyy-MM-dd').format(dataSelecionada);

    // 1. Busca os horários que o barbeiro trabalha nesse dia da semana
    final dados = await supabase
        .from('horarios_funcionario')
        .select('*, dias_semana(id, nome)')
        .eq('funcionario_id', widget.barbeiro['id'])
        .eq('disponivel', true)
        .eq('dia_semana', idDiaSemana)
        .order('horario_inicio', ascending: true);

    List<Map<String, dynamic>> horariosExpandidos = [];

    for (final linha in dados) {
      final inicio = linha['horario_inicio'] as int;
      final fim = linha['horario_fim'] as int;

      for (int hora = inicio; hora < fim; hora++) {
        horariosExpandidos.add({
          ...linha,
          'horario_inicio': hora,
          'horario_fim': hora + 1,
        });
      }
    }

    // 2. Busca os agendamentos já marcados com esse barbeiro nessa data
    final agendamentosExistentes = await supabase
        .from('atendimento')
        .select('horario_inicio')
        .eq('id_barbeiro', widget.barbeiro['id'])
        .eq('dia_do_mes', dataFormatada);

    final horariosOcupados = agendamentosExistentes.map<int>((a) => a['horario_inicio'] as int).toSet();

    // 3. Remove os horários que já estão ocupados
    horariosExpandidos.removeWhere(
      (h) => horariosOcupados.contains(h['horario_inicio']),
    );

    setState(() {
      listaHorarios = horariosExpandidos;
      carregando = false;
    });
  }

  Future<void> abrirCalendarioCompleto() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('pt', 'BR'),
    );

    if (escolhida != null) {
      setState(() {
        dataSelecionada = escolhida;
      });
      carregarHorarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher Horário'),
        backgroundColor: const Color.fromARGB(255, 42, 172, 128),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: abrirCalendarioCompleto,
          ),
        ],
      ),
      body: Column(
        children: [
          // Faixa de seleção rápida de dias
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: proximosDias.length,
              itemBuilder: (context, index) {
                final dia = proximosDias[index];
                final selecionado = dia.year == dataSelecionada.year && dia.month == dataSelecionada.month && dia.day == dataSelecionada.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      dataSelecionada = dia;
                    });
                    carregarHorarios();
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: selecionado ? const Color.fromARGB(255, 42, 172, 128) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE', 'pt_BR').format(dia),
                          style: TextStyle(
                            fontSize: 12,
                            color: selecionado ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM').format(dia),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selecionado ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: carregando
                ? const Center(child: CircularProgressIndicator())
                : listaHorarios.isEmpty
                ? const Center(
                    child: Text('Nenhum horário disponível para esse dia.'),
                  )
                : ListView.builder(
                    itemCount: listaHorarios.length,
                    itemBuilder: (context, index) {
                      final horario = listaHorarios[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            DateFormat('EEEE, dd/MM/yyyy', 'pt_BR').format(dataSelecionada),
                          ),
                          subtitle: Text(
                            '${horario["horario_inicio"]}:00 - ${horario["horario_inicio"] + 1}:00',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ConfirmarAtendimento(
                                    usuario: widget.usuario,
                                    horario: horario,
                                    barbeiro: widget.barbeiro,
                                    servico: widget.servico,
                                    diaDoMes: dataSelecionada,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
