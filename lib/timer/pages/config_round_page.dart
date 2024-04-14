import 'package:asalto_time/timer/provider/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigRoundPage extends ConsumerStatefulWidget {
  static String name = "config_round_page";

  const ConfigRoundPage({super.key});

  @override
  _ConfigRoundPageState createState() => _ConfigRoundPageState();
}

class _ConfigRoundPageState extends ConsumerState<ConfigRoundPage> {
  late TextEditingController asaltoController;
  late TextEditingController tiempoController;
  late TextEditingController tiempoDescansoController;

  @override
  void initState() {
    super.initState();
    asaltoController = TextEditingController(text: ref.read(roundConfigProvider.notifier).state.totalRounds.toString());
    tiempoController = TextEditingController(text: ref.read(roundConfigProvider.notifier).state.totalSeconds.toString() );
    tiempoDescansoController = TextEditingController(text: ref.read(roundConfigProvider.notifier).state.secondsBreak.toString());
  }

  @override
  void dispose() {
    asaltoController.dispose();
    tiempoController.dispose();
    tiempoDescansoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: const Text("Config Round")),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: asaltoController,
                decoration: const InputDecoration(label: Text("Asaltos")),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ), TextField(
                controller: tiempoController,
                decoration: const InputDecoration(label: Text("Minutos de asalto")),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: tiempoDescansoController,
                decoration: const InputDecoration(label: Text("Minutos de descanso")),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                  onPressed: () {
                    ref
                        .read(roundConfigProvider.notifier)
                        .update((state) => state.copyWith(
                            totalRounds: int.parse(asaltoController.text),
                            totalSeconds: int.parse(tiempoController.text) * 60,
                            secondsBreak: int.parse(tiempoDescansoController.text) * 60));

                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"))
            ],
          ),
        ));
  }
}
