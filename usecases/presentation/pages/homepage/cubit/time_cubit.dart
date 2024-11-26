import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimeCubit extends HydratedCubit<String> {
  TimeCubit() : super("") {
    _startTimer();
  }

  static String _getCurrentTime() {
    final now = DateTime.now();
    // Formatting the time as 'HH:mm' and the day of the week as 'EEEE'
    String formattedDateTime = DateFormat('HH:mm').format(now);
    String dayOfWeek = DateFormat('EEEE').format(now);
    formattedDateTime = '$dayOfWeek  $formattedDateTime';
    return formattedDateTime;
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(_getCurrentTime());
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  String? fromJson(Map<String, dynamic> json) {
    return json['time'] as String;
  }

  @override
  Map<String, dynamic>? toJson(String state) {
    return {'time': state};
  }
}
