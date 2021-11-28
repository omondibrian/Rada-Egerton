const BASE_URL = "http://radaegerton.ddns.net";
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
