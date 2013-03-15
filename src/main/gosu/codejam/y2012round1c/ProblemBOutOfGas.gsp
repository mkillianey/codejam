classpath "../.."

// Source for support files located at: https://github.com/mkillianey/codejam

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Double
uses java.lang.Math
uses java.lang.Throwable
uses java.util.List

// Solution to Google Codejam 2012 Round 1C Problem B: Out of Gas
// http://code.google.com/codejam/contest/1781488/dashboard#s=p1

class Location {
  var _time : double as Time
  var _position : double as Position
  override public function toString() : String {
    return "${Position}@${Time}"
  }
}

function solve(distance : double, otherCarLocations : List<Location>, accelerations : Double[]) : String {
  var times : List<Double> = {}
  var otherCarReachedDistance = false
  for (location in otherCarLocations iterator iter index i) {
    if (otherCarReachedDistance) {
      iter.remove() // Once the other car passes our home, its location is irrelevant.
    } else if (location.Position >= distance) {
      otherCarReachedDistance = true
      if (i > 0) {
        // interpolate from previous position to find out when the other car passed our home
        var previous = otherCarLocations[i-1]
        location.Time = previous.Time +
            ((location.Time - previous.Time)
                * (distance - previous.Position) / (location.Position - previous.Position))
        location.Position = distance
      } else {
        // no previous position to interpolate, so just assume the other car was already at home
        location.Position = distance
      }
    }
  }
  for (acceleration in accelerations) {
    var timeNeeded = Math.sqrt(2 * distance / acceleration)
    var worstDelay = otherCarLocations.map( \ location -> {
      return Math.max(0.0, location.Time - Math.sqrt(2 * location.Position / acceleration))
    }).max()
    times.add(timeNeeded + worstDelay)
  }
  return "\n" + (times.join("\n"))
}

var sampleInput = new StringReader({
    "3",
    "1000.000000 2 3",
    "0.000000 20.500000",
    "25.000000 1000.000000",
    "1.00 5.00 9.81",
    "50.000000 2 2",
    "0.000000 0.000000",
    "100000.000000 100.000000",
    "1.00 1.01",
    "10000.000000 3 1",
    "0.000000 0.000000",
    "10000.000000 0.100000",
    "10000.100000 100000.000000",
    "1.00",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ reader -> {
  var header = reader.readLine().split(" ")
  var distance = header[0].toDouble()
  var numLocations  = header[1].toInt()
  var otherCarLocations : List<Location> = {}
  for (i in 0..|numLocations) {
    var line = reader.readLine().split(" ").map( \ elt -> elt.toDouble())
    otherCarLocations.add(new Location() { :Time = line[0], :Position = line[1] })
  }
  var accelerations = reader.readLine().split(" ").map( \ elt -> elt.toDouble())
  return solve(distance, otherCarLocations, accelerations)
})

runner.solveOneCase({"1000.000000 2 3", "0.000000 20.500000", "25.000000 1000.000000", "1.00 5.00 9.81"})
runner.solveAll( sampleInput )
runner.pollDirectory(".", :prefix = "B")

