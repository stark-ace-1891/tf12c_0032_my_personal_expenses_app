import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
        title: Text("Mis gatos"),
      ),
      body: Center(
        child: FutureBuilder(
          future: expensesService.getMyExpenses(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              final data = snapshot.data;
              if (data != null) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await expensesService.getMyExpenses();
                    setState(() {});
                  },
                  child: ListView(
                    children: [
                      ...data.map(
                        (spent) {
                          final dateFormat = DateFormat('d, MMM y - H:m')
                              .format(spent.createAt);
                          return ListTile(
                            title: Text(spent.description),
                            subtitle: Text('${dateFormat}'),
                            leading:
                                Text('S/. ${spent.amount.toStringAsFixed(2)}'),
                            minLeadingWidth: 48,
                          );
                        },
                      ).toList(),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: Text("Algo salio mal"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
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
                    padding: EdgeInsets.only(
                      top: 24,
                      right: 16,
                      left: 16,
                    ),
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripcion',
                        ),
                        validator: RequiredValidator(
                            errorText: "Este campo es requerido"),
                      ),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: "Este campo es requerido"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              await expensesService.saveSpent(
                                  description: _descriptionController.text,
                                  amount: double.parse(_amountController.text));
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Gasto guardado"),
                                  ),
                                );

                                setState(() {});

                                _descriptionController.clear();
                                _amountController.clear();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Ocurrio un error al guardar"),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          "Agregar gasto",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
