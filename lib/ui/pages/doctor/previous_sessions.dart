import 'package:esma3ny/data/models/therapist/previous_session.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/pages/doctor/prev_session_notes.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class PreviousSessions extends StatefulWidget {
  final int id;

  const PreviousSessions({Key key, @required this.id}) : super(key: key);

  @override
  _PreviousSessionsState createState() => _PreviousSessionsState();
}

class _PreviousSessionsState extends State<PreviousSessions> {
  final _pagingController = PagingController<int, PreviousSession>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  TherapistRepository _therapistRepository = TherapistRepository();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage =
          await _therapistRepository.getPrevSessions(widget.id, pageKey);

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<PreviousSession> newPageDecoded = [];
      newPage['timeslots']['data'].forEach((timeslot) {
        newPageDecoded.add(PreviousSession.fromJson(
          timeslot,
          timeslot['session']['day'],
        ));
      });
      final newItems = newPageDecoded;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  final format = DateFormat('dd-MM-yyyy - HH:MM');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sessions',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView.separated(
          builderDelegate: PagedChildBuilderDelegate<PreviousSession>(
            itemBuilder: (context, session, index) => Container(
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(5),
                child: ListTile(
                  title: Text(session.day),
                  subtitle: Text(
                      'booked at: ${format.format(DateTime.parse(session.bookedAt))}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.note_alt,
                      color: CustomColors.blue,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrevSessionNotesPage(
                          clientId: widget.id,
                          sessionId: session.id,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
          ),
          pagingController: _pagingController,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        ),
      );
}
