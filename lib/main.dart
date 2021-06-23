import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(onPressed: CustomDrawer.of(context)!.open, icon: Icon(Icons.menu));
        },
      ),
      title: Text('Custom drawer demo'),
    );
    Widget child = HomePage(
      appbar: appbar,
    );
    child = CustomDrawer(child: child);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: child,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.appbar}) : super(key: key);

  final AppBar appbar;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appbar,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static _CustomDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomDrawerState>();

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  static const Duration toggleDuration = Duration(milliseconds: 250);
  static const double maxSlide = 225;
  static const double minDragStartEdge = 60;
  static const double maxDragStartEdge = maxSlide - 16;
  AnimationController? _animationController;
  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: toggleDuration,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void close() => _animationController!.reverse();

  void open() => _animationController!.forward();

  void toggleDrawer() {
    _animationController!.isCompleted ? close() : open();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        _animationController!.isDismissed && details.globalPosition.dx < minDragStartEdge;
    bool isDragCloseFromWrite =
        _animationController!.isCompleted && details.globalPosition.dx > maxDragStartEdge;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromWrite;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      _animationController!.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (_animationController!.isDismissed || _animationController!.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity =
          details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;
      _animationController!.fling(velocity: visualVelocity);
    } else if (_animationController!.value < 0.5) {
      close();
    } else {
      open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_animationController!.isCompleted) {
          close();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: AnimatedBuilder(
          animation: _animationController!,
          child: widget.child,
          builder: (context, child) {
            double animValue = _animationController!.value;
            final slideAmount = maxSlide * animValue;
            final contentScale = 1.0 - (0.3 * animValue);
            return Stack(
              children: [
                MyDrawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slideAmount)
                    ..scale(contentScale),
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () => _animationController!.isCompleted ? close() : null,
                      child: widget.child),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: SafeArea(
        child: Theme(
          data: ThemeData(
            brightness: Brightness.dark,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('MAKH'),
                accountEmail: Text('makh@sth.com'),
                currentAccountPicture: FlutterLogo(),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
              ),
              ListTile(
                leading: Icon(Icons.new_releases),
                title: Text('News'),
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Favorites'),
              ),
              ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
