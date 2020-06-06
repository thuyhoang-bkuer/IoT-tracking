// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app/models/_.dart';
// import 'package:tracking_app/widgets/sliding_card.dart';

// class DevicesScreen extends StatefulWidget {
//   final Color primaryColor = const Color(0xFFF4B400);

//   @override
//   _DevicesScreenState createState() => _DevicesScreenState();
// }

// class _DevicesScreenState extends State<DevicesScreen> {
  
//   @override
//   Widget build(BuildContext context) {
//     final state = Provider.of<HomeBloc>(context);
    
//     return Scaffold(
//       body: Container(
//           margin: const EdgeInsets.only(top: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Text(
//                       "Devices",
//                       style: TextStyle(
//                         color: widget.primaryColor,
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: state.getDevices.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(
//                       left: 20.0,
//                       right: 20.0,
//                       bottom: 20.0,
//                     ),
//                     child: SlidingCard(
//                       index: index,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       floatingActionButton: FloatingActionButton(
//         elevation: 2,
//         highlightElevation: 0,
//         focusColor: Color(0xAAF4B400),
//         backgroundColor: widget.primaryColor,
//         child: Icon(Icons.add),
//         onPressed: () => null,
//       ),
//     );
//   }
// }
