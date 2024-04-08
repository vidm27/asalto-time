import 'package:asalto_time/timer/provider/timer_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String name = "home_screen";

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final player = AudioPlayer();

  String formatedTime(int timer) {
    final minutes = ((timer ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (timer % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    ref.read(timerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final timer = ref.watch(timerProvider);

    Color getBackground() {
      if (timer.isRunning && timer.isSecondBreak == false) {
        return Colors.red;
      } else if (timer.isRunning && timer.isSecondBreak) {
        return Colors.green;
      }
      return Colors.white;
    }

    return Scaffold(
      /// Título de la página
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'ASALTO TIME',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ///TODO Reiniciar el timer
              },
              icon: const Icon(Icons.settings))
        ],
      ),

      /// Contador
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${timer.asaltoActual}/12",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: Container(
                  color: getBackground(),
                  child: Center(
                    child: Text(
                      formatedTime(timer.seconds),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: timer.isRunning ? Colors.white : Colors.black),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        ref.read(timerProvider.notifier).resetTimer();
                        // player.play(source)
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 5,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20)),
                      // clipBehavior: ClipRRect(borderRadius: BorderRadius.circular(10),),
                      child: const Icon(
                        Icons.loop,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                    !ref.read(timerProvider.notifier).isActivate
                        ? Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            ref.read(timerProvider.notifier).startTimer();

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20)),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            size: 35,
                            color: Colors.black,
                          )),
                    )
                        : Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(timerProvider.notifier).pauseTimer();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 5,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20)),
                        child: const Icon(
                          Icons.pause,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),

      /// Play - Stop
    );
  }
}
