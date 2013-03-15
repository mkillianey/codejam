classpath "../.."

// Solution for Google code jam 2008 Qualification Round Problem B. Train Timetable
// http://code.google.com/codejam/contest/32013/dashboard#s=p1

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Integer
uses java.util.ArrayList

// ====================================================================
// Solution
// ====================================================================

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

function solve(turnaroundTime : int, trips : Trip[]) : String {
  trips.sortBy( \ elt -> elt.StartTime )
  var numTrainsThatStartedAtA : int = 0
  var numTrainsThatStartedAtB : int = 0

  // Want to declare tripsEnRoute as List<Trip> but Gosu 0.10.1 barfs
  var tripsEnRoute = trips.toList()
  tripsEnRoute.clear()
  var readyToLeaveFromA : int = 0
  var readyToLeaveFromB : int = 0

  for (tripToSchedule in trips) {
    var departureTime = tripToSchedule.StartTime

    // Find out which trains have arrived, make them available
    var arrived = tripsEnRoute.where(
        \ t -> ((t as Trip).EndTime + turnaroundTime <= departureTime))
    arrived.each(\ t -> {
        if ((t as Trip).Direction == Direction.A_TO_B) {
          readyToLeaveFromB += 1
        } else {
          readyToLeaveFromA += 1
        }
        tripsEnRoute.remove(t)
    })
    tripsEnRoute.add(tripToSchedule)

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
    var trips = new Trip[numTripsFromAToB + numTripsFromBToA]
    for (var i in 0..|numTripsFromAToB) {
      var times = reader.readLine().split(" ").map( stringToTime )
      trips[i] = new Trip() { :StartTime = times[0], :EndTime = times[1], :Direction = Direction.A_TO_B }
    }
    for (var i in numTripsFromAToB..|(numTripsFromAToB + numTripsFromBToA)) {
      var times = reader.readLine().split(" ").map( stringToTime )
      trips[i] = new Trip() { :StartTime = times[0], :EndTime = times[1], :Direction = Direction.B_TO_A }
    }
    return solve(turnaroundTimeInMinutes, trips)
})

// ====================================================================
// Examples
// ====================================================================

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

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "B")
