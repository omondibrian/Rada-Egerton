class AppRoutes {
  static const dashboard = "/welcome";
  static const welcome = "/";
  static const help = "/app/help";
  static const login = "/login";
  static const register = "/signup";
  static const counseling = "/app/counseling";
  static const counselingMessages = "/app/counseling/messages";
  static const information = "/app/information";
  static const informationDetails = "/app/information/details";
  static const notification = "/app/notification";
  static const mentorship = "/app/mentorship";
  static const forum = "/app/forum";

  static const forumMessages = "/app/forum/messages";

  static const connectionError = "/connectionError";
  static const terms = "/terms";
  static const splash = "/splash";
  static const peerChat = "/peer/chat/";
  static const profile = "/app/profile";
  static const viewProfile = "/app/view-profile";
  static const contributors = "/app/contributors";
}

class ChatEvent {
  static const String CONNECT = "connect";
  static const String DISCONNECT = "disconnect";
  static const String newChat = "newChat"; //when a new chat is posted
  static const String typing = "typing"; //when posting a new chat
  static const String FETCH_CHATS = "FETCH_CHATS";
  static const String CHATS = "CHATS";
  static const String CHAT = "CHAT";
  static const String online = "online";
  static const String USER = 'USER';
}

enum ChatModes { PRIVATE, FORUM, GROUP }
