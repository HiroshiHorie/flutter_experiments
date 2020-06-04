//
// Experiment of using flutter_portal package
//
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:state_notifier/state_notifier.dart';

//part 'main.freezed.dart';

void main() => runApp(PortalExperimentApp());

//class Example extends StatelessWidget {
//  const Example({Key key, this.title}) : super(key: key);
//  final String title;
//
//  @override
//  Widget build(BuildContext context) {
//    return PortalEntry(
//      //      visible: false,
//      portal: Stack(
//        children: [
//          AnimatedPositioned(
//              top: 0,
//              duration: Duration(milliseconds: 300),
//              child: Card(
//                child: Padding(
//                  child: Text(title),
//                  padding: EdgeInsets.symmetric(
//                    vertical: 10,
//                    horizontal: 10,
//                  ),
//                ),
//                elevation: 10,
//              )),
//        ],
//      ),
//      child: const Text('the child'),
////      portalAnchor: Alignment.topCenter,
////      childAnchor: Alignment.topCenter,
//    );
//  }
//}

//class Example extends StatefulWidget {
//  const Example({Key key, this.title}) : super(key: key);
//
//  final String title;
//  @override
//  _ExampleState createState() => _ExampleState();
//}

//@freezed
//abstract class BannerState with _$BannerState {
//  //
//  //
//  //
//  factory BannerState({
//    @Default(false) bool dismissing,
//  }) = _BannerState;
//}

enum BannerState {
  showing,
  idle,
  dismissing,
}

typedef OnBannerDismiss = Function();

class BannerStateController extends StateNotifier<BannerState> implements TickerProvider {
  //
  //
  //
  final dismissTimerDuration;
  final animationDuration;
  OnBannerDismiss onDismiss;

//  GestureTapCallback onTap;

  Timer _timer;
  Set<Ticker> _tickers = {};
  AnimationController _showAnimationCtrl;
  AnimationController _dismissAnimationCtrl;

  //
  Animation<Offset> _offsetAnimation;
  Animation<double> _opacityAnimation;

  Animation<Offset> get offsetAnimation => _offsetAnimation;
  Animation<double> get opacityAnimation => _opacityAnimation;

//  GestureTapCallback get onTap => () {
//        print('did tap');
//        dismiss();
//      };

  BannerStateController({
    this.animationDuration = const Duration(seconds: 1),
    this.dismissTimerDuration = const Duration(seconds: 2),
    this.onDismiss,
  }) : super(BannerState.showing) {
    //
    //
    _showAnimationCtrl = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _dismissAnimationCtrl = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -0.2),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _showAnimationCtrl,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _dismissAnimationCtrl,
      curve: Curves.easeOutCirc,
    ));

    show();
  }

  void dispose() {
    _showAnimationCtrl?.dispose();
    _dismissAnimationCtrl?.dispose();
    _tickers?.forEach((element) => element.dispose());
    print('${runtimeType}.dispose();');
    super.dispose();
  }

  Future<void> show() async {
    await _showAnimationCtrl.forward();
    state = BannerState.idle;
//    print('start timer');
    _timer = Timer(dismissTimerDuration, _onTimer);
  }

  Future<void> dismiss() async {
//    if (_animationCtrl.isAnimating) return;
    if (!mounted) return;
    state = BannerState.dismissing;

    await _dismissAnimationCtrl.forward();

    //dispose();

    if (onDismiss != null) onDismiss();
  }

  void pauseTimer() {
//    if (_animationCtrl.isAnimating) return;
    print('pause');
    _timer?.cancel();
  }

  void restartTimer() {
//    if (_animationCtrl.isAnimating) return;

    print('restart');
    _timer?.cancel();
    _timer = Timer(dismissTimerDuration, _onTimer);
  }

  void _onTimer() async {
    _timer.cancel();
    await dismiss();
  }

  @override
  Ticker createTicker(onTick) {
    final ticker = Ticker(onTick, debugLabel: kDebugMode ? 'created by $this' : null);
    _tickers.add(ticker);
    return ticker;
  }
}

class Banner extends StatelessWidget {
  //
  //
  //
//  static int bannerCount = 0;
  static show(
    BuildContext ctx, {
    String title,
    String message,
  }) {
    //
    //
    //

    BannerStateController ctrl = BannerStateController();

    final entry = OverlayEntry(
      opaque: false,
      builder: (_) => Banner(
        title: title,
        message: message,
        controller: ctrl,
        onTap: () {
          print('did tap');
          ctrl.dismiss();
        },
      ),
    );

    ctrl.onDismiss = () {
      entry.remove();
      ctrl.dispose();
    };

    Overlay.of(ctx).insert(entry);
  }

  final String title;
  final String message;
  final BannerStateController controller;
  final GestureTapCallback onTap;

  Banner({
    Key key,
    this.title,
    this.message,
    this.onTap,
    this.controller,
  }) : super(key: key) {
//  @override
//  void initState() {
//    super.initState();
  }

//  @override
//  void dispose() {
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      entry.remove();
//    });
//    super.dispose();
//  }

//  @override
//  void didUpdateWidget(Example oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      entry.markNeedsBuild();
//    });
//  }

  @override
  Widget build(BuildContext ctx) => StateNotifierProvider<BannerStateController, BannerState>.value(
        value: controller,
        child: Consumer<BannerStateController>(
          builder: (ctx, ctrl, _) => FadeTransition(
            opacity: ctrl.opacityAnimation,
            child: SlideTransition(
              position: ctrl.offsetAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child:
//                  ClipRRect(
//                    borderRadius: BorderRadius.circular(16),
//                    clipBehavior: Clip.hardEdge,
//                    child:
                      Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        )
                      ],
                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Material(
                      //                        borderRadius: BorderRadius.circular(30),
//                        clipBehavior: Clip.hardEdge,
                      type: MaterialType.transparency,
                      child: Consumer<BannerState>(
                        // selector: (_, state) => state.dismissing,
                        builder: (ctx, state, _) => InkWell(
                          borderRadius: BorderRadius.circular(16),
                          //                          borderRadius: BorderRadius.circular(16),
                          onTap: state == BannerState.idle ? () => ctrl.dismiss() : null,
                          onTapDown: (f) => ctrl.pauseTimer(),
//                        onLongPress: () => print('long press'),
                          onTapCancel: () => ctrl.restartTimer(),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  width: 70,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            message,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
//            ),
          ),
        ),
      );
}

class PortalExperimentApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) => MaterialApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            appBar: AppBar(
              title: Text('Notification banner'),
              actions: [],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaisedButton(
                    child: Text('Show banner'),
                    onPressed: () => Banner.show(
                      ctx,
                      title: 'Hiroshi',
                      message: 'Hello how are you?',
                    ),
                  ),
                  RaisedButton(
                    child: Text('Show banner 2'),
                    onPressed: () => Banner.show(
                      ctx,
                      title: 'Hiroshi long text test long text test',
                      message:
                          'This is a long text test. This is a long text test. This is a long text test. This is a long text test. This is a long text test. This is a long text test. This is a long text test. ',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
