import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../constants/constants.dart';

class AppUtils {
  AppUtils._();

  static String appImageCorrect(String url, {base}) {
    if (url.trim().indexOf('http') != 0) {
      return (base ?? 'AppEndpoint.BASE_URL') + url;
    }
    return url;
  }

  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void toast(String? message, {Duration? duration}) {
    if (message == null) return;
    showOverlayNotification((context) {
      return SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              color: AppColors.instance.appBackground,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Text(
                message,
                textAlign: TextAlign.center, 
              ),
            ),
          ),
        ),
      );
    }, duration: duration ?? Duration(milliseconds: 2000));
  }
 
}
