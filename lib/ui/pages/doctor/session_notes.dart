import 'package:esma3ny/data/models/therapist/note_model.dart';
import 'package:esma3ny/ui/pages/doctor/preview_session_notes.dart';
import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionNotes extends StatefulWidget {
  @override
  _SessionNotesState createState() => _SessionNotesState();
}

class _SessionNotesState extends State<SessionNotes> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Session Notes',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            labelColor: CustomColors.orange,
            tabs: [
              Tab(text: 'Subjectives'),
              Tab(text: 'Objectives'),
              Tab(text: 'Assessment'),
              Tab(text: 'Plan'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => SessionNotesPreview())),
          child: Icon(Icons.remove_red_eye),
        ),
        body: body(),
      ),
    );
  }

  body() => Consumer<CallState>(
        builder: (context, state, child) => TabBarView(
          children: [
            tab(state.subjective.notes),
            tab(state.objective.notes),
            tab(state.assessment.notes),
            tab(state.plan.notes),
          ],
        ),
      );

  tab(List<NoteModel> notes) => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, idx) => Note(notes[idx]),
      );
}

class Note extends StatelessWidget {
  final NoteModel noteModel;
  Note(this.noteModel);
  @override
  Widget build(BuildContext context) {
    return Consumer<CallState>(
      builder: (context, state, child) => ListTile(
        leading: IconButton(
          onPressed: () {
            if (noteModel.type == 'assessment')
              state.addAssessment(noteModel);
            else if (noteModel.type == 'plan')
              state.addPlan(noteModel);
            else if (noteModel.type == 'subjective')
              state.addSubjectives(noteModel);
            else
              state.addObjectives(noteModel);
          },
          icon: Icon(Icons.add),
        ),
        title: Text(noteModel.title),
      ),
    );
  }
}