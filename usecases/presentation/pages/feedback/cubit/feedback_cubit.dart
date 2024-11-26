import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vehicle_management_app/data/models/feedback/feedback.dart';

part 'feedback_state.dart';

class FeedbackCubit extends HydratedCubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  void submitFeedback(FeedbackModel feedback) {
    emit(FeedbackLoading());
    try {
      // Simulate a network call
      Future.delayed(const Duration(seconds: 2), () {
        emit(FeedbackSubmitted(feedback));
      });
    } catch (e) {
      emit(FeedbackError(e.toString()));
    }
  }

  @override
  FeedbackState? fromJson(Map<String, dynamic> json) {
    // Implement if needed
    return null;
  }

  @override
  Map<String, dynamic>? toJson(FeedbackState state) {
    // Implement if needed
    return null;
  }
}
