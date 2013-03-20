package codejam
package y2010round1c

// Solution for Google code jam 2009 Round 1C Problem B: Center of Mass
// https://code.google.com/codejam/contest/189252/dashboard#s=p1

object RopeIntranet {

  def log(s : => String) {
    println(s)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val n = lines.next.toInt
    val wires = (0 until n).map(index => {
      lines.next.split(" ").map(_.toInt)
    })
    val crossings = for (w1 <- wires;
                         w2 <- wires;
                         if w1(0) > w2(0) && w1(1) < w2(1)) yield (w1, w2)
    s"${crossings.length}"
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """2
        |3
        |1 10
        |5 5
        |7 7
        |2
        |1 1
        |2 2""".stripMargin.lines,
      """Case #1: 2
        |Case #2: 0""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}
