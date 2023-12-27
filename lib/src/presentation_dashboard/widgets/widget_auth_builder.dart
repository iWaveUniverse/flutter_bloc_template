import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_package_name/src/base/bloc.dart';

class WidgetAuthBuilder extends StatelessWidget {
  final Widget Function(bool logged, bool isUser) builder;
  final Function(bool logged, bool isUser)? listener;
  const WidgetAuthBuilder({
    super.key,
    required this.builder,
    this.listener,
  });

  @override
  Widget build(BuildContext context) {
    if (listener != null) {
      return BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          bool logged = state.stateType == AuthStateType.logged;
          listener!(logged, false);
        },
        builder: (context, state) {
          bool logged = state.stateType == AuthStateType.logged;
          return builder(logged, false);
        },
      );
    }
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        bool logged = state.stateType == AuthStateType.logged;
        return builder(logged, false);
      },
    );
  }
}
