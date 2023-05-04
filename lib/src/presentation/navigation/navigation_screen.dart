import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'bloc/bloc.dart';
import '../presentation.dart';
import 'widgets/widget_loading.dart';
import 'widgets/widget_welcome.dart';

export 'bloc/bloc.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<NavigationBloc>().add(NavigationInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<NavigationBloc, NavigationState>(
        bloc: Get.find<NavigationBloc>(),
        listener: (_, state) {
          log('listener: $state');
        },
        builder: (_, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Current Tab is: ${state.currentTab.toString()}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: IconButton(
                          onPressed: () {
                            Get.find<NavigationBloc>()
                                .add(NavigationChangeTab(0));
                          },
                          icon: Icon(
                            Icons.settings,
                            color: state.currentTab == 0
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: IconButton(
                          onPressed: () {
                            Get.find<NavigationBloc>()
                                .add(NavigationChangeTab(1));
                          },
                          icon: Icon(
                            Icons.dashboard,
                            color: state.currentTab == 1
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: IconButton(
                          onPressed: () {
                            Get.find<NavigationBloc>()
                                .add(NavigationChangeTab(2));
                          },
                          icon: Icon(
                            Icons.qr_code_2,
                            color: state.currentTab == 2
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
