import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/widgets/app_bar_widget.dart';
import 'package:remit/providers/auth_provider.dart';
import 'package:remit/providers/wallet_provider.dart';
import 'package:remit/core/entity/TransactionRecord.dart';
import 'package:remit/core/entity/ResponseData.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final titles = ['Home', 'History', 'Exchange Rates', 'Profile'];

    return Scaffold(
      body: CustomScrollView(slivers: _sliversForIndex(titles[_currentIndex])),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
          if (i == 2) {
            _showExchangeRatesSheet();
          }
        },
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(kiHome, color: kcPrimary(context)),
            icon: Icon(kiHome, color: kcOnBackground(context)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(kiHistory, color: kcOnBackground(context)),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(kiExchange, color: kcOnBackground(context)),
            label: 'Exchange',
          ),
          BottomNavigationBarItem(
            icon: Icon(kiProfile, color: kcOnBackground(context)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  List<Widget> _sliversForIndex(String title) {
    final user = ref.watch(authProvider).user;
    switch (_currentIndex) {
      case 1:
        return [
          AppBarWidget(
            title: title,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
              kdSpace.width,
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildTransactionsList(),
            ),
          ),
        ];
      case 2:
        return [
          AppBarWidget(
            title: title,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
              kdSpace.width,
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: ElevatedButton(
                onPressed: _showExchangeRatesSheet,
                child: Text('View exchange rates'),
              ),
            ),
          ),
        ];
      case 3:
        return [
          AppBarWidget(
            title: title,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
              kdSpace.width,
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (user != null) ...[
                    Text('Name: ${user.firstName}'),
                    Text('Email: ${user.email}'),
                    SizedBox(height: 12),
                    ElevatedButton(onPressed: _onLogout, child: Text('Logout')),
                  ] else ...[
                    Text('Not logged in'),
                  ],
                ],
              ),
            ),
          ),
        ];
      case 0:
      default:
        return [
          AppBarWidget(
            title: title,
            automaticallyImplyLeading: false,
            actions: [
              GestureDetector(onTap: _onLogout, child: Icon(kiLogout)),
              kdSpace.width,
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBalanceCard(),
                  SizedBox(height: 16),
                  Expanded(child: _buildTransactionsList()),
                ],
              ),
            ),
          ),
        ];
    }
  }

  Future<void> _onLogout() async {
    final res = await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    if (res.isSuccessful) {
      context.go('/login');
    }
  }

  Widget _buildBalanceCard() {
    final user = ref.watch(authProvider).user;
    final walletRepo = ref.read(walletRepositoryProvider);

    if (user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Please login to see your balance'),
        ),
      );
    }

    return StreamBuilder<double>(
      stream: walletRepo.balanceStream(user.uid ?? ''),
      builder: (context, snap) {
        final balance = snap.data ?? 0.0;
        final formatter = NumberFormat.currency(symbol: 'ETB');
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        formatter.format(balance),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showSendBottomSheet(user.uid ?? ''),
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList() {
    final user = ref.watch(authProvider).user;
    final walletRepo = ref.read(walletRepositoryProvider);

    if (user == null) {
      return Center(child: Text('No transactions'));
    }

    return FutureBuilder(
      future: walletRepo.getTransactionHistory(user.uid ?? ''),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No transactions'));
        }

        final resp = snapshot.data;
        if (resp is! ResponseData || !resp.isSuccessful) {
          final msg = (resp is ResponseData && resp.errorMessages.isNotEmpty)
              ? resp.errorMessages.join('\n')
              : 'Could not load transactions';
          return Center(child: Text(msg));
        }

        final List<TransactionRecord> items =
            resp.data as List<TransactionRecord>;

        if (items.isEmpty) return Center(child: Text('No transactions yet'));

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (context, index) {
            final t = items[index];
            final isSent = (t.type ?? '') == 'sent';
            final amountText =
                (isSent ? '-' : '+') + t.amount.toStringAsFixed(2);
            final date = t.timestamp ?? DateTime.now();
            final dateText = DateFormat.yMMMd().add_jm().format(date);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isSent
                    ? Colors.red.shade100
                    : Colors.green.shade100,
                child: Icon(
                  isSent ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isSent ? Colors.red : Colors.green,
                ),
              ),
              title: Text('${t.currency} $amountText'),
              subtitle: Text('${t.note ?? ''} • $dateText'),
              trailing: Text(
                isSent ? 'Sent' : 'Received',
                style: TextStyle(color: isSent ? Colors.red : Colors.green),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showSendBottomSheet(String fromUserId) async {
    final repo = ref.read(walletRepositoryProvider);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) {
        final toController = TextEditingController();
        final amountController = TextEditingController();

        return SizedBox(
          height: kdScreenHeight(context) * .6,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Money (ETB)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: toController,
                      decoration: InputDecoration(
                        labelText: 'Recipient User Email',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(labelText: 'Amount (ETB)'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final toEmail = toController.text.trim();
                            final amount =
                                double.tryParse(amountController.text.trim()) ??
                                0.0;
                            if (toEmail.isEmpty || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please enter valid recipient and amount',
                                  ),
                                ),
                              );
                              return;
                            }

                            // confirmation
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirm Send'),
                                  content: Text(
                                    'You are about to send ETB ${amount.toStringAsFixed(2)} to $toEmail. Continue?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm != true) return;

                            Navigator.of(context).pop();
                            final res = await repo.sendMoney(
                              fromUserId,
                              toEmail,
                              amount,
                              'ETB',
                              note: 'Sent via app',
                            );
                            if (res.isSuccessful) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sent successfully')),
                              );
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res.errorMessages.join('\n')),
                                ),
                              );
                            }
                          },
                          child: Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double parseDouble(String s) {
    return double.tryParse(s) ?? 0.0;
  }

  Future<void> _showExchangeRatesSheet() async {
    final repo = ref.read(walletRepositoryProvider);
    final pairs = [
      ['USD', 'ETB'],
      ['EUR', 'ETB'],
      ['GHS', 'ETB'],
      ['USD', 'EUR'],
    ];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exchange Rates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.wait(
                  pairs.map((p) async {
                    final res = await repo.getExchangeRate(p[0], p[1]);
                    if (res.isSuccessful) {
                      return {'pair': '${p[0]}_${p[1]}', 'rate': res.data};
                    }
                    return {'pair': '${p[0]}_${p[1]}', 'rate': null};
                  }).toList(),
                ),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  final data = snap.data ?? [];
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      final pair = item['pair'] as String;
                      final rate = item['rate'];
                      return ListTile(
                        title: Text(pair.replaceAll('_', ' -> ')),
                        trailing: rate != null
                            ? Text((rate as double).toStringAsFixed(4))
                            : Text('N/A'),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
