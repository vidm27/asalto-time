import 'dart:async';

import 'package:asalto_time/timer/provider/timer_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static String name = "home_screen";

  const HomeScreen({Key? key}) : super(key: key);

  String formatedTime(int timer) {
    final minutes = ((timer ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (timer % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int timer = ref.watch(timerProvider);

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
            Expanded(
                child: Center(
              child: SizedBox(
                child: Text(
                  formatedTime(timer),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 120, fontWeight: FontWeight.bold),
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
                    !ref.read(timerProvider.notifier).isActivateTime
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
                                ref.read(timerProvider.notifier).stopTimer();
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
