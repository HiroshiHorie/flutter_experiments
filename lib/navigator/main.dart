import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';

//
// Experiment if removing a Navigator widget from the widget tree
// doesn't cause any issues
//

void main() => runApp(NavigatorExperimentApp());

class AppStateController extends StateNotifier<bool> {
  AppStateController() : super(false);
  set updateState(bool newState) => state = newState;
}

class NavigatorExperimentApp extends StatelessWidget {
  final appStateNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    //
    // MaterialApp already has a Navigator
    //
    return MaterialApp(
      title: 'Navigator Experiment',
      home: StateNotifierProvider<AppStateController, bool>(
        create: (_) => AppStateController(),
        child: Consumer2<AppStateController, bool>(
          builder: (ctx, ctrl, state, _) => Scaffold(
            appBar: AppBar(
              title: Text('Example'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Text('Toggle'),
              onPressed: () => ctrl.updateState = !state,
            ),
            body: state ? SubNavigator() : Center(child: Text('FALSE')),
          ),
        ),
      ),
    );
  }
}

//
// Sub-Navigator
//
class SubNavigator extends StatelessWidget {
  //
  Route<dynamic> generateRoute(RouteSettings settings) {
    //
    //
    return MaterialPageRoute(
      builder: (ctx) => ChildPage(
        depth: ((settings.arguments as int) ?? 0) + 1,
      ),
    );
  }

  //
  // Provide a value accessible by all widgets below this Navigator
  //
  @override
  Widget build(BuildContext ctx) => Provider<String>(
        create: (_) => 'This is a provided string',
        child: Navigator(onGenerateRoute: generateRoute),
      );
}

class ChildPage extends StatelessWidget {
  ChildPage({Key key, @required this.depth}) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('$depth'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.select<String, String>((value) => value)),
              RaisedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/',
                  arguments: depth,
                ),
                child: Text('Push'),
              ),
              //
              // Control AppState from here
              //
              RaisedButton(
                onPressed: () => context.read<AppStateController>().updateState = false,
                child: Text('Bye'),
              ),
            ],
          ),
        ),
      );
}
