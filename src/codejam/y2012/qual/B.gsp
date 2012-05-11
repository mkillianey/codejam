classpath "../../.."

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Integer
uses java.lang.Math
uses java.util.List

// http://code.google.com/codejam/contest/1460488/dashboard#s=p1
// Google Code Jam 2012 Qualification Round Problem B. Dancing With the Googlers

var bestToMinScoreWithoutSurprise = {
    0 -> 0, // 0,0,0
    1 -> 1, // 0,0,1
    2 -> 4, // 1,1,2
    3 -> 7, // 2,2,3
    4 -> 10, // 3,3,4
    5 -> 13,
    6 -> 16,
    7 -> 19,
    8 -> 22,
    9 -> 25,
    10 -> 28
}

var bestToMinScoreWithSurprise = {
    0 -> 0, // 0,0,0
    1 -> 1, // 0,0,1
    2 -> 2, // 0,0,2
    3 -> 5, // 1,1,3
    4 -> 8,  // 2,2,4
    5 -> 11, // 3,3,5
    6 -> 14, // 4,4,6
    7 -> 17, // 5,5,7
    8 -> 20, // 6,6,8
    9 -> 23, // 7,7,9
    10 -> 26 // 8,8,10
}

function solve(surprises : int, bestResult : int, scores : List<Integer>) : String {
  var minScoreWithoutSurprise = bestToMinScoreWithoutSurprise[bestResult]
  var minScoreWithSurprise = bestToMinScoreWithSurprise[bestResult]

  var beatWithoutSurprise = scores.countWhere( \ n -> n >= minScoreWithoutSurprise)
  var beatWithSurprise = scores.countWhere( \ n -> n < minScoreWithoutSurprise && n >= minScoreWithSurprise)
  return "${beatWithoutSurprise + Math.min(surprises, beatWithSurprise)}"
}

var sampleInput = new StringReader({
    "4",
    "3 1 5 15 13 11",
    "3 0 8 23 22 21",
    "2 1 1 8 0",
    "6 2 8 29 20 8 18 18 21",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ reader -> {
  var values = reader.readLine().split(" ").map(\ e -> e.toInt()).toList()
  var numScores = values[0]
  var surprises = values[1]
  var bestResult = values[2]
  var scores = values.subList(3, values.size())
  return solve(surprises, bestResult, scores)
})

runner.solveOneCase({"3 1 5 15 13 11"})
runner.solveAll(sampleInput)
runner.pollDirectory(".", "B")
