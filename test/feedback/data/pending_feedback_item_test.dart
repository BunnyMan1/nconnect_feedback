// import 'package:test/test.dart';
// import 'package:wiredash/src/common/device_info/device_info.dart';
// import 'package:wiredash/src/feedback/data/feedback_item.dart';
// import 'package:wiredash/src/feedback/data/pending_feedback_item.dart';

// void main() {
//   group('PendingFeedbackItem', () {
//     test('Full fromJson()', () {
//       expect(
//         PendingFeedbackItem.fromJson({
//           'id': 'abc123',
//           'screenshotPath': 'path/to/file.png',
//           'feedbackItem': {
//             'deviceInfo': {
//               'padding': [0, 66, 0, 0],
//               'physicalSize': [1080, 2088],
//               'viewInsets': [0, 0, 0, 685],
//               'appIsDebug': true,
//               'deviceId': '8F821AB6-B3A7-41BA-882E-32D8367243C1',
//               'locale': 'en_US',
//               'pixelRatio': 2.75,
//               'platformOS': 'android',
//               'platformOSBuild': 'RSR1.201013.001',
//               'platformVersion':
//                   '2.10.2 (stable) (Tue Oct 13 15:50:27 2020 +0200) on "android_ia32"',
//               'textScaleFactor': 1
//             },
//             'email': 'email@example.com',
//             'message': 'Hello world!',
//             'type': 'bug',
//             'user': 'Testy McTestFace',
//             'sdkVersion': 1
//           },
//         }),
//         const PendingFeedbackItem(
//           id: 'abc123',
//           screenshotPath: 'path/to/file.png',
//           feedbackItem: FeedbackItem(
//             deviceInfo: DeviceInfo(
//               padding: [0, 66, 0, 0],
//               physicalSize: [1080, 2088],
//               viewInsets: [0, 0, 0, 685],
//               appIsDebug: true,
//               deviceId: "8F821AB6-B3A7-41BA-882E-32D8367243C1",
//               locale: "en_US",
//               pixelRatio: 2.75,
//               platformOS: "android",
//               platformOSBuild: "RSR1.201013.001",
//               platformVersion:
//                   '2.10.2 (stable) (Tue Oct 13 15:50:27 2020 +0200) on "android_ia32"',
//               textScaleFactor: 1,
//             ),
//             email: 'email@example.com',
//             message: 'Hello world!',
//             type: 'bug',
//             user: 'Testy McTestFace',
//             sdkVersion: 1,
//           ),
//         ),
//       );
//     });

//     test('Minimal fromJson()', () {
//       expect(
//         PendingFeedbackItem.fromJson({
//           'id': 'abc123',
//           'feedbackItem': {
//             'deviceInfo': <String, dynamic>{},
//             'message': 'Hello world!',
//             'type': 'bug',
//             'sdkVersion': 1
//           },
//         }),
//         const PendingFeedbackItem(
//           id: 'abc123',
//           feedbackItem: FeedbackItem(
//             deviceInfo: DeviceInfo(),
//             message: 'Hello world!',
//             type: 'bug',
//             sdkVersion: 1,
//           ),
//         ),
//       );
//     });

//     test('toJson()', () {
//       expect(
//         const PendingFeedbackItem(
//           id: 'abc123',
//           screenshotPath: 'path/to/file.png',
//           feedbackItem: FeedbackItem(
//             deviceInfo: DeviceInfo(
//               padding: [0, 66, 0, 0],
//               physicalSize: [1080, 2088],
//               viewInsets: [0, 0, 0, 685],
//               appIsDebug: true,
//               deviceId: "8F821AB6-B3A7-41BA-882E-32D8367243C1",
//               locale: "en_US",
//               pixelRatio: 2.75,
//               platformOS: "android",
//               platformOSBuild: "RSR1.201013.001",
//               platformVersion:
//                   '2.10.2 (stable) (Tue Oct 13 15:50:27 2020 +0200) on "android_ia32"',
//               textScaleFactor: 1,
//             ),
//             email: 'email@example.com',
//             message: 'Hello world!',
//             type: 'bug',
//             user: 'Testy McTestFace',
//             sdkVersion: 1,
//           ),
//         ).toJson(),
//         {
//           'id': 'abc123',
//           'screenshotPath': 'path/to/file.png',
//           'feedbackItem': {
//             'deviceInfo': {
//               'padding': [0, 66, 0, 0],
//               'physicalSize': [1080, 2088],
//               'viewInsets': [0, 0, 0, 685],
//               'appIsDebug': true,
//               'deviceId': '8F821AB6-B3A7-41BA-882E-32D8367243C1',
//               'locale': 'en_US',
//               'pixelRatio': 2.75,
//               'platformOS': 'android',
//               'platformOSBuild': 'RSR1.201013.001',
//               'platformVersion':
//                   '2.10.2 (stable) (Tue Oct 13 15:50:27 2020 +0200) on "android_ia32"',
//               'textScaleFactor': 1
//             },
//             'email': 'email@example.com',
//             'message': 'Hello world!',
//             'type': 'bug',
//             'user': 'Testy McTestFace',
//             'sdkVersion': 1,
//           },
//         },
//       );
//     });
//   });
// }
