import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'main.freezed.dart';

void main() => runApp(
      ProviderScope(
        child: RiverpodExperimentApp(),
      ),
    );

@freezed
abstract class SampleState with _$SampleState {
  //
  factory SampleState({
    @Default(0) int counter1,
    @Default(0) int counter2,
  }) = _SampleState;
}

class CounterCtrl extends StateNotifier<SampleState> {
  CounterCtrl() : super(SampleState()) {
    print('CounterCtrl initialize');
  }

  @override
  void dispose() {
    print('CounterCtrl dispose');
    super.dispose();
  }

  void inc1() => state = state.copyWith(counter1: state.counter1 + 1);
  void inc2() => state = state.copyWith(counter2: state.counter2 + 1);

  static final computed1 = Computed<int>((read) {
    final r = read(counterProvider.state).counter1;
    print('Counter 1 Computing...: $r');
    return r;
  });

  static final computed2 = Computed<int>((read) {
    final r = read(counterProvider.state).counter2;
    print('Counter 2 Computing...: $r');
    return r;
  });
}

final counterProvider = StateNotifierProvider((_) => CounterCtrl());

final counterProviderNested = AutoDisposeStateNotifierProvider((_) => CounterCtrl());

final computedNested = Computed<int>((read) {
  final r = read(counterProviderNested.state).counter2;
  print('Counter Nested ...: $r');
  return r;
});

///
/// This is syntax sugar for [StateNotifierProvider] for simple values like enums
/// or booleans.
//final simpleCounterProvider = StateProvider((ref) => 0);

class RiverpodExperimentApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    // This is only possible because MyApp is a HookWidget.
//    final p2 = useProvider(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Example')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer((ctx, read) {
                final int count = read(counterProvider.state).counter1;
                return Text('Counter1 val : $count');
              }),
              Consumer((ctx, read) {
                final int count = read(counterProvider.state).counter2;
                return Text('Counter2 val: $count');
              }),
              Consumer((ctx, read) {
                print('Counter 1 Building...');
                final int count = read(CounterCtrl.computed1);
                return Text('Computed Counter 1: $count');
              }),
              Consumer((ctx, read) {
                print('Counter 2 Building...');
                final int count = read(CounterCtrl.computed2);
                return Text('Computed Counter 2: $count');
              }),
              FlatButton(
                onPressed: () => counterProvider.read(ctx).inc1(),
                child: Text('Inc 1'),
              ),
              FlatButton(
                onPressed: () => counterProvider.read(ctx).inc2(),
                child: Text('Inc 2'),
              ),
              Consumer((ctx, r) {

                return FlatButton(
                  onPressed: () {
                    showDialog(
                      context: ctx,
                      builder: (ctx) => ProviderScope(
                        child: AlertDialog(
                          title: Text('Test'),
                          content: Consumer((ctx, r) {
                            final s = r(computedNested);
                            return Text('Content + $s');
                          }),
                        ),
                      ),
                    );
                  },
                  child: Text('Dialog'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


final exampleProvider = AutoDisposeProvider<String>((ref) {
//  final streamController = StreamController<int>();

  print('creating the provider !');

  ref.onDispose(() {
    print('onDispose()');
    // Closes the StreamController when the state of this provider is destroyed.
//    streamController.close();
  });

  return 'Some provided string';
});

//class CounterWidget extends HookWidget {
//  @override
//  Widget build(BuildContext context) {
//    final count = useProvider(helloWorldProvider.state);
//    return Text('$count');
//  }
//}
