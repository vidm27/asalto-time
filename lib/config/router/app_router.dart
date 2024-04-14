

import 'package:go_router/go_router.dart';
import 'package:asalto_time/timer/pages/pages.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/',name: HomeScreen.name, builder: (context, state) => const HomeScreen()),
  GoRoute(path: '/config-round',name: ConfigRoundPage.name, builder: (context, state) => const ConfigRoundPage()),
]);