// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rada_egerton/resources/constants.dart';
// import 'package:rada_egerton/resources/utils/main.dart';
// import 'package:rada_egerton/widgets/AppBar.dart';
// import 'package:rada_egerton/data/entities/ChatDto.dart';
// import 'package:rada_egerton/providers/ApplicationProvider.dart';
// import 'package:rada_egerton/providers/chat.provider.dart';

// class ChatScreen extends StatelessWidget {
//   ChatScreen({
//     Key? key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final chatsprovider = Provider.of<ChatProvider>(context);
//     final radaProvider = Provider.of<RadaApplicationProvider>(context);

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: SizedBox(
//           child: SafeArea(child: CustomAppBar()),
//         ),
//       ),
//       body: radaProvider.user == null
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             )
//           : Chat<ChatPayload>(
//               currentUserId: radaProvider.user!.id.toString(),
//               chatList: messages,
//               sendMessage: this.widget.sendMessage,
//               reciepient: this.widget.reciepient,
//               groupId: this.widget.groupId,
//             ),
//     );
//   }
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     List<ChatPayload> messages = [];
//     if (widget.mode == ChatModes.PRIVATE) {
//       messages = ServiceUtility.combinePeerMsgs(
//         chatsprovider.privateMessages ?? [],
//         radaProvider.user!.id.toString(),
//       )[widget.chatIndex]
//           .msg;
//     } else if (widget.mode == ChatModes.GROUP) {
//       messages = chatsprovider.groupMessages[widget.chatIndex].messages
//           .map(
//             (msg) => chatsprovider.convertToChatPayload(msg),
//           )
//           .toList();
//     } else if (widget.mode == ChatModes.FORUM) {
//       for (var i = 0; i < chatsprovider.forumMessages.length; i++) {
//         var forum = chatsprovider.forumMessages[i];
//         if (widget.groupId == forum.info.id.toString()) {
//           messages = forum.messages
//               .map(
//                 (msg) => chatsprovider.convertToChatPayload(msg),
//               )
//               .toList();
//           break;
//         }
//       }
//     }

//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: SizedBox(
//           child: SafeArea(
//             child: CustomAppBar(
//               title: this.widget.title,
//               imgUrl: this.widget.imgUrl,
//               groupId: this.widget.groupId,
//               recepientId: widget.reciepient,
//               conversationMode: widget.mode,
//             ),
//           ),
//         ),
//       ),
//       body: radaProvider.user == null
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//               ),
//             )
//           : Chat<ChatPayload>(
//               currentUserId: radaProvider.user!.id.toString(),
//               chatList: messages,
//               sendMessage: this.widget.sendMessage,
//               reciepient: this.widget.reciepient,
//               groupId: this.widget.groupId,
//             ),
//     );
//   }
// }
