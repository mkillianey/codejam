package codejam
package y2013qual

object Lawnmower {
  def log(msg : => String) {
    println(msg)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val Array(n, m) = lines.next.split(" ").map(_.toInt)
    val lawn = lines.take(n).map(_.split(" ").map(_.toInt)).toArray

    val maxInRow = (0 until n).map(row => (0 until m).map(lawn(row)(_)).max)
    val maxInColumn = (0 until m).map(column => (0 until n).map(lawn(_)(column)).max)

    for (
      row <- (0 until n) ;
      column <- (0 until m) ;
      square = lawn(row)(column) ;
      if (square != maxInRow(row) && square != maxInColumn(column))
    ) {
      return "NO"
    }
    return "YES"
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |3 3
        |2 1 2
        |1 1 1
        |2 1 2
        |5 5
        |2 2 2 2 2
        |2 1 1 1 2
        |2 1 2 1 2
        |2 1 1 1 2
        |2 2 2 2 2
        |1 3
        |1 2 1
        |""".stripMargin.lines,
      """Case #1: YES
        |Case #2: NO
        |Case #3: YES""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}