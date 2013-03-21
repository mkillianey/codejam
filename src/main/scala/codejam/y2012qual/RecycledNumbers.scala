package codejam
package y2012qual


// Solution for Google code jam 2012 Qualification Round Problem C: Recycled Numbers
// https://code.google.com/codejam/contest/1460488/dashboard#s=p2

object RecycledNumbers {

  def solveCase(lines: Iterator[String]) = {
    val Array(a, b) = lines.next.split(" ").map(_.toInt)
    val numDigits = a.toString.length

    def rotate(n: Int): (Int => Int) = {
      val s = n.toString
      (places: Int) => (s.drop(places) + s.take(places)).toInt
    }

    val pairs = for (n <- (a until b);
                     m <- (1 until numDigits).map(rotate(n));
                     if (n < m) && (m <= b)) yield (n, m)
    s"${pairs.toSet.size}"
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """4
        |1 9
        |10 40
        |100 500
        |1111 2222""".stripMargin.lines,
      """Case #1: 0
        |Case #2: 3
        |Case #3: 156
        |Case #4: 287""".stripMargin.lines
    )
    runner.testSamples(// Just for timing
      """2
        |100000 200000
        |1000000 2000000""".stripMargin.lines,
      """Case #1: 24930
        |Case #2: 299997""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}