import 'package:esma3ny/data/models/enums/sessionStatus.dart';
import 'package:esma3ny/data/models/therapist/appointment.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/widgets/appointment.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  String page = 'today';
  final _pagingController = PagingController<int, Appointment>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  TherapistRepository _therapistRepository = TherapistRepository();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _therapistRepository.getAppointment(pageKey, page);

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<Appointment> newPageDecoded = [];
      newPage['data'].forEach((appointment) {
        print(appointment);
        newPageDecoded.add(Appointment.fromJson(appointment));
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
          'Appointments',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          DropdownButton(
            value: page,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                value: 'today',
                child: Text('To day'),
              ),
              DropdownMenuItem(
                value: 'upcoming',
                child: Text('Upcoming'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                page = value;
              });
              _pagingController.refresh();
            },
          ),
        ],
      ),
      body: body(),
    );
  }

  body() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView.separated(
          builderDelegate: PagedChildBuilderDelegate<Appointment>(
            itemBuilder: (context, appointment, index) => Container(
              child: AppointmentCard(
                appointment,
                isStarted: appointment.status == SessionStatus.Started,
              ),
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
