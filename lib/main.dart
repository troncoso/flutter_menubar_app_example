import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';

// The starting dimensions of the window
const appDimensions = Size(480, 640);

void main() {
  runApp(const MyApp());

  doWhenWindowReady(() {
    trayManager
        // First thing we do is add the icon to the tray
        .setIcon('images/tray_icon_inactive.png')
        // Then we want to get the position of the tray icon
        .then((noValue) {
      var listener = TrayClickListener();
      trayManager.addListener(listener);
      if (kDebugMode) {
        // In dev mode, go ahead and open the app
        // NOTE: It doesn't look like the app is positioned correctly when doing this, but for the sake of development
        // it should be fine
        listener.onTrayIconMouseUp();
      }
    });
  });
}

/// This handles clicking on the tray icon
class TrayClickListener extends TrayListener {
  @override
  void onTrayIconMouseUp() {
    if (appWindow.isVisible) {
      trayManager.setIcon('images/tray_icon_inactive.png').then((noValue) {
        appWindow.hide();
      });
    } else {
      trayManager
          .setIcon('images/tray_icon_active.png')
          // Get the tray icon position so we can properly place the window
          .then((noValue) => trayManager.getBounds())
          .then((rect) {
        // Set these all the same so the window can't resize
        appWindow.minSize = appDimensions;
        appWindow.maxSize = appDimensions;
        appWindow.size = appDimensions;

        // I have found that the left/top properties can be mixed depending on
        // when the getBounds method is called. We know for a fact that the y
        // position should always be close to zero (if not zero), so we can assume
        // the smaller number is always the y value
        var x = rect.left > rect.top ? rect.left : rect.top;
        var y = x == rect.left ? rect.top : rect.left;

        // Set the position so the icon is above the middle of the window
        appWindow.position = Offset(x - (appDimensions.width / 2), y + 4);
        appWindow.title = 'Flutter Menubar App';
        appWindow.show();
      });
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
