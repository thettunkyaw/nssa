// Dart: Properties & Libraries
import 'dart:io';
import 'dart:async';

// Flutter: Existing Libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Flutter: External Libraries (Dependencies)
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:connectivity/connectivity.dart';

// Pages
import './splash.page.dart';

// HomePage StatelessWidget Class
class HomePage extends StatefulWidget {
  // Static Final Class Properties
  static final String routeName = "/";

  @override
  _HomePageState createState() => _HomePageState();
}

// _HomePageState State Class
class _HomePageState extends State<HomePage> {
  // Static Class Properties
  static bool isStart = true;
  // Normal Class Properties
  InAppWebViewController webView;
  String url = "";
  int scrollPosition = 0;
  double progress = 0;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Private Class Properties
  bool _isLoading = true;

  // Final Class Properties
  final Connectivity _connectivity = new Connectivity();

  // Future Class Methods
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print("[home.page.dart: 91] => The connectivity result is $result.");
    if (result == ConnectivityResult.none && isStart == true) {
      print("This is the way 01");
      setState(() {
        this._isLoading = true;
      });
    } else if (result != ConnectivityResult.none && isStart != true) {
      print("This is the way 02");
      this.webView.reload();
    } else {
      print("This is the way 03");
      // Future.delayed(
      //   Duration(
      //     seconds: 3,
      //   ),
      //   () {
      //     this._isLoading = false;
      //   },
      // );

      // Future.delayed(
      //   Duration(
      //     seconds: 3,
      //   ),
      //   () {
      //     setState(
      //       () {
      //         this._isLoading = false;
      //         isStart = false;
      //       },
      //     );
      //   },
      // );
    }
  }

  // Lifecycle Hook Methods
  @override
  void initState() {
    super.initState();
    this.initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future Class Methods
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // Widget Class Properties
  Widget mainPage() {
    return WillPopScope(
      onWillPop: this._onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Container(
          padding: EdgeInsets.only(
            bottom: 60.0,
          ),
          child: (this.scrollPosition != 0)
              ? FloatingActionButton(
                  child: Icon(
                    Icons.arrow_upward_rounded,
                  ),
                  onPressed: () {
                    this.webView.scrollTo(
                          x: 0,
                          y: 0,
                          animated: true,
                        );
                    setState(
                      () {
                        this.scrollPosition = 0;
                      },
                    );
                  },
                )
              : null,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ),
              InAppWebView(
                initialUrl: "https://www.nssa.gov.mm",
                onWebViewCreated: (InAppWebViewController controller) {
                  this.webView = controller;
                  if (this.webView != null) {
                    // Future.delayed(
                    //   Duration(
                    //     seconds: 3,
                    //   ),
                    //   () {
                    //     this._isLoading = false;
                    //   },
                    // );
                    print("The webview is not null!");
                  }
                  print(
                    "[home.page.dart: 128] => The webview is ${this.webView}.",
                  );
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  setState(() {
                    this.url = url;
                    // this._isLoading = true;
                  });
                },
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                  await Future.delayed(
                    Duration(
                      seconds: 3,
                    ),
                    () {
                      setState(() {
                        this._isLoading = false;
                        this.url = url;
                      });
                    },
                  );
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(
                    () {
                      this.progress = progress / 100;
                    },
                  );
                },
                onScrollChanged:
                    (InAppWebViewController controller, int x, int y) {
                  setState(
                    () {
                      this.scrollPosition = y;
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  alignment: Alignment.bottomCenter,
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              this.webView.canGoBack().then(
                                (value) {
                                  if (value) {
                                    this.webView.goBack();
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "You are in home page",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.grey,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(
                              (Platform.isIOS)
                                  ? Icons.arrow_back_ios_outlined
                                  : Icons.arrow_back_outlined,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              this.webView.canGoForward().then(
                                (value) {
                                  if (value) {
                                    this.webView.goForward();
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "No Forward History",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.grey,
                                    );
                                  }
                                },
                              );
                            },
                            icon: Icon(
                              (Platform.isIOS)
                                  ? Icons.arrow_forward_ios_outlined
                                  : Icons.arrow_forward_outlined,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Share.share(
                                this.url,
                              );
                            },
                            icon: Icon(
                              Icons.share_outlined,
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              this.webView.reload();
                              Fluttertoast.showToast(
                                msg: "Reloading",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.grey,
                              );
                            },
                            icon: Icon(
                              Icons.replay_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Returning Widgets
    return SafeArea(
      child: Stack(
        children: [
          mainPage(),
          if (this._isLoading == true) SplashPage(),
        ],
      ),
    );
  }
}
