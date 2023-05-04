import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../base/bloc.dart';
import '../../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthBloc>().add(const AuthLoaded(true));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: Get.find<AuthBloc>(),
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 1), () async {
          if (state.stateType == AuthStateType.logged) {
            Get.offAllNamed(Routes.nav);
          } else if (state.stateType == AuthStateType.logged_out) {
            Get.offAllNamed(Routes.login);
          }
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _buildLogo(context),
              _buildPoweredBy(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterLogo(
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildPoweredBy() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            CupertinoActivityIndicator(
              radius: 15,
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
