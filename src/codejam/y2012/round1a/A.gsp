classpath "../../.."

uses codejam.BaseSolver
uses java.io.*
uses java.lang.*
uses java.util.*

// Solution to http://code.google.com/codejam/contest/1645485/dashboard#s=p0
// Problem A. Password Problem

class Solver extends BaseSolver {

  construct() {
  }

  override function solveOneCase(reader : BufferedReader) : String {
    var line1 = reader.readLine()
    var line2 = reader.readLine()
    var charactersTyped = line1.split(" ")[0].toInt()
    var passwordLength = line1.split(" ")[1].toInt()
    print("Typed ${charactersTyped} of ${passwordLength}")
    var oddsOfKeystrokeBeingRight = line2.split(" ").map(\ s : String -> s.toDouble() ).toList()
    oddsOfKeystrokeBeingRight.add(1.0d)
    var PRESSING_ENTER = 1
    var previousOddsOfBeingRight = 1.0d
    var best : double = PRESSING_ENTER + passwordLength + PRESSING_ENTER
    print("Hit enter immediately, expected value = ${best}")
    for (retypeStartingFrom in 0..charactersTyped) {
      var backspaces = charactersTyped - retypeStartingFrom
      var totalIfRight = backspaces + (passwordLength - retypeStartingFrom) + PRESSING_ENTER
      var totalIfWrong = totalIfRight + passwordLength + PRESSING_ENTER
      var oddsOfBeingRight = previousOddsOfBeingRight
      var oddsOfBeingWrong = 1.0 - oddsOfBeingRight
      var expected = totalIfRight * oddsOfBeingRight + totalIfWrong * oddsOfBeingWrong
      print("Backspacing to ${retypeStartingFrom}, odds of no typos is ${oddsOfBeingRight}, expected strokes = ${expected}")
      best = Math.min(expected, best)
      previousOddsOfBeingRight *= oddsOfKeystrokeBeingRight[retypeStartingFrom]
    }
    return "${best}"
  }

}

var sampleInput = new StringReader({
    "3",
    "2 5",
    "0.6 0.6",
    "1 20",
    "1",
    "3 4",
    "1 0.9 0.1",
    ""}.join("\n"))

var solver = new Solver()

//solver.tryOneCase({"3 4", "1 0.9 0.1"})
solver.solveAll( sampleInput )
//solver.pollDirectory(".", :prefix = "A")


