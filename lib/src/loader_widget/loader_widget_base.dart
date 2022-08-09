import 'package:flutter/widgets.dart';
import 'state.dart';

import 'state_controller.dart';

class LoaderWidget<T> extends StatefulWidget {
  final StateController<T>? stateController;
  final Future<T> Function()? loader;
  final Widget Function() emptyWidget;
  final Widget Function(double progress) loadingWidget;

  final Widget Function(Object exception) errorWidget;

  final Widget Function(T result) finishedWidget;

  const LoaderWidget({
    super.key,
    this.stateController,

    /// Auto change state depend on [loader] function
    this.loader,
    required this.emptyWidget,
    required this.errorWidget,
    required this.loadingWidget,
    required this.finishedWidget,
  });

  @override
  State<LoaderWidget<T>> createState() => _LoaderWidgetState<T>();
}

class _LoaderWidgetState<T> extends State<LoaderWidget<T>> {
  late var child = widget.loadingWidget(0);
  late StateController<T> stateController;
  @override
  void initState() {
    super.initState();
    _initStateController();
    _changeState();
    _callLoader();
  }

  void _initStateController() {
    if (widget.stateController != null) {
      stateController = widget.stateController!;
    } else {
      stateController = StateController<T>();
    }
  }

  void _changeState() {
    stateController.addListener(
      (state, progress, exception, result) {
        switch (state) {
          case StateLoader.empty:
            child = widget.emptyWidget();
            break;
          case StateLoader.loading:
            child = widget.loadingWidget(progress);
            break;
          case StateLoader.moreLoading:
            child = widget.loadingWidget(progress);
            break;
          case StateLoader.error:
            child = widget.errorWidget(exception!);
            break;
          case StateLoader.finished:
            child = widget.finishedWidget(result as T);
            break;
        }
        setState(() {});
      },
    );
  }

  Future<void> _callLoader() async {
    final loader = widget.loader;
    if (loader != null) {
      try {
        stateController.loading();
        final data = await loader();
        stateController.finished(data);
      } catch (e) {
        stateController.error(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  void dispose() {
    stateController.dispose();
    super.dispose();
  }
}
