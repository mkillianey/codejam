uses java.io.*
uses java.lang.*
uses java.util.*

var sampleInput = {
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
""}.join("\n")


var timeStringToInt = \ s : String -> {
  var times = s.split(":").map( \ elt -> elt.toInt())
  return times[0] * 60 + times[1]
}

enum Direction {
  A_TO_B,
  B_TO_A;
}

class Trip {
  var _start : int as StartTime
  var _end : int as EndTime
  var _direction : Direction as Direction
  construct (start : int, end : int, direction : Direction) {
    this._start = start
    this._end = end
    this._direction = direction
  }
  override function toString() : String {
    return "${Direction}: ${StartTime}-${EndTime}"
  }
}

function solve(turnaroundTime : int, trips : List<Trip>) : String {
  trips.sortBy( \ elt -> elt.StartTime )
  var startedAtA = 0
  var startedAtB = 0

  var departedTrips : List<Trip> = new ArrayList<Trip>()
  var readyAtA = 0
  var readyAtB = 0

  while (!trips.Empty) {
    var tripToSchedule = trips.remove(0)
    var departureTime = tripToSchedule.StartTime

    // Find out which trains have arrived
    var iter = departedTrips.iterator()
    while (iter.hasNext()) {
      var departedTrip = iter.next()
      if (departedTrip.EndTime + turnaroundTime <= departureTime) {
        if (departedTrip.Direction == A_TO_B) {
          readyAtB += 1
        } else {
          readyAtA += 1
        }
        iter.remove()
      }
    }

    // If no train is ready, add one to the trains that were present at the
    // start
    if (tripToSchedule.Direction == A_TO_B) {
      if (readyAtA < 1) {
        startedAtA += 1
      } else {
        readyAtA -= 1
      }
    } else {
      if (readyAtB < 1) {
        startedAtB += 1
      } else {
        readyAtB -= 1
      }
    }

    departedTrips.add(tripToSchedule)
  }

  return "${startedAtA} ${startedAtB}"
}

function solveAll(input : Reader, output : Writer) {
  var br = new BufferedReader(input)
  var bw = new BufferedWriter(output)
  var numCases = br.readLine().toInt()
  for (var index in 1..numCases) {
    var turnaroundTime = br.readLine().toInt()
    var numTrips = br.readLine().split(" ").map(\ s -> s.toInt())
    var trips : List<Trip> = {}
    for (var _ in 0..|numTrips[0]) {
      var times = br.readLine().split(" ").map( timeStringToInt )
      trips.add(new Trip(times[0], times[1], A_TO_B ))
    }
    for (var _ in 0..|numTrips[1]) {
      var times = br.readLine().split(" ").map( timeStringToInt )
      trips.add(new Trip(times[0], times[1], B_TO_A ))
    }
    bw.write("Case #${index}: ${solve(turnaroundTime, trips)}")
    bw.newLine()
  }
  bw.flush()
  bw.close()
}

solveAll(new StringReader(sampleInput), new OutputStreamWriter(System.out))
//solveAll(new FileReader("B-small-practice.in"), new FileWriter("B-small-practice.out"))
//solveAll(new FileReader("B-large-practice.in"), new FileWriter("B-large-practice.out"))