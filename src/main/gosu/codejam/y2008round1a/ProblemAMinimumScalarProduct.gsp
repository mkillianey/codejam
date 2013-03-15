classpath "../.."

// Solution for Google code jam 2008 Round 1A Problem A: Minimum Scalar Product
// http://code.google.com/codejam/contest/32016/dashboard#s=p0

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Long
uses java.util.List

// ====================================================================
// Solution
// ====================================================================

function solve(x : List<Long>, y : List<Long>) : String {
  x.sort()
  y.sortDescending()
  var sum : long = 0
  for (xi in x index i) {
    sum += xi * y[i]
  }
  return "${sum}"
}

var runner = SolutionRunner.from(\ reader -> {
  var count = reader.readLine().toInt()
  var vector1 = reader.readLine().split(" ").map( \ elt -> elt.toLong()).toList()
  var vector2 = reader.readLine().split(" ").map( \ elt -> elt.toLong()).toList()
  return solve(vector1, vector2)
})

// ====================================================================
// Examples
// ====================================================================

var sampleInput = new StringReader({
"2",
"3",
"1 3 -5",
"-2 4 1",
"5",
"1 2 3 4 5",
"1 0 1 0 1",
""}.join("\n"))

runner.solveAll(sampleInput)

// ====================================================================
// Submission
// ====================================================================

runner.pollDirectory(:prefix = "A")
