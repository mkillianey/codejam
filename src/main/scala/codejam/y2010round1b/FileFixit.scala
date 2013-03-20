package codejam
package y2010round1b

// Solution for Google code jam 2009 Round 1C Problem B: Center of Mass
// https://code.google.com/codejam/contest/189252/dashboard#s=p1

object FileFixit {

  def solveCase(lines : Iterator[String]) : String = {
    val Array(n, m) = lines.next.split(" ").map(_.toInt)
    val existing = (0 until n).map(_ => lines.next)
    val desired = (0 until m).map(_ => lines.next)
    def subs(s : String) : List[String] = {
      val n = s.lastIndexOf('/')
      if (n > 0)
        s :: subs(s.take(n))
      else
        List(s)
    }
    val allExisting = existing.flatMap(subs).toSet
    val allDesired = desired.flatMap(subs).toSet
    val needed = allDesired -- allExisting
    s"${needed.size}"
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |0 2
        |/home/gcj/finals
        |/home/gcj/quals
        |2 1
        |/chicken
        |/chicken/egg
        |/chicken
        |1 3
        |/a
        |/a/b
        |/a/c
        |/b/b""".stripMargin.lines,
      """Case #1: 4
        |Case #2: 0
        |Case #3: 4""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}
