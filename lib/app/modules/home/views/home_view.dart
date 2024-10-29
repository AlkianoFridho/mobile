import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mobile/app/modules/home/controllers/app_color.dart';
import 'package:mobile/app/modules/home/controllers/auth_controller.dart';
import 'package:mobile/app/modules/home/views/widget_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthController _authController;
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateTaskScreen(isEdit: false)),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task has been created')),
            );
          }
        },
        backgroundColor: appColor.colorTertiary,
      ),
    );
  }

  // Widget to display the task list
  Widget _buildWidgetListTodo() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('tasks')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var tasks = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = tasks[index];
            Map<String, dynamic> task = document.data() as Map<String, dynamic>;
            String date = task['date'] ?? '';

            return Card(
              child: ListTile(
                title: Text(task['name']),
                subtitle: Text(
                  task['description'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: _buildDateWidget(date),
                trailing: PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                  onSelected: (String value) =>
                      _onTaskActionSelected(value, document),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget to display the date of the task
  Widget _buildDateWidget(String date) {
    if (date.isEmpty) return const SizedBox.shrink();

    DateTime parsedDate = DateTime.parse(date);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 24.0,
          height: 24.0,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${parsedDate.day}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          '${parsedDate.month}/${parsedDate.year}',
          style: const TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }

  // Handle task edit or delete action
  Future<void> _onTaskActionSelected(
      String action, DocumentSnapshot document) async {
    if (action == 'edit') {
      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTaskScreen(
            isEdit: true,
            taskId: document.id,
            taskName: document['name'],
            taskDescription: document['description'],
          ),
        ),
      );
      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task has been updated')),
        );
      }
    } else if (action == 'delete') {
      await firestore.collection('tasks').doc(document.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task has been deleted')),
      );
    }
  }
}

// Screen to create or edit a task
class CreateTaskScreen extends StatefulWidget {
  final bool isEdit;
  final String? taskId;
  final String? taskName;
  final String? taskDescription;

  const CreateTaskScreen({
    Key? key,
    required this.isEdit,
    this.taskId,
    this.taskName,
    this.taskDescription,
  }) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _nameController.text = widget.taskName ?? '';
      _descriptionController.text = widget.taskDescription ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Task' : 'Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text(widget.isEdit ? 'Update Task' : 'Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  // Save or update the task
  Future<void> _saveTask() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    if (widget.isEdit && widget.taskId != null) {
      // Update existing task
      await firestore.collection('tasks').doc(widget.taskId).update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'date': DateTime.now().toString(),
      });
    } else {
      // Create new task
      await firestore.collection('tasks').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'date': DateTime.now().toString(),
      });
    }

    Navigator.pop(
        context, true); // Return to previous screen with result as true
  }
}
