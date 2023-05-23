import 'package:_imagineeringwithus_pack/setup/app_base.dart';
import 'package:_imagineeringwithus_pack/setup/app_setup.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart'; 

imagineeringwithusPackSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
    ),
  );
}

// const FirebaseOptions firebaseOptionsPREPROD = FirebaseOptions(
//   apiKey: "AIzaSyAspDIIOG7HZC22Sru_W9a3wpTqOMttF-4",
//   authDomain: "imagineeringwithus-9ac4a.firebaseapp.com",
//   projectId: "imagineeringwithus-9ac4a",
//   storageBucket: "imagineeringwithus-9ac4a.appspot.com",
//   messagingSenderId: "407743117038",
//   appId: "1:407743117038:web:f43448be6c3589425c65ff",
//   measurementId: "G-HCLPLZR57T",
// );
