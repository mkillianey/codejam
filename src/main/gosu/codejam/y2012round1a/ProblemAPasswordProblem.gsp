classpath "../.."

uses codejam.SolutionRunner
uses java.io.StringReader
uses java.lang.Double
uses java.lang.Math
uses java.util.List

// Solution to http://code.google.com/codejam/contest/1645485/dashboard#s=p0
// Problem A. Password Problem

// ====================================================================
// Solution
// ====================================================================

function log(msg : block() : String) {
  // Uncomment to see helpful messages
  // print(msg())
}

function solve(charactersTyped : int, passwordLength : int, oddsOfKeystrokeBeingRight : List<Double>) : String {
  log(\ -> "Typed ${charactersTyped} of ${passwordLength}")
  oddsOfKeystrokeBeingRight.add(1.0d)
  var PRESSING_ENTER = 1
  var previousOddsOfBeingRight = 1.0d
  var best : double = PRESSING_ENTER + passwordLength + PRESSING_ENTER
  log(\ -> "Hit enter immediately, expected value = ${best}")
  for (retypeStartingFrom in 0..charactersTyped) {
    var backspaces = charactersTyped - retypeStartingFrom
    var totalIfRight = backspaces + (passwordLength - retypeStartingFrom) + PRESSING_ENTER
    var totalIfWrong = totalIfRight + passwordLength + PRESSING_ENTER
    var oddsOfBeingRight = previousOddsOfBeingRight
    var oddsOfBeingWrong = 1.0 - oddsOfBeingRight
    var expected = totalIfRight * oddsOfBeingRight + totalIfWrong * oddsOfBeingWrong
    log(\ -> "Backspacing to ${retypeStartingFrom}, odds of no typos is ${oddsOfBeingRight}, expected strokes = ${expected}")
    best = Math.min(expected, best)
    previousOddsOfBeingRight *= oddsOfKeystrokeBeingRight[retypeStartingFrom]
  }
  return best as String
}

var runner = SolutionRunner.from(\ reader -> {
  var line1 = reader.readLine()
  var line2 = reader.readLine()
  var charactersTyped = line1.split(" ")[0].toInt()
  var passwordLength = line1.split(" ")[1].toInt()
  var oddsOfKeystrokeBeingRight = line2.split(" ").map(\ s : String -> s.toDouble() ).toList()
  return solve(charactersTyped, passwordLength, oddsOfKeystrokeBeingRight)
})

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "3",
    "2 5",
    "0.6 0.6",
    "1 20",
    "1",
    "3 4",
    "1 0.9 0.1",
    ""}.join("\n"))

runner.solveOneCase({"3 4", "1 0.9 0.1"})
runner.solveOneCase({"3 4", "1 0.9 0.1"})
runner.solveAll( sampleInput )

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(".", :prefix = "A")


