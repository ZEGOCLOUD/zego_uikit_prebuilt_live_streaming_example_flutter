// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
//
// class PKJoinWidget extends StatefulWidget {
//   final ZegoUIKitPrebuiltLiveStreamingController liveController;
//   final ValueNotifier<Map<String, List<String>>>
//       requestingHostsMapRequestIDNotifier;
//
//   const PKJoinWidget({
//     Key? key,
//     required this.liveController,
//     required this.requestingHostsMapRequestIDNotifier,
//   }) : super(key: key);
//
//   @override
//   State<PKJoinWidget> createState() => _PKJoinWidgetState();
// }
//
// class _PKJoinWidgetState extends State<PKJoinWidget> {
//   final requestIDTextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 200,
//           height: 30,
//           child: TextFormField(
//             controller: requestIDTextController,
//             decoration: const InputDecoration(
//               hintText: 'Request ID',
//               // prefixIcon: Icon(Icons.person),
//               // border: Border.all(color: Colors.white),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 30,
//           child: ValueListenableBuilder<TextEditingValue>(
//             valueListenable: requestIDTextController,
//             builder: (context, value, _) {
//               return SizedBox(
//                 width: 90,
//                 child: ElevatedButton(
//                   onPressed: value.text.isEmpty
//                       ? null
//                       : () async {
//                           FocusScope.of(context).unfocus();
//                           await joinPKBattle(
//                             context,
//                             requestIDTextController.text.trim(),
//                           );
//                         },
//                   child: const Text('Join'),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> joinPKBattle(
//     BuildContext context,
//     String requestID,
//   ) async {
//     await widget.liveController.pkV2
//         .join(
//       requestID,
//     )
//         .then((ret) {
//       if (ret.error != null) {
//         showDialog(
//           context: context,
//           builder: (context) {
//             return CupertinoAlertDialog(
//               title: const Text('joinPKBattle failed'),
//               content: Text('Error: ${ret.error}'),
//               actions: [
//                 CupertinoDialogAction(
//                   onPressed: Navigator.of(context).pop,
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     });
//   }
// }
