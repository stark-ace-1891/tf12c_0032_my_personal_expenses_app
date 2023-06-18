import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:tf12c_0032_my_personal_expenses_app/models/spent.dart';
import 'package:tf12c_0032_my_personal_expenses_app/services/expenses_service.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final expensesService = ExpensesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis gastos'),
      ),
      body: StreamBuilder(
          stream: expensesService.getMyExpenses(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data;
            if (data != null) {
              return ListView(
                children: [
                  ...data.docs.map(
                    (doc) {
                      final spentData = doc.data();
                      if (spentData != null) {
                        final spent =
                            Spent.fromJson(spentData as Map<String, dynamic>);
                        final dateFormat =
                            DateFormat('d, MMM y - H:m').format(spent.createAt);
                        return ListTile(
                          title: Text(spent.description),
                          subtitle: Text(dateFormat),
                          leading: Text(
                            'S/ ${spent.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          minLeadingWidth: 56,
                        );
                      }
                      return Text('Este dato fallo');
                    },
                  ).toList()
                ],
              );
            } else {
              return const Center(
                child: Text('Algo salio mal'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return SizedBox(
                  height: 800,
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding:
                          const EdgeInsets.only(top: 24, right: 16, left: 16),
                      children: [
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Descripcion'),
                          validator: RequiredValidator(
                              errorText: 'Este campo es requerido'),
                        ),
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(labelText: 'Monto'),
                          keyboardType: TextInputType.number,
                          validator: RequiredValidator(
                              errorText: 'Este campo es requerido'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              try {
                                await expensesService.saveSpent(
                                  description: _descriptionController.text,
                                  amount: double.parse(_amountController.text),
                                );

                                if (context.mounted) {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Gasto guardado'),
                                    ),
                                  );

                                  _descriptionController.clear();
                                  _amountController.clear();

                                  // setState(() {});
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('No se pudo guardar el gasto'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Agregar Gasto'),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
