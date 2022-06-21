import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rada_egerton/screens/chat/bloc/bloc.dart';

import 'app.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ChatBloc(),
      child: RadaApp(),
    ),
  );
}
