import 'package:_imagineeringwithus_pack/setup/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  Future<void> onEvent(Bloc bloc, Object? event) async {
    super.onEvent(bloc, event);
    appDebugPrint('[BlocObserver] onEvent: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    appDebugPrint(
        '[BlocObserver][Transition] ${transition.event} => ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    appDebugPrint('[BlocObserver] onError: $error');
    super.onError(bloc, error, stackTrace);
  }
}
