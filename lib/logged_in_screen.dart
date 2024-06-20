import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:time_track_management/main.dart';

import 'data_display_screen.dart';
import 'monthly_report_screen.dart';

class LoggedInScreen extends StatefulWidget {
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> aulas = [];
  List<String> professores = [];
  Map<String, int> diasSemanaCount = {
    'Segunda-Feira': 0,
    'Terça-Feira': 0,
    'Quarta-Feira': 0,
    'Quinta-Feira': 0,
    'Sexta-Feira': 0,
    'Sábado': 0,
    'Domingo': 0,
  };
  String? selectedProfessor;

  @override
  void initState() {
    super.initState();
    fetchAulas();
  }

  Future<void> fetchAulas() async {
    try {
      // Consulta os dados do Firebase
      DatabaseEvent snapshot = await databaseReference
          .child('usuarios/cursos/Registrado')
          .once();

      // Extrai os dados da consulta
      Map<dynamic, dynamic> data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      print(data);
      aulas.clear();
      professores.clear();
      diasSemanaCount.updateAll((key, value) => 0);

      // Adiciona cada aula à lista e conta os dias da semana
      data.forEach((key, value) {
        aulas.add({
          'disciplina': value['disciplina'],
          'horaInicio': value['horaInicio'],
          'horaTermino': value['horaTermino'],
          'diaSemana': value['diaSemana'],
          'dataRegistro': value['dataRegistro'],
          'professor': value['professor'],
        });
        if (!professores.contains(value['professor'])) {
          professores.add(value['professor']);
        }
        diasSemanaCount[value['diaSemana']] = (diasSemanaCount[value['diaSemana']] ?? 0) + 1;
      });
      // Atualiza o estado da tela
      setState(() {});
    } catch (e) {
      print('Erro ao buscar aulas: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredAulas = selectedProfessor == null
        ? aulas
        : aulas.where((aula) => aula['professor'] == selectedProfessor).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Área Logada'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Gráfico de Aulas Ministradas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoggedInScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Gerenciamento de Pontos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DataDisplayScreen(databaseReference: databaseReference)),);
                // Navegar para outra tela
              },
            ),
            ListTile(
              title: Text('Relatório de Pontos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonthlyReportScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              hint: Text("Selecione o professor"),
              value: selectedProfessor,
              onChanged: (String? newValue) {
                setState(() {
                  selectedProfessor = newValue;
                });
              },
              items: professores.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('Seg', style: style);
                              break;
                            case 1:
                              text = const Text('Ter', style: style);
                              break;
                            case 2:
                              text = const Text('Qua', style: style);
                              break;
                            case 3:
                              text = const Text('Qui', style: style);
                              break;
                            case 4:
                              text = const Text('Sex', style: style);
                              break;
                            case 5:
                              text = const Text('Sáb', style: style);
                              break;
                            case 6:
                              text = const Text('Dom', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          return Text('${value.toInt()}', style: style);
                        },
                        reservedSize: 28,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Segunda-Feira')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Terça-Feira')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Quarta-Feira')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Quinta-Feira')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Sexta-Feira')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Sábado')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      barRods: [
                        BarChartRodData(
                          toY: filteredAulas
                              .where((aula) => aula['diaSemana'] == 'Domingo')
                              .length
                              .toDouble(),
                          color: Colors.lightBlueAccent,
                          width: 15,
                          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (selectedProfessor != null) ...[
              Text(
                'Aulas do professor $selectedProfessor',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredAulas.length,
                  itemBuilder: (context, index) {
                    var aula = filteredAulas[index];
                    return ListTile(
                      title: Text(aula['disciplina']),
                      subtitle: Text(
                          '${aula['diaSemana']}, ${aula['horaInicio']} - ${aula['horaTermino']},${aula['dataRegistro']}'),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}