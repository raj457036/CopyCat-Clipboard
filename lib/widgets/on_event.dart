import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnEventTrigger<T> = Function(BuildContext context, T state);

class OnEvent<T> extends StatelessWidget {
  final Widget child;
  final OnEventTrigger<T> trigger;

  const OnEvent({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBusCubit, EventBusState>(
      listenWhen: (_, current) {
        return current is T;
      },
      listener: (context, state) => trigger(context, state as T),
      child: child,
    );
  }
}
