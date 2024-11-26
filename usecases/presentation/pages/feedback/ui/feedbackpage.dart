import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_management_app/data/models/feedback/feedback.dart';
import 'package:vehicle_management_app/presentation/pages/feedback/cubit/feedback_cubit.dart';

class FeedbackPage extends StatefulWidget {
  final String userId;
  final String rideId;

  const FeedbackPage({required this.userId, required this.rideId, super.key});

  @override
  FeedbackPageState createState() => FeedbackPageState();
}

class FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentsController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: BlocProvider(
        create: (context) => FeedbackCubit(),
        child: BlocListener<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Feedback submitted successfully!')),
              );
              Navigator.pop(context);
            } else if (state is FeedbackError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('Rate your ride:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                        ),
                        color: Colors.amber,
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextFormField(
                    controller: _commentsController,
                    decoration: const InputDecoration(labelText: 'Comments'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your comments';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final feedback = FeedbackModel(
                          userId: widget.userId,
                          rideId: widget.rideId,
                          rating: _rating,
                          comments: _commentsController.text,
                        );
                        context.read<FeedbackCubit>().submitFeedback(feedback);
                      }
                    },
                    child: const Text('Submit Feedback'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
