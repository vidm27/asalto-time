

import 'package:asalto_time/timer/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/',name: HomeScreen.name, builder: (context, state) => HomeScreen())
]);