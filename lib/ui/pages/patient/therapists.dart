import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_filter.dart';
import 'package:esma3ny/data/models/client_models/therapist/therapist_general_info.dart';
import 'package:esma3ny/repositories/client_repositories/ClientRepositoryImpl.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../theme/colors.dart';
import '../../widgets/filtersSheet.dart';
import '../../widgets/therapistListCard.dart';

class TherapistsList extends StatefulWidget {
  @override
  _TherapistsListState createState() => _TherapistsListState();
}

class _TherapistsListState extends State<TherapistsList>
    with TickerProviderStateMixin {
  final _pagingController = PagingController<int, TherapistListInfo>(
    firstPageKey: 1,
  );

  bool isSearch = false;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  ClientRepositoryImpl _clientRepositoryImpl = ClientRepositoryImpl();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _clientRepositoryImpl.getDoctorsList(
        FilterTherapist(
            specializeId: null, languageId: null, jobId: null, gender: null),
        pageKey,
      );

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<TherapistListInfo> newPageDecoded = [];
      newPage['data'].forEach((therapist) {
        newPageDecoded.add(TherapistListInfo.fromJson(therapist));
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
        title: AnimatedSizeAndFade(
          vsync: this,
          child: !isSearch
              ? Text(
                  'Therapists',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                )
              : TextField(),
        ),
        leading: appBarLeading(),
        actions: [
          actionButton(
            Icons.filter_alt_rounded,
            () {
              _showCupertinoModalBottomSheet();
            },
            EdgeInsets.only(left: 5, right: 7),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: body(),
      ),
    );
  }

  appBarLeading() => Padding(
        child: actionButton(Icons.search, () {
          setState(() {
            isSearch = !isSearch;
          });
        }, EdgeInsets.only(left: 5)),
        padding: EdgeInsets.all(5),
      );

  actionButton(IconData icon, Function onPressed, dynamic margin) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 1, color: Colors.grey, spreadRadius: 0.4)
          ],
        ),
        child: CircleAvatar(
          backgroundColor: CustomColors.white,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: CustomColors.orange,
              size: 25,
            ),
          ),
        ),
      );

  body() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView.separated(
          builderDelegate: PagedChildBuilderDelegate<TherapistListInfo>(
            itemBuilder: (context, therapist, index) => Container(
              child: TherapistListCard(therapist),
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

  _showCupertinoModalBottomSheet() => showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: FilterSheet(_dateController),
        ),
      );
}
