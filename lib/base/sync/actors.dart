import 'dart:async' show StreamController;
import 'dart:collection';

import 'package:easy_worker/easy_worker.dart';
import 'package:flutter/services.dart'
    show ServicesBinding, BackgroundIsolateBinaryMessenger;

abstract base class ActorMessage {}

abstract base class ActorResponse {}

abstract base class AbstractActor {
  final _mailBox = Queue<ActorMessage>();
  final _responseController = StreamController<ActorResponse>.broadcast();

  bool _isProcessing = false;

  Future<void> _process();

  Stream<ActorResponse> get responses => _responseController.stream;

  void send(ActorMessage payload) {
    _mailBox.add(payload);
    _process();
  }

  void dispose();
}

typedef ActorHandleMessage = void Function(
    ActorMessage, void Function(Object?));

abstract base class IsolateActor extends AbstractActor {
  final String name;
  ActorHandleMessage? _handleMessage;
  EasyCompute? _worker;

  IsolateActor({required this.name});

  void setHandleMessage(
    ActorHandleMessage entrypoint, {
    void Function()? onInit,
  }) {
    if (_handleMessage != null) return;

    _handleMessage ??= entrypoint;
    _worker = EasyCompute<ActorResponse, ActorMessage>(
      ComputeEntrypoint(entrypoint, initData: {
        "token": ServicesBinding.rootIsolateToken,
      }, onInit: (payload) async {
        if (payload is Map) {
          final token = payload["token"];
          if (token != null) {
            BackgroundIsolateBinaryMessenger.ensureInitialized(token);
          }
          onInit?.call();
        }
      }),
      workerName: name,
    );
  }

  @override
  Future<void> _process() async {
    if (_isProcessing || _worker == null) return;
    _isProcessing = true;

    await _worker!.waitUntilReady();
    while (_mailBox.isNotEmpty) {
      final message = _mailBox.removeFirst();
      // call _send inside isolate
      final response = await _worker!.compute(message);
      _responseController.add(response);
    }

    _isProcessing = false;
  }

  @override
  void send(ActorMessage payload) {
    assert(
        _handleMessage != null,
        'Actor handleMessage is not set. Please set it'
        ' before sending messages.');
    super.send(payload);
  }

  @override
  void dispose() {
    _worker?.dispose();
  }
}

abstract base class Actor extends AbstractActor {
  @override
  Future<void> _process() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_mailBox.isNotEmpty) {
      final message = _mailBox.removeFirst();
      final response = await handleMessage(message);
      _responseController.add(response);
    }

    _isProcessing = false;
  }

  Future<ActorResponse> handleMessage(ActorMessage message);

  @override
  void dispose() {
    // no resources to dispose
  }
}
