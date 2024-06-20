import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class MonthlyReportScreen extends StatefulWidget {
  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório Mensal'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              List<Map<String, dynamic>> aulas = [];

              // Consulta os dados do Firebase
              DatabaseEvent snapshot = await databaseReference
                  .child('usuarios/cursos/Registrado')
                  .once();

              // Extrai os dados da consulta
              Map<dynamic, dynamic> data =
              snapshot.snapshot.value as Map<dynamic, dynamic>;
              print(data);

              // Adiciona cada aula à lista
              data.forEach((key, value) {
                aulas.add({
                  'disciplina': value['disciplina'],
                  'horaInicio': value['horaInicio'],
                  'horaTermino': value['horaTermino'],
                  'diaSemana': value['diaSemana'],
                });
              });

              // Monta o conteúdo do CSV
              List<List<dynamic>> csvData = [
                ['Disciplina', 'Dia da Semana', 'Hora de Início', 'Hora de Término']
              ];
              aulas.forEach((aula) {
                csvData.add([
                  aula['disciplina'],
                  aula['diaSemana'],
                  aula['horaInicio'],
                  aula['horaTermino'],
                ]);
              });

              // Obtém o diretório de documentos
              final directory = await getExternalStorageDirectory();
              final file = File('${directory?.path}/relatorio_mensal.csv');

              // Escreve no arquivo CSV
              String csvContent = const ListToCsvConverter().convert(csvData);
              await file.writeAsString(csvContent);

              // Notifica o usuário sobre o local do arquivo
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Relatório gerado em: ${file.path}'),
                ),
              );
            } catch (e) {
              print('Erro ao gerar o relatório CSV: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao gerar o relatório CSV: $e'),
                ),
              );
            }
          },
          child: Text('Gerar Relatório'),
        ),
      ),
    );
  }
}
