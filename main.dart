import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tryApp/widgets/new_transaction.dart';
import 'package:tryApp/widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import './models/transaction.dart';
// import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     // when we have enable only portrait mode
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.lime,
          errorColor: Colors.red,
          fontFamily: 'QuickSand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 25,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _usertransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.6,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Pizza',
    //   amount: 45.2,
    //   date: DateTime.now(),
    // ),
  ];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _usertransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewtransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newtx = Transaction(
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString(),
        title: txTitle);
    setState(() {
      _usertransactions.add(newtx);
    });
  }

  void _startAddNewtransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: Newtransaction(_addNewtransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final medaiquery = MediaQuery.of(context);
    final isLandscape = medaiquery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewtransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewtransaction(context),
              )
            ],
          );
    final txWidgetList = Container(
        height: (medaiquery.size.height -
                appBar.preferredSize.height -
                medaiquery.padding.top) *
            0.7,
        child: TransactionList(_usertransactions, _deleteTransaction));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLandscape)
              Row(
                children: [
                  Text('Show Chart', style: Theme.of(context).textTheme.title),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            if (!isLandscape)
              Container(
                  height: (medaiquery.size.height -
                          appBar.preferredSize.height -
                          medaiquery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txWidgetList,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (medaiquery.size.height -
                              appBar.preferredSize.height -
                              medaiquery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txWidgetList
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewtransaction(context),
                  ),
          );
  }
}
