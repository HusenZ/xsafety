// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart' as auth;


// class PushNotificationService {
//   static Future<String> getAccessToken() async {
//     final serviceAccountJson = {
//       "type": "service_account",
//       "project_id": "xsafety-57071",
//       "private_key_id": "5b124e4229e233c1de223979845e76a980564e29",
//       "private_key":
//           "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCzj++ARQ/EqLxH\nzx2qKr3aq9XS25Km4Ord14raRjM5r7QIGj+NuvJMi1buY+6F4tHeyAR1Z/DjB/z+\nAF5ZpJZRJ6tUpDxzNvqWqnnES9RadW5fCaM3Rqgs5liZZcsV4+ZBw9tiKG/QHhrn\nvR87eZwSifZ9pW5v98pQzZSZuNvx+rNoeAw5RMrv/c+FJNfmWqL1a60G6BtvPW00\n5Z+/Awmssx1nO+pwLpL5SQJQubx8t00uf5yXl8PAnYz63KxuAA78lQYig4kjCNP0\n26oCTud0Fkd1dygGVi45gREQBE+eP2WgBiwIOuwTONLiBu4NgFOqtgs/cIPZeuRm\nsfqqC6F5AgMBAAECggEAJNyEvGaRCtxf0HcEfjkpgeE6Mz/nnnH4TSPRKad1Hx/C\ne9JVnyUUViHZrfUeU2ZhkpQplCeLFDRA26zcMZdf01erLKRNk5JjBXiIKEOv24UV\nbBWop7GN1y/PWuhCdWM0UuZf3En0UDtJ5y5UIcvAfi7LxvXl0r8Bza4yVg9UuZsX\nNOoMH5C/1QwtMa+Li70r7VT95Ds9BzeW7f+8D2MQD7Jn8WYX8umG3HVCEhG5+/LG\n1j8r+qKo0VinJW26E6AjdZVSXBMCHuMj0PvhhwMQB7xRBitSEJcXJVNbJ8+GUtXT\nC+NMGASOmZuvHj77JLOhgEDIkOVzB5x4idvFhbX9/QKBgQDkCt6w1T3h5zvjGKN7\nly79b6uZV/dlPBVwm1A2B/RGUaQ9rv1S+BBpe8AgciiihpxGf+kvNXfB9PgKZLKy\n6Dh2QI8xgosdkAVb90jF59vIDlwRBx0hyXaYQMu1zOmuf91JrEJBFq5MSnCQ8DxN\n8urfIrJet34PJCvqnd8icIW9RQKBgQDJk4KvKi8Px4YqcHCJCMbGciN5x4gdIPLi\nyCR0ua0sZ7oJ+u2O9XFEX2f2isGkJmTg4dIcCqecrgZmzwXCX04vld7o2VowGpCt\ncWieqYBq8p6X07GceyPatlo7JOmU7dbwhWtVIQCt60jOt1IkKRZqJh5dR7ZniiNs\nFI8sW6ZUpQKBgQCwAUu7Q/pNHwFz15JmU1trNANHiUNimSsbDGSuLxl0JJMVILhY\njylroJ267SE7v5ViPFsnmqbhxkajDvF1cBIUAuQCHHVuzbe1MXizdq6FC8A3TDxJ\n1Yp5HJmdqZg6nGmY8SD5x52jOFkFJMYGi5SHv+nXfNwIp6xVmp+bnyk52QKBgHb4\ncPEhXJVblXwG0OSQIYGObBG8CkHm6HOg3KNn0yWaMtshFoSBqFBKXvnL+23+mxt/\nLJsQTszSiUS0exm1VlgPhHi5j9lEVI+Jl83NDNYSTDgf4XwR0Z+McMTnjFUx6uIa\nXLbpu5TqgRZAbGKbPXd4+ALmCGojxbRMjhQII6thAoGBALzAJGNyB3z7iOtwYdHc\nDDGp9GWXJzVhG/vAZ03YO0X1dqfRBOMy/z9O3eTFPuDf3dbodXt8+9mSIdTx6QG6\n1t0Tc57ckXzglbRKKvvql328xstmuYiTYy0vC52OtfWZUn02LxlsfLRdIA+dSWJn\n57Q+RuPNt9jwRDe2cQZ4aha9\n-----END PRIVATE KEY-----\n",
//       "client_email":
//           "firebase-adminsdk-fbsvc@xsafety-57071.iam.gserviceaccount.com",
//       "client_id": "114571674496215714188",
//       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//       "token_uri": "https://oauth2.googleapis.com/token",
//       "auth_provider_x509_cert_url":
//           "https://www.googleapis.com/oauth2/v1/certs",
//       "client_x509_cert_url":
//           "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40xsafety-57071.iam.gserviceaccount.com",
//       "universe_domain": "googleapis.com",
//     };

//     List<String> scopes = [
//       "https://www.googleapis.com/auth/userinfo.email",
//       "https://www.googleapis.com/auth/firebase.database",
//       "https://www.googleapis.com/auth/firebase.messaging",
//     ];

//     http.Client client = await auth.clientViaServiceAccount(
//       auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//       scopes,
//     );

//     auth.AccessCredentials credentials = await auth
//         .obtainAccessCredentialsViaServiceAccount(
//           auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
//           scopes,
//           client,
//         );

//     client.close();
//     return credentials.accessToken.data;
//   }

//   static sendNotification(
//     String deviceToken,
//     BuildContext context,
//     String uid,
//   ) async {
//     final String serverAccessTokenKey = await getAccessToken();
//     String endpointFirebaseCloudMessaging =
//         'https://fcm.googleapis.com/v1/projects/xsafety-57071/messages:send';
//     final Map<String, dynamic> message = {
//       'message': {
//         'token': deviceToken,
//         'notification': {
//           'title': 'Emergecy Alert!!',
//           'body': 'Arraive the location as soon as possible',
//         },
//         'data': {'userId': uid},
//       },
//     };
//     final http.Response response = await http.post(
//       Uri.parse(endpointFirebaseCloudMessaging),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $serverAccessTokenKey',
//       },
//       body: jsonEncode(message),
//     );

//     if(response.statusCode== 200){
//       print("-----Notification is been sent----");
//     }else{
//        print("-------Failed---- ${response.statusCode}");
//     }
//   }
// }
