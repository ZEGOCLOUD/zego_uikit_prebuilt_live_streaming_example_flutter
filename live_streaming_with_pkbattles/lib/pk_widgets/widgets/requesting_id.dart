import 'package:flutter/material.dart';

class PKRequestingID extends StatefulWidget {
  final ValueNotifier<String> requestIDNotifier;

  const PKRequestingID({
    Key? key,
    required this.requestIDNotifier,
  }) : super(key: key);

  @override
  State<PKRequestingID> createState() => _PKRequestingIDState();
}

class _PKRequestingIDState extends State<PKRequestingID> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.requestIDNotifier,
      builder: (context, requestID, _) {
        if (requestID.isEmpty) {
          return Container();
        }
        return Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Text(
            'Request ID:$requestID',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
