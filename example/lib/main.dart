import 'package:flutter/material.dart';
import 'package:loader_widget/loader_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = StateController<String>();
  final loaderController = StateController<String>();

  @override
  void initState() {
    super.initState();
    _loadingData();
  }

  Future<void> _loadingData() async {
    const data = 'hi';
    try {
      for (var i = 0; i <= 10; i++) {
        controller.loading(progress: i.toDouble());
        await Future.delayed(const Duration(seconds: 1));
      }
      if (data.isEmpty) {
        return controller.empty();
      }
      controller.finished(data);
    } catch (e) {
      controller.error(e);
    }
  }

  Future<String> _loaderData() async {
    const data = 'hi';
    for (var i = 5; i <= 10; i++) {
      loaderController.loading(progress: i.toDouble());
      await Future.delayed(const Duration(seconds: 1));
    }
    if (data.isEmpty) {
      loaderController.empty();
      return '';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          LoaderWidget<String>(
            stateController: controller,
            emptyWidget: () {
              return const SizedBox.shrink();
            },
            errorWidget: (e) {
              return Text(e.toString());
            },
            loadingWidget: (progress) {
              return Stack(
                children: [
                  Positioned(
                    top: 10,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      progress.toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const CircularProgressIndicator.adaptive(),
                ],
              );
            },
            finishedWidget: (result) {
              return Text(result.toString());
            },
          ),
          const Divider(),
          LoaderWidget<String>(
            stateController: loaderController,
            loader: _loaderData,
            emptyWidget: () {
              return const SizedBox.shrink();
            },
            errorWidget: (e) {
              return Text(e.toString());
            },
            loadingWidget: (progress) {
              return Stack(
                children: [
                  Positioned(
                    top: 10,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Text(
                      progress.toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                  const CircularProgressIndicator.adaptive(),
                ],
              );
            },
            finishedWidget: (result) {
              return Text(result.toString());
            },
          ),
        ],
      ),
    );
  }
}
