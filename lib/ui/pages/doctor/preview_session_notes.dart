import 'package:esma3ny/data/models/therapist/note_model.dart';
import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SessionNotesPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).notes_preview,
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
          onPressed: () {},
          child: Icon(Icons.remove_red_eye),
        ),
        body: body(),
      ),
    );
  }

  body() => Consumer<CallState>(
        builder: (context, state, child) => TabBarView(
          children: [
            tab(state.selectedSubjectives),
            tab(state.selectedObjectives),
            tab(state.selectedAssessments),
            tab(state.selectedPlans),
          ],
        ),
      );

  tab(List<NoteModel> notes) => ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, idx) => Note(notes[idx], idx),
      );
}

class Note extends StatelessWidget {
  final NoteModel noteModel;
  final int idx;
  Note(this.noteModel, this.idx);
  @override
  Widget build(BuildContext context) {
    return Consumer<CallState>(
      builder: (context, state, child) => ListTile(
        leading: IconButton(
          onPressed: () {
            print(noteModel.type);
            if (noteModel.type == 'assessment')
              state.deleteAssessment(idx);
            else if (noteModel.type == 'plan')
              state.deletePlan(idx);
            else if (noteModel.type == 'subjective') {
              state.deleteSubjectives(idx);
            } else
              state.deleteObjectives(idx);
          },
          icon: Icon(Icons.delete),
        ),
        title: Text(noteModel.title),
      ),
    );
  }
}
