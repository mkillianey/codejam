classpath "../../.."

uses codejam.SolutionRunner

uses java.io.BufferedReader
uses java.io.StringReader
uses java.util.*

// Solution to http://code.google.com/codejam/contest/1645485/dashboard#s=p1
// Problem B. Kingdom Rush


class Level {
  var _id : int as Id
  var _one : int as NeededForOneStar
  var _two : int as NeededForTwoStars
  construct (id : int, s : String) {
    var values = s.split(" ")
    _id = id
    _one = values[0].toInt()
    _two = values[1].toInt()
  }
  override public function toString() : String {
    return "${_id}[${_one}/${_two}]"
  }
  override public function equals(other : Object) : boolean {
    return (other typeis Level) and (_id == other._id)
  }
  override public function hashCode() : int {
    return _id
  }
}


function solve(reader : BufferedReader) : String {
  var numLevels = reader.readLine().toInt()
  var levels = (0..|numLevels).map(\ id -> new Level(id, reader.readLine()))
  //print("Levels:")
  //for (level in levels) { print("    ${level}") }

  var canPlayForTwoStars = new LinkedList<Level>(levels.toList().sortBy( \ level -> level.NeededForTwoStars))
  var canPlayForOneStar = levels.toSet()

  var starsEarned = 0
  var levelsPlayed = 0

  while (!canPlayForTwoStars.Empty) {
    if (canPlayForTwoStars.get(0).NeededForTwoStars <= starsEarned) {
      var level = canPlayForTwoStars.remove(0)
      levelsPlayed++
      if (canPlayForOneStar.remove(level)) {
        starsEarned += 2
        //print("Played level ${level} for both stars [Played ${levelsPlayed}, Earned ${starsEarned}]")
      } else {
        starsEarned += 1
        //print("Played level ${level} for second star [Played ${levelsPlayed}, Earned ${starsEarned}]")
      }
      continue
    }
    var level = canPlayForOneStar.where( \ elt -> elt.NeededForOneStar <= starsEarned ).maxBy( \ elt -> elt.NeededForTwoStars)
    if (level == null) {
      return "Too Bad"
    }
    canPlayForOneStar.remove(level)
    levelsPlayed++
    starsEarned += 1
    //print("Played level ${level} for first star [Played ${levelsPlayed}, Earned ${starsEarned}]")
  }

  return "${levelsPlayed}"
}


var sampleInput = new StringReader({
    "4",
    "2",
    "0 1",
    "0 2",
    "3",
    "2 2",
    "0 0",
    "4 4",
    "1",
    "1 1",
    "5",
    "0 5",
    "0 1",
    "1 1",
    "4 7",
    "5 6",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ x -> solve(x))

runner.solveOneCase({"2 5", "0.6 0.6"})
runner.solveAll( sampleInput )
//runner.pollDirectory(".", :prefix = "B")


