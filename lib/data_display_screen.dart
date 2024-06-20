import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DataDisplayScreen extends StatelessWidget {
  final DatabaseReference databaseReference;

  DataDisplayScreen({required this.databaseReference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aulas Pendentes'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseReference.child('usuarios/cursos').once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Nenhum dado encontrado'));
          }

          Map<dynamic, dynamic> data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> items = data.entries
              .where((entry) => entry.value['status'] == 'Pendente')
              .map((entry) {
            return {
              'curso': entry.value['curso'],
              'disciplina': entry.value['disciplina'],
              'diaSemana': entry.value['diaSemana'],
              'horaInicio': entry.value['horaInicio'],
              'horaTermino': entry.value['horaTermino'],
              'bloco': entry.value['bloco'],
              'sala': entry.value['sala'],
              'status': entry.value['status'],
              'dataRegistro': entry.value['dataRegistro'],
            };
          }).toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text('${item['curso']} - ${item['disciplina']}'),
                subtitle: Text(
                  '${item['diaSemana']}: ${item['horaInicio']} - ${item['horaTermino']}\n'
                      'Bloco: ${item['bloco']}, Sala: ${item['sala']}\n'
                      'Status: ${item['status']}\n'
                      'Data de Registro: ${item['dataRegistro']}',
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateMateriaDialog(databaseReference: databaseReference);
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class CreateMateriaDialog extends StatefulWidget {
  final DatabaseReference databaseReference;

  CreateMateriaDialog({required this.databaseReference});

  @override
  _CreateMateriaDialogState createState() => _CreateMateriaDialogState();
}

class _CreateMateriaDialogState extends State<CreateMateriaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cursoController = TextEditingController();
  final _disciplinaController = TextEditingController();
  final _diaSemanaController = TextEditingController();
  final _horaInicioController = TextEditingController();
  final _horaTerminoController = TextEditingController();
  final _blocoController = TextEditingController();
  final _salaController = TextEditingController();
  final _statusController = TextEditingController();
  final _dataRegistroController = TextEditingController();

  @override
  void dispose() {
    _cursoController.dispose();
    _disciplinaController.dispose();
    _diaSemanaController.dispose();
    _horaInicioController.dispose();
    _horaTerminoController.dispose();
    _blocoController.dispose();
    _salaController.dispose();
    _statusController.dispose();
    _dataRegistroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Criar Nova Matéria'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _cursoController,
                decoration: InputDecoration(labelText: 'Curso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o curso';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _disciplinaController,
                decoration: InputDecoration(labelText: 'Disciplina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a disciplina';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diaSemanaController,
                decoration: InputDecoration(labelText: 'Dia da Semana'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o dia da semana';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaInicioController,
                decoration: InputDecoration(labelText: 'Hora de Início'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a hora de início';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaTerminoController,
                decoration: InputDecoration(labelText: 'Hora de Término'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a hora de término';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _blocoController,
                decoration: InputDecoration(labelText: 'Bloco'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o bloco';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaController,
                decoration: InputDecoration(labelText: 'Sala'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a sala';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o status';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dataRegistroController,
                decoration: InputDecoration(labelText: 'Data de Registro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a data de registro';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Adiciona a nova matéria ao banco de dados
              widget.databaseReference.child('usuarios/cursos').push().set({
                'curso': _cursoController.text,
                'disciplina': _disciplinaController.text,
                'diaSemana': _diaSemanaController.text,
                'horaInicio': _horaInicioController.text,
                'horaTermino': _horaTerminoController.text,
                'bloco': _blocoController.text,
                'sala': _salaController.text,
                'status': _statusController.text,
                'dataRegistro': _dataRegistroController.text,
              }).then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                print('Erro ao adicionar matéria: $error');
              });
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
