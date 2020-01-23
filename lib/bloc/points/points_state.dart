abstract class PointsState{}

class PointsAdded extends PointsState{
  var point;
  PointsAdded(this.point);
}

class PointsFetched extends PointsState{
  List points;
  PointsFetched(this.points);
}