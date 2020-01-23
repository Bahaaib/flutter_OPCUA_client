abstract class PointsEvent {}

class FetchPoints extends PointsEvent {
  FetchPoints();
}

class AddPoint extends PointsEvent{
  AddPoint();
}
