package codejam.y2013round1b

import codejam.SolverRunner

// Solution for Google code jam 2013 Round 1B Problem A: Osmos
// https://code.google.com/codejam/contest/2434486/dashboard#s=p0

object Osmos {
  def solveCase(lines : Iterator[String]) : String = {
    val Array(initalArmin, numMotes) = lines.next.split(" ").map(_.toInt)
    val initialMotes = lines.next.split(" ").map(_.toInt).sorted.toList
    if (initalArmin == 1) {
      numMotes.toString
    } else {
      def helper(armin : Int, created : Int, motes : List[Int]) : Int = {
        if (motes.isEmpty) {
          created
        } else {
          val bestIfCreated = if (armin > motes.head)
            helper(armin + motes.head, created, motes.tail)
          else
            helper(armin + armin - 1, created + 1, motes)
          (created + motes.length).min(bestIfCreated)
        }
      }
      helper(initalArmin, 0, initialMotes).toString
    }
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """4
        |2 2
        |2 1
        |2 4
        |2 1 1 6
        |10 4
        |25 20 9 100
        |1 4
        |1 1 1 1""".stripMargin.lines,
      """Case #1: 0
        |Case #2: 1
        |Case #3: 2
        |Case #4: 4""".stripMargin.lines
    )
    //runner.pollDirectory(".")
  }

}
