import 'dart:async';

class Debounce {
  final int delayInMilliseconds;
  Timer? _timer;

  Debounce({this.delayInMilliseconds = 500});

  call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delayInMilliseconds), action);
  }
}
