import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radish_app/screen/start_Screen.dart';
import 'package:radish_app/screen/splash_screen.dart';
import 'package:radish_app/router/locations.dart';
import 'package:radish_app/states/user_provider.dart';

final _routerDelegate = BeamerDelegate(guards: [
  BeamGuard(
      pathBlueprints: [
        ...HomeLocation().pathBlueprints,
        ...InputLocation().pathBlueprints,
        ...ItemLocation().pathBlueprints,
      ],
      check: (context, Location) {
        return context.watch<UserProvider>().user != null;
      },
      showPage: BeamPage(child: StartScreen()))
], locationBuilder: BeamerLocationBuilder(
    beamLocations: [HomeLocation(), InputLocation(), ItemLocation()])
  );

void main() {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _initialization,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 900),
          child: _splashLodingWidget(snapshot),
        );
      },
    );
  }
}

StatelessWidget _splashLodingWidget(AsyncSnapshot<Object> snapshot) {
  if (snapshot.hasError) {
    print('에러가 발생하였습니다.');
    return Text('Error');
  } else if (snapshot.hasData) {
    return RadishApp();
  } else {
    return SplashScreen();
  }
}

class RadishApp extends StatelessWidget {
  const RadishApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MaterialApp.router(
        theme: ThemeData(
            hintColor: Colors.grey[350],
            fontFamily: 'DoHyeon',
            primarySwatch: Colors.green,
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    primary: Colors.white,
                    minimumSize: Size(48, 48))),
            textTheme: TextTheme(
                headline5: TextStyle(fontFamily: 'DoHyeon'),
                subtitle1: TextStyle(fontSize: 17, color: Colors.black87),
                subtitle2: TextStyle(fontSize: 13, color: Colors.black38),
                button: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w300)
                ),
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),
                elevation: 2,
                actionsIconTheme: IconThemeData(color: Colors.black)
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.black87,
              unselectedItemColor: Colors.black38,
            )
        ),
        debugShowCheckedModeBanner: false,
        routeInformationParser: BeamerParser(),
        routerDelegate: _routerDelegate,
      ),
    );
  }
}
