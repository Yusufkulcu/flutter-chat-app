import 'package:chatappyenitasarim/Providers/ExampleProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodExample extends ConsumerStatefulWidget {
  const RiverpodExample({super.key});

  @override
  ConsumerState<RiverpodExample> createState() => _RiverpodExampleState();
}

class _RiverpodExampleState extends ConsumerState<RiverpodExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ref.watch(themeProvider).isDarkTheme,),
            ElevatedButton(
              onPressed: () {
                ref.watch(themeProvider).switchTheme();
              },
              child: Text("csdcdsc"),
            )
          ],
        ),
      ),
    );
  }
}
