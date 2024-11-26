import 'package:hydrated_bloc/hydrated_bloc.dart';

class NavindexCubit extends HydratedCubit {
  NavindexCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json['index'] as int;
  }

  @override
  Map<String, dynamic>? toJson(state) {
    return {'index': state};
  }
}
