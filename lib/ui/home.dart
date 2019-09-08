import 'package:air_todo/model/note.dart';
import 'package:air_todo/model/note_db_worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List notes = [ ];
  final TextEditingController _titleController = TextEditingController();
  void getAll() async {
    var notess = await NoteDbWorker.db.getAll();
    setState(() {
      notes = notess;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAll();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("AIR TODO"),
        centerTitle: true,
      ),
      body: notes.isEmpty ? Center(
        child: Text(
          "Aucune note !",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ) : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          Note note = notes[index];
          return Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Slidable(
              actionExtentRatio: .10,
              delegate: SlidableDrawerDelegate(),
              secondaryActions: <Widget>[
                IconSlideAction(
                  icon: Icons.delete,
                  foregroundColor: Colors.red,
                  color: Colors.black26,
                  onTap: () {
                    _deleteNote(note);
                  },
                )
              ],
              child: Card(
                elevation: 8,
                child: ListTile(
                  title: Text(
                    "${note.title}",
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                  subtitle: Text(
                    "${note.date}",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.blue,
        onPressed: () {
          _addNote(context);
        },
      ),
    );
  }

  Future _addNote(BuildContext inContext) {
    Note note = Note();
    var now = DateTime.now();
    var date = DateFormat("EEE, d MMM").format(now);
    note.date = date;
    return showDialog(
      context: inContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ajouter la note"),
          content: Container(
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                hintText: "Titre",
              ),
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ajouter'),
              textColor: Colors.green,
              onPressed: () {
                note.title = _titleController.text;
                NoteDbWorker.db.create(note);
                Navigator.of(context).pop();
                getAll();
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Note ajouté"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  )
                );
                _titleController.clear();
              },
            )
          ],
        );
      },
    );


  }

  void _deleteNote(Note note) {
    NoteDbWorker.db.delete(note.id);
    getAll();
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Note supprimé !"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )
    );
  }
}


