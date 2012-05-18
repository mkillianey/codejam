classpath "../../.."

// Solution for Google code jam 2008 Qualification Round Problem B. Train Timetable
// http://code.google.com/codejam/contest/32013/dashboard#s=p1

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.util.ArrayList

enum Direction {
  A_TO_B,
  B_TO_A;
}

class Trip {
  var _start : int as StartTime
  var _end : int as EndTime
  var _direction : Direction as Direction
  override function toString() : String {
    return "${_direction}: ${_start}-${_end}"
  }
}

function solve(turnaroundTime : int, trips : ArrayList<Trip>) : String {
  trips.sortBy( \ elt -> elt.StartTime )
  var numTrainsThatStartedAtA : int = 0
  var numTrainsThatStartedAtB : int = 0

  var tripsEnRoute = new ArrayList<Trip>()
  var readyToLeaveFromA : int = 0
  var readyToLeaveFromB : int = 0

  for (tripToSchedule in trips) {
    var departureTime = tripToSchedule.StartTime

    // Find out which trains have arrived
    for (tripEnRoute in tripsEnRoute iterator tripEnRouteIterator) {
      if (tripEnRoute.EndTime + turnaroundTime <= departureTime) {
        if (tripEnRoute.Direction == Direction.A_TO_B) {
          readyToLeaveFromB += 1
        } else {
          readyToLeaveFromA += 1
        }
        tripEnRouteIterator.remove()
      }
    }

    // If a train is ready, use it, else add one to the trains that originally started at the station
    if (tripToSchedule.Direction == Direction.A_TO_B) {
      if (readyToLeaveFromA < 1) {
        numTrainsThatStartedAtA += 1
      } else {
        readyToLeaveFromA -= 1
      }
    } else {
      if (readyToLeaveFromB < 1) {
        numTrainsThatStartedAtB += 1
      } else {
        readyToLeaveFromB -= 1
      }
    }

    tripsEnRoute.add(tripToSchedule)
  }

  return "${numTrainsThatStartedAtA} ${numTrainsThatStartedAtB}"
}

var runner = SolutionRunner.from( \ reader -> {
    var stringToTime = \ s : String -> {
          var times = s.split(":").map( \ elt -> elt.toInt())
          return times[0] * 60 + times[1]
        }
    var turnaroundTimeInMinutes = reader.readLine().toInt()
    var numTrips = reader.readLine().split(" ").map(\ s -> s.toInt())
    var numTripsFromAToB = numTrips[0]
    var numTripsFromBToA = numTrips[1]
    var trips = new ArrayList<Trip>()
    for (var _ in 0..|numTripsFromAToB) {
      var times = reader.readLine().split(" ").map( stringToTime )
      var tripFromAToB = new Trip() { :StartTime = times[0], :EndTime = times[1], :Direction = Direction.A_TO_B }
      trips.add(tripFromAToB)
    }
    for (var _ in 0..|numTripsFromBToA) {
      var times = reader.readLine().split(" ").map( stringToTime )
      var tripFromBToA = new Trip() { :StartTime = times[0], :EndTime = times[1], :Direction = Direction.B_TO_A }
      trips.add(tripFromBToA)
    }
    return solve(turnaroundTimeInMinutes, trips)
})

var sampleInput = new StringReader({
    "2",
    "5",
    "3 2",
    "09:00 12:00",
    "10:00 13:00",
    "11:00 12:30",
    "12:02 15:00",
    "09:00 10:30",
    "2",
    "2 0",
    "09:00 09:01",
    "12:00 12:02",
    ""}.join("\n"))


runner.solveAll(sampleInput)
runner.pollDirectory(:prefix = "B")
