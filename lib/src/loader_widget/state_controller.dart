import 'package:flutter/foundation.dart';
import 'state.dart';

abstract class IStateController<T> {
  StateLoader get currentState;

  void empty();

  void loading({double progress});

  void error(Exception exception);

  void finished(T result);

  void addListener(
      void Function(
              StateLoader state, double? progress, Object? exception, T? result)
          listener);

  /// Auto close you don't need to call [dispose]
  void dispose();
}

class StateController<T> implements IStateController<T> {
  final _state = ValueNotifier<StateLoader>(StateLoader.loading);

  T? _result;

  double _progress = 0;

  Object? _exception;

  @override
  StateLoader get currentState => _state.value;

  @override
  void empty() {
    _changeState(StateLoader.empty);
  }

  @override
  void loading({double progress = 0}) {
    _progress = progress;
    _state.value = StateLoader.empty;
    _state.value = StateLoader.loading;
  }

  @override
  void error(Object exception) {
    _exception = exception;
    _changeState(StateLoader.error);
  }

  @override
  void finished(T? result) {
    _result = result;
    _changeState(StateLoader.finished);
  }

  void _changeState(StateLoader stateLoaderWidget) {
    if (_state.value != stateLoaderWidget) {
      _state.value = stateLoaderWidget;
    }
  }

  @override
  void addListener(
      void Function(
              StateLoader state, double progress, Object? exception, T? result)
          listener) {
    _state.addListener(
      () {
        listener(currentState, _progress, _exception, _result);
      },
    );
  }

  @override
  void dispose() {
    _state.dispose();
  }
}
