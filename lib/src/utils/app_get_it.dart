import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../base/auth_bloc/auth_bloc.dart'; 

final getIt = GetIt.instance;

void getItSetup() {
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());
  getIt.registerSingleton<AuthBloc>(AuthBloc());
}
