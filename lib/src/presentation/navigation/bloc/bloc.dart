import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event.dart';

part 'state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState()) {
    on<NavigationInit>(_onInit);
    on<NavigationChangeTab>(_onChangeTab);
  }

  _onInit(NavigationInit event, Emitter<NavigationState> emit) async {}

  _onChangeTab(NavigationChangeTab event, Emitter<NavigationState> emit) async {
    emit(state.update(currentTab: event.currentTab));
  }
}
