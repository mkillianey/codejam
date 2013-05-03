package codejam
package y2013round1a

import scala._
import scala.annotation.tailrec

object Bullseye {

  /*-
      r     paint needed at r
      0     1         = 1
      1     4  -  1   = 3
      2     9  -  4   = 5
      3     16 -  9   = 7
      4     25 - 16   = 9
      5     36 - 25   = 11
      6     49 - 36   = 13
      ..
      n     (n+1)^2 - (n^2) = 2n + 1
   */

  @tailrec
  def countRings(radius : Long, paint : Long, accumulator : Long) : Long = {
    val paintForRadius = 2 * radius + 1
    if (paintForRadius > paint) {
      accumulator
    } else {
      countRings(radius+2, paint - paintForRadius, accumulator+1)
    }
  }

  def solveCase(lines : Iterator[String]) : String = {
    val Array(startRadius, startPaint) = lines.next.split(" ").map(_.toLong)

    countRings(startRadius, startPaint, 0).toString
  }

  /*-
     r    rings up to (and including) r
     0         1
     1         3
     2         6 (1 + 5)
     3         10 (3 + 7)
     4         15 (1 + 5 + 9)
     5         21 (3 + 7 + 11)
     ...
     n         (n+1)*(n+2)/2

     In that case, the solution is

         paint                       >= (n+1)*(n+2)/2 - r*(r-1)/2
         2*paint                     >= (n+1)*(n+2) - r*(r-1)
         2*paint + r*(r-1)           >= n^2 + 3n + 2
         2*paint + r*(r-1)           >= n^2 + 3n + 2.25 - 0.25
         2*paint + r*(r-1)           >= (n + 1.5)^2 - 0.25
         2*paint + r*(r-1) + 0.25    >= (n + 1.5)^2

         sqrt(2*paint + r*(r-1) + 0.25)       >= n + 1.5
         sqrt(2*paint + r*(r-1) + 0.25) - 1.5 >= n
   */

  def solveCaseFaster(lines : Iterator[String]) : String = {
    val Array(radius, paint) = lines.next.split(" ").map(BigInt(_))

    def isEven(b : BigInt) = b.testBit(0)
    def paintNeededFor(r : BigInt) : BigInt = ((r+1)*(r+2) - (radius*(radius-1))) / 2

    var maxRadius =
      BigInt((Math.sqrt((2*paint + radius*(radius-1)).toDouble + 0.25) - 1.5).toLong)

    maxRadius = if (radius.testBit(0))    // if radius is odd
      maxRadius.setBit(0)                 // maxRadius can only take on odd values
    else                                  // else
      maxRadius.clearBit(0)               // maxRadius can only take on even values

    while (paintNeededFor(maxRadius) < paint) {
      //println(s"Guess of ${maxRadius} *might* be too low")
      maxRadius += 2
    }
    while (paintNeededFor(maxRadius) > paint) {
      //println(s"Guess of ${maxRadius} is definitely too high")
      maxRadius -= 2
    }
    val rings = (maxRadius - radius)/2 + 1
    rings.toString
  }


  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCaseFaster)
    runner.testSamples(
      """5
        |1 9
        |1 10
        |3 40
        |10000000000000000 1000000000000000000
        |1 1000000000000000000
        |""".stripMargin.lines,
      """Case #1: 1
        |Case #2: 2
        |Case #3: 3
        |Case #4: 49
        |Case #5: 707106780""".stripMargin.lines
    )
    runner.timeCase("biggest1", List("1 2000000000000000000").toIterator)
    runner.timeCase("biggest2", List("1 2000000000000000000").toIterator)
    runner.timeCase("biggest3", List("1 2000000000000000000").toIterator)
    runner.pollDirectory(".")
  }
}
