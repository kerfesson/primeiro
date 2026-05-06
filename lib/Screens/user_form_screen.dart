import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/db_helper.dart';  

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {

final _formKey = GlobalKey<FormState>();
late TextEditingController _nameCtrl;
late TextEditingController _emailCtrl;
late TextEditingController _telefoneCtrl;
final _db = DbHelper();

bool get isEditing => widget.user != null;

@override
void initState() {
  super.initState();
  _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
  _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
  _telefoneCtrl = TextEditingController(text:widget.user?.telefone ?? '');

}

Future<void> _save() async {
  if (_formKey.currentState!.validate()) {
    final user = User(
      id: widget.user?.id,
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      telefone: _telefoneCtrl.text.trim(),
    );
  
    if (isEditing) 
      await _db.updateUser(user);
     else 
      await _db.insertUsers(user);
    
    if (mounted) {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).
      showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Usuario atualizado!' : 'Usuario criado!')),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(
        isEditing ? 'Editar Usuario' : 'Novo Usuario'),
      backgroundColor: Colors.red,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
             child: Icon(Icons.account_circle,
             size: 80,)
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Informe o email' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefoneCtrl,
              decoration: const InputDecoration(labelText: 'Telefone'),
              validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(isEditing ? 'Atualizar' : 'Salvar'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildField(
  TextEditingController ctrl,
  String label,
 IconData icon, {
  TextInputType keyboardType = TextInputType.text,
 }) {
  return TextFormField(
    controller: ctrl,
    keyboardType: keyboardType,
    decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder
    (borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: Colors.grey,
    ),

    validator: (v) => v == null || v.
    isEmpty ? 'campo obrigatorio' : null,
  );
 }
}