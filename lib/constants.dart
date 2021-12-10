class AppRoutes {
  static const dashboard = "/welcome";
  static const welcome = "/";
  static const help = "/help";
  static const login = "/login";
  static const register = "/signup";
  static const counseling = "/counseling";
  static const information = "/information";
  static const informationDetails = "/information/details";
  static const notification = "/notification";
  static const mentorship = "/mentorship";
  static const forum = "/forum";
  static const connectionError = "/connectionError";
  static const terms = "/terms";
  static const splash = "/splash";
  // static const chat = "/chat";
  static const profile = "/profile";
  static const viewProfile = "/view-profile";
  static const contributors = "/contributors";
}

const BASE_URL = "http://radaegerton.ddns.net";
const IMAGE_URL = "$BASE_URL/api/v1/uploads/";
const APP_KEY = "";

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

class ChatModes {
  static const String PRIVATE = "PRIVATE";
  static const String FORUM = "FORUM";
  static const String GROUP = "GROUP";
}
