import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}

class FirebaseNotificationService {
  final firebaseMessaging = FirebaseMessaging.instance;
  final cloudFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> initNotifications() async {
    final notificationSettings = await firebaseMessaging.requestPermission();
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      final token = await firebaseMessaging.getToken();
      final userId = firebaseAuth.currentUser?.uid;

      //Recobe una top levele function, es decir una funcion fuer ade la clase
      //onBackgroundMessage muestra noyificaciones si la aplicacion esta en segundo plano
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

      if (userId != null) {
        await cloudFirestore.collection('users').doc(userId).update({
          'fcmToken': token,
        });
      }
      print(token);
    }
  }
}
