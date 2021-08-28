import 'package:esma3ny/data/models/therapist/note_model.dart';
import 'package:esma3ny/data/models/therapist/prev_session_notes.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/provider/public/reload_page.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/progress_indicator.dart';
import 'package:esma3ny/ui/widgets/something_went_wrong.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrevSessionNotesPage extends StatelessWidget {
  final clientId, sessionId;
  final TherapistRepository _therapistRepository = TherapistRepository();

  PrevSessionNotesPage(
      {Key key, @required this.clientId, @required this.sessionId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<ReloadPageState>(
        builder: (context, state, child) => FutureBuilder<PrevSessionNotes>(
          future: _therapistRepository.getPrevSessionNotes(clientId, sessionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CustomProgressIndicator();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print(snapshot.data.publicNotes);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    children: [
                      note('Subjective', snapshot.data.subjective),
                      note('Objective', snapshot.data.subjective),
                      note('assessment', snapshot.data.subjective),
                      note('plan', snapshot.data.subjective),
                      boldText('Notes'),
                      Text(snapshot.data.notes),
                      Divider(),
                      boldText('Public Notes'),
                      Text(snapshot.data.publicNotes),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return ErrorIndicator(
                  error: snapshot.error,
                  onTryAgain: () => state.reload(),
                );
              }
            }
            return SomethingWentWrongWidget();
          },
        ),
      );

  boldText(text) => Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      );
  note(String title, List<NoteModel> notes) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldText(title),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: notes
                .map(
                  (note) => ListTile(
                    leading: Icon(
                      Icons.circle,
                      color: CustomColors.orange,
                    ),
                    title: Text(note.title.substring(2)),
                  ),
                )
                .toList(),
          ),
          Divider()
        ],
      );
}
