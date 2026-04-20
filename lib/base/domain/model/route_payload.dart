class RoutePayload {
  final dynamic _data;

  RoutePayload({dynamic data}) : _data = data;

  bool is_<S>() => _data is S;

  S? get<S>() {
    if (is_<S>()) {
      return _data as S;
    }
    return null;
  }
}
