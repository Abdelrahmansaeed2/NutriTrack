import 'package:flutter_bloc/flutter_bloc.dart';
import 'activity_goal_state.dart';

class ActivityGoalCubit extends Cubit<ActivityGoalState> {
  ActivityGoalCubit() : super(const ActivityGoalState());

  void selectActivityLevel(ActivityLevel level) {
    emit(state.copyWith(selectedActivityLevel: level));
  }
}
