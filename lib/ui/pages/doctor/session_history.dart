import 'package:esma3ny/data/models/therapist/session_history.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/widgets/client_card.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SessionHistoryPage extends StatefulWidget {
  @override
  _SessionHistoryPageState createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {
  final _pagingController = PagingController<int, SessionHistory>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  TherapistRepository _therapistRepository = TherapistRepository();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _therapistRepository.getSessionHistory(pageKey);

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<SessionHistory> newPageDecoded = [];
      newPage['data'].forEach((therapist) {
        newPageDecoded.add(SessionHistory.fromJson(therapist));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Session History',
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
          builderDelegate: PagedChildBuilderDelegate<SessionHistory>(
            itemBuilder: (context, session, index) => Container(
              child: ClientCard(sessionHistory: session),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
          ),
          // 4
          pagingController: _pagingController,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
        ),
      );
}
