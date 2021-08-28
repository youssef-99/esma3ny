import 'package:esma3ny/data/models/therapist/previous_client.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/pages/doctor/client_profile.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PreviousClientsPage extends StatefulWidget {
  @override
  _PreviousClientsPageState createState() => _PreviousClientsPageState();
}

class _PreviousClientsPageState extends State<PreviousClientsPage> {
  final _pagingController = PagingController<int, PreviousClient>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  TherapistRepository _therapistRepository = TherapistRepository();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _therapistRepository.getPrevClients(pageKey);

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<PreviousClient> newPageDecoded = [];
      newPage['data'].forEach((client) {
        newPageDecoded.add(PreviousClient.fromJson(client));
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
          'Clients',
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
          builderDelegate: PagedChildBuilderDelegate<PreviousClient>(
            itemBuilder: (context, client, index) => Container(
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(5),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientProfile(client.id)),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(client.profileImage.small),
                  ),
                  title: Text(client.name),
                  subtitle: Text(client.age),
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
