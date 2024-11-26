part of 'refueling_cubit.dart';

sealed class RefuelingState extends Equatable {
  const RefuelingState();

  @override
  List<Object> get props => [];
}

final class RefuelingInitial extends RefuelingState {}
