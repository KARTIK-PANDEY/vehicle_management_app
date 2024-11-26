import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'refueling_state.dart';

class RefuelingCubit extends Cubit<RefuelingState> {
  RefuelingCubit() : super(RefuelingInitial());
}
