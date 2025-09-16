import 'package:flutter/material.dart';
import 'package:pratice/auth_service.dart';
import 'package:pratice/login_screen.dart';
import 'package:pratice/theme_provider.dart';
import 'package:provider/provider.dart';
import 'database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService dbService = DatabaseService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desginationController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SwitchListTile(
                activeThumbColor : Colors.red,
                title: const Text("Dark Mode",),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: desginationController,
                  decoration: const InputDecoration(labelText: "Designation"),
                ),
              ),

              // CREATE Button
              ElevatedButton(
                onPressed: () async {
                  final id = DateTime.now().millisecondsSinceEpoch.toString();
                  await dbService.createUser(id, {
                    "id": id,
                    "name": nameController.text,
                    "age": int.tryParse(ageController.text) ?? 0,
                    "designation": desginationController.text,
                  });
                  nameController.clear();
                  desginationController.clear();
                  ageController.clear();
                },
                child: const Text("Add User"),
              ),

              const Divider(),

              // READ StreamBuilder (Realtime Updates)
              StreamBuilder(
                stream: dbService.readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    final data =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    final users = data.values.toList();

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index] as Map;
                        return ListTile(
                          title: Row(children: [Text(user["name"])]),
                          subtitle: Text(
                            "Designation: ${user["designation"]}\nAge: ${user["age"]}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // UPDATE Button
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  dbService.updateUser(user["id"], {
                                    "name": "${user["name"]} (updated)",
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  dbService.deleteUser(user["id"]);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("No data found"));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
