import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database/db_helper.dart';
import 'user_form_screen.dart';



class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DbHelper _db= DbHelper();
  List<User> _users = [];
  final List<User> _filteredUsers = [];
  final _seachCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
 
  Future<void> _loadUsers() async {
    final data = await _db.getUsers();
    setState(() => _users = data);
  }

  Future<void> _deleteUser(User user) async {
    await _db.deleteUser(user.id!);
    _loadUsers();
   if (mounted) {
      ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(content: Text('${user.name} excluido com sucesso!')),
      );
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 2, 
        ),

        body: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: const BoxDecoration(
              color: Colors.red,
                borderRadius: const BorderRadius.
                only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Gestao de Usuarios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),

            Expanded(
              child: _users.isEmpty
                ? const Center(
                  child: Text(
                  'Nenhum usuario cadastrado.',
                  style: TextStyle
                  (fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.
                all(8),
                itemCount: _users.length,
                itemBuilder: (context, i) {
                  final user = _users[i];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 4,
                    ),
                    shape: 
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        Colors.red.
                        withOpacity (0.2),
                        child: const Icon(
                          Icons.person,
                          color: Colors.red,
                    ),
                  ),
                    title: Text(
                      user.name,
                      style: const 
                      TextStyle
                      (fontWeight:
                      FontWeight.bold), 
                    ),
                    subtitle: Text(user.
                    email),
                    trailing: Row(
                      mainAxisSize: 
                      MainAxisSize
                        .min,
                      children: [
                        _iconButton(
                          Icons.edit,
                          Colors.blue,
                         () => _openForm
                         (user),
                        ),
                        const SizedBox
                        (width: 8),
                        _iconButton(
                          Icons.delete,
                          Colors.red,
                          () => _showDeleteDialog(user),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
          ],
          ),

          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openForm(null),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add),
            label: const Text('novo usuario'),
          ),
    );
  }

  Widget _iconButton(IconData icon, Color color, VoidCallback onPressed) {
    return IconButton(icon: Icon(icon), color: color, onPressed: onPressed);
  }


  void _openForm(User? user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserFormScreen(user: user)),
    );
      _loadUsers();
    }

  void _showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}