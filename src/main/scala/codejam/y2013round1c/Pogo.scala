package codejam.y2013round1c

import codejam.SolverRunner

// Solution for Google code jam 2013 Round 1C Problem B

object Pogo {

  def log( msg : => String) {
    println(msg)
  }

  def solveCaseSmall(lines : Iterator[String]) : String = {
    val Array(destX, destY) = lines.next.split(" ").map(_.toInt)

    var sb = new StringBuilder()
    for (i <- 0 until destX) {
      sb.append("WE")
    }
    for (i <- 0 until destX by -1) {
      sb.append("EW")
    }
    for (i <- 0 until destY) {
      sb.append("SN")
    }
    for (i <- 0 until destY by -1) {
      sb.append("NS")
    }
    sb.toString().drop(1)  // don't need to do first hop in wrong direction!
  }

  /*
     To get as far as (x, y), you must pogo at least x+y spaces.

     After n pogos, you have gone 1+2+...n = n*(n+1)/2 spaces, so:

        |x| + |y| <= n*(n+1)/2
        2*|x| + 2*|y| <= n^2 + n
        2*|x| + 2*|y| + 0.25 <= n^2 + n + 0.25
        |x| + |y| + 0.25 <= (n+0.5)^2
        sqrt(|x| + |y| + 0.25) <= n + 0.5
        sqrt(|x| + |y| + 0.25) - 0.5 <= n
   */
  def minSolutionLength(x : Int, y : Int) : Int =
    Math.ceil(Math.sqrt(((2*x).abs + (2*y).abs).toDouble + 0.25) - 0.5).toInt

  case class Direction(dx : Int, dy : Int, ch : Char)

  val NORTH = Direction(0, 1, 'N')
  val SOUTH = Direction(0, -1, 'S')
  val EAST = Direction(1, 0, 'E')
  val WEST = Direction(-1, 0, 'W')

  def solveCase(lines : Iterator[String]) : String = {
    val Array(destX, destY) = lines.next.split(" ").map { _.toInt }

    def pogoFrom(x : Int, y : Int, n : Int, hops : List[Char]) : Option[List[Char]] = {
      if (n == 0) {
        if (x == 0 && y == 0)
          Some(hops)
        else
          None
      } else {
        val direction = if (x.abs > y.abs) {
          // east or west
          if (x > 0) EAST else WEST
        } else {
          if (y > 0) NORTH else SOUTH
        }
        pogoFrom(x - n * direction.dx, y - n * direction.dy, n-1, direction.ch :: hops)
      }
    }

    (for {
      n <- Stream.from(minSolutionLength(destX, destY)).toIterable
      hops <- pogoFrom(destX, destY, n, List())
    } yield hops).mkString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """2
        |3 4
        |-3 4""".stripMargin.lines,
      """Case #1: ENWSEN
        |Case #2: ENSWN
        |""".stripMargin.lines
    )
    runner.testSamples(
      """2
        |100 100
        |-93 5
        |""".stripMargin.lines,
      """Case #1: ENWSEN
        |Case #2: ENSWN
        |""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }

}
