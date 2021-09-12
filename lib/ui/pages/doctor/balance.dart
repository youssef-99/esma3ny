import 'package:esma3ny/data/models/therapist/balance.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:esma3ny/ui/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final _pagingController = PagingController<int, Transaction>(
    firstPageKey: 1,
  );

  final format = DateFormat('dd-MM-yyyy');

  TherapistRepository _therapistRepository = TherapistRepository();

  BalanceAmount _balanceAmount;

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await _therapistRepository.getBalance(pageKey);

      final isLastPage = newPage['current_page'] == newPage['last_page'];
      List<Transaction> newPageDecoded = [];
      setState(() {
        _balanceAmount = BalanceAmount.fromJson(newPage['balance']);
      });

      newPage['transactions']['data'].forEach((transaction) {
        newPageDecoded.add(Transaction.fromJson(transaction));
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
          AppLocalizations.of(context).balance,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Column(
          children: [
            _balanceAmount == null
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      balanceBox(
                        CustomColors.lightBlue,
                        _balanceAmount.egp / 100,
                        AppLocalizations.of(context).egp,
                      ),
                      balanceBox(
                        CustomColors.orange,
                        _balanceAmount.usd / 100,
                        AppLocalizations.of(context).usd,
                      )
                    ],
                  ),
            Expanded(
              child: PagedListView.separated(
                builderDelegate: PagedChildBuilderDelegate<Transaction>(
                  itemBuilder: (context, transaction, index) => Container(
                    child: ListTile(
                      title: Text(
                        '${transaction.amount / 100} ${transaction.currency}',
                      ),
                      subtitle: Container(
                        child: Text(
                          transaction.transferred
                              ? AppLocalizations.of(context).pending
                              : AppLocalizations.of(context).transferred,
                          style: TextStyle(
                            color: transaction.transferred
                                ? CustomColors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                      trailing: Text(
                          format.format(DateTime.parse(transaction.createdAt))),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                    error: _pagingController.error,
                    onTryAgain: () => _pagingController.refresh(),
                  ),
                  noItemsFoundIndicatorBuilder: (context) =>
                      EmptyListIndicator(),
                ),
                pagingController: _pagingController,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  balanceBox(color, balance, currency) => Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '$balance $currency',
          style: TextStyle(color: Colors.white),
        ),
      );
}
