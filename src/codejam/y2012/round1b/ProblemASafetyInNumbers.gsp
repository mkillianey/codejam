classpath "../../.."

// Source for SolutionRunner is at:
// https://github.com/mkillianey/codejam

uses codejam.SolutionRunner

uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Double
uses java.lang.Math
uses java.lang.String
uses java.util.List

// Solution to Google Codejam 2012 Round 1B Problem A.

function solve(scores : List<Double>) : String {
  scores.remove(0) // number of contestants

  var totalJudgePoints = scores.sum()
  var totalAudiencePoints = totalJudgePoints
  var averageFinalScore = (totalAudiencePoints + totalJudgePoints) / scores.size()

  var scoresInDanger = scores.where(\ score -> score < averageFinalScore)
  var cutoffScore = (scoresInDanger.sum() + totalAudiencePoints) / scoresInDanger.size()

  var percentNeeded : List<Double> = {}
  for (score in scores index i) {
    percentNeeded.add(Math.max(0.0, 100.0 * (cutoffScore - score) / totalAudiencePoints))
  }
  return percentNeeded.join(" ")
}

var sampleInput = new StringReader({
    "4",
    "2 20 10",
    "2 10 0",
    "4 25 25 25 25",
    "3 24 30 21",
    ""}.join("\n"))

var runner = SolutionRunner.from(\ reader -> {
    var values = reader.readLine().split(" ").toList()
    return solve(values.subList(1, values.size()).map( \ s -> s.toDouble()))
})

runner.solveOneCase({"3 0 0 10"})
runner.solveOneCase({"9 66 0 67 67 1 0 1 0 66"})
runner.solveAll( sampleInput )
runner.pollDirectory(".", :prefix = "A")

