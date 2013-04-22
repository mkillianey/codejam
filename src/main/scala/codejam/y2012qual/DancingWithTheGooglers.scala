package codejam
package y2012qual

// Solution for Google code jam 2012 Qualification Round Problem B: Dancing With the Googlers
// https://code.google.com/codejam/contest/1460488/dashboard#s=p1

object DancingWithTheGooglers {

  def log(msg : => String) {
    println(msg)
  }

  def solveCase(lines : Iterator[String]) = {
    val line = lines.next().split(" ").map(_.toInt)
    val Array(_, numSurprisingScores, p) = line.take(3)
    val scores = line.drop(3)

    val (definitelyBetterThanP, notDefinitelyBetterThanP) =
      scores.partition(score => (score + 2) / 3 >= p)

    val couldBeSurprisinglyBetterThanP = notDefinitelyBetterThanP.filter(
      score => (if (score < 2) score else ((score + 4) / 3)) >= p)

    val surprisesBetterThanP = (couldBeSurprisinglyBetterThanP.length) min numSurprisingScores

    s"${definitelyBetterThanP.length + surprisesBetterThanP}"
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """4
        |3 1 5 15 13 11
        |3 0 8 23 22 21
        |2 1 1 8 0
        |6 2 8 29 20 8 18 18 21""".stripMargin.lines,
      """Case #1: 3
        |Case #2: 2
        |Case #3: 1
        |Case #4: 3""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}