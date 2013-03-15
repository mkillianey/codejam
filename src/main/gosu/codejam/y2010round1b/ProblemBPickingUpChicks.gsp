classpath "../.."

// Solution for "Round 1B 2010 Problem B: Picking Up Chicks":
// http://code.google.com/codejam/contest/635101/dashboard#s=p1

uses codejam.SolutionRunner
uses java.io.StringReader
uses java.lang.Integer

// ====================================================================
// Solution
// ====================================================================


function solve(numNeeded : int, barnPosition : int, timeLimit : int, positions : Integer[], velocities : Integer[]) : String {
  var endPositions = (0..|positions.length).map(\ i -> positions[i] + velocities[i]*timeLimit)
  var totalSwaps : int = 0
  var slowChicksToPass : int = 0
  for (endPosition in endPositions.reverse()) {
    if (endPosition >= barnPosition) {
      totalSwaps += slowChicksToPass
      numNeeded -= 1
    } else {
      slowChicksToPass += 1
    }
    if (numNeeded <= 0) {
      return "${totalSwaps}"
    }
  }
  return "IMPOSSIBLE"
}

var runner = SolutionRunner.from(\ reader -> {
    var n_k_b_t = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    var numNeeded = n_k_b_t[1]
    var barnPosition = n_k_b_t[2]
    var timeLimit = n_k_b_t[3]

    var positions = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    var velocities = reader.readLine().split(" ").map( \ elt -> elt.toInt())
    return solve(numNeeded, barnPosition, timeLimit, positions, velocities)
})


// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
    "3",
    "5 3 10 5",
    "0 2 5 6 7",
    "1 1 1 1 4",
    "5 3 10 5",
    "0 2 3 5 7",
    "2 1 1 1 4",
    "5 3 10 5",
    "0 2 3 4 7",
    "2 1 1 1 4",
    ""
}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "B")
