// ignore_for_file: constant_identifier_names

class AppRoutes {
  static const welcome = "/welcome";
  static const login = "/login";
  static const register = "/signup";
  static const terms = "/terms";
  static const splash = "/";

  static const dashboard = "/app";
  static const help = "help";
  static const counseling = "counseling";
  static const counselingMessages = "counseling-messages";
  static const information = "information";
  static const informationDetails = "information-details";
  static const notification = "notification";
  static const mentorship = "mentorship";
  static const forum = "forum";
  static const forumMessages = "forum-messages";
  static const connectionError = "connectionError";
  static const peerChat = "peer-chat";
  static const privateChat = "private-chat";
  static const profile = "profile";
  static const viewProfile = "view-profile";
  static const contributors = "contributors";
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
