// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class LoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              title: Text('Opção 1'),
              onTap: () {
                // Navegar para outra tela
              },
            ),
            ListTile(
              title: Text('Opção 2'),
              onTap: () {
                // Navegar para outra tela
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Horas trabalhadas na semana',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Seg';
                          case 1:
                            return 'Ter';
                          case 2:
                            return 'Qua';
                          case 3:
                            return 'Qui';
                          case 4:
                            return 'Sex';
                          case 5:
                            return 'Sáb';
                          case 6:
                            return 'Dom';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      margin: 16,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 8, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 7, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 6, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 5, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(y: 9, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 5, barRods: [BarChartRodData(y: 5, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                    BarChartGroupData(x: 6, barRods: [BarChartRodData(y: 3, colors: [Colors.lightBlueAccent, Colors.greenAccent])]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Aulas dadas na semana',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Segunda-feira: Matemática'),
                    subtitle: Text('10:00 - 11:30'),
                  ),
                  ListTile(
                    title: Text('Terça-feira: Física'),
                    subtitle: Text('11:00 - 12:30'),
                  ),
                  ListTile(
                    title: Text('Quarta-feira: Química'),
                    subtitle: Text('09:00 - 10:30'),
                  ),
                  ListTile(
                    title: Text('Quinta-feira: Biologia'),
                    subtitle: Text('08:00 - 09:30'),
                  ),
                  ListTile(
                    title: Text('Sexta-feira: História'),
                    subtitle: Text('13:00 - 14:30'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

