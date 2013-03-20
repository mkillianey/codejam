package codejam
package y2009round1c

// Solution for Google code jam 2009 Round 1C Problem A: All Your Base
// https://code.google.com/codejam/contest/189252/dashboard#s=p0

object AllYourBase {

  def solveCase(lines : Iterator[String]) : String = {
    val line = lines.next
    val base = line.toSet.size.max(2)
    val digits = line.foldLeft(Map[Char, Long]()) ((vs, ch) => vs.get(ch) match {
        case Some(n) => vs
        case None => vs + (vs.size match {
          case 0 => (ch -> 1)
          case 1 => (ch -> 0)
          case n => (ch -> n)
        })
      })
    val result = line.foldLeft(0L) ((n, ch) => (n * base + digits(ch))).toString
    result
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |11001001
        |cats
        |zig""".stripMargin.lines,
      """Case #1: 201
        |Case #2: 75
        |Case #3: 11""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}