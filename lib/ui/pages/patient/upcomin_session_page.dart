import 'package:esma3ny/data/models/client_models/time_slot_response.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/provider/upcoming_sessions_state.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:esma3ny/ui/widgets/upcoming_session_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class UpComingSessions extends StatefulWidget {
  @override
  _UpComingSessionsState createState() => _UpComingSessionsState();
}

class _UpComingSessionsState extends State<UpComingSessions> {
  final _pagingController = PagingController<int, TimeSlotResponse>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _clientRepositoryImpl.showReservedTimeSlots(
        pageKey,
      );

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<TimeSlotResponse> newPageDecoded = [];
      newPage['data'].forEach((timeSlot) {
        newPageDecoded.add(TimeSlotResponse.fromJson(timeSlot));
      });
      final newItems = newPageDecoded;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print('asxasxas');
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
          'Upcoming Sessions',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: body(),
    );
  }

  body() => Consumer<UpcommingSessionState>(builder: (context, state, child) {
        if (state.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _pagingController.refresh();
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: PagedListView.separated(
              builderDelegate: PagedChildBuilderDelegate<TimeSlotResponse>(
                itemBuilder: (context, timeSlot, index) => Container(
                  child: UpcomingSessionCard(timeSlot: timeSlot),
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
          ),
        );
      });
}
