package codejam
package y2013qual

import scala._

object FairAndSquare {

  case class Palindrome(length : Int) {
    val digits = new Array[Int](length)
    val midpoint = (length - 1) / 2

    def squared = { val b = BigInt(digits.mkString); b * b }

    def incrementAt(index : Int) {
      val digit = digits(index) + 1
      val mirrorIndex = length-1 - index
      digits(index) = digit
      for (i <- index+1 to mirrorIndex-1) { digits(i) = 0 }
      digits(mirrorIndex) = digit
    }

    override def toString = digits.mkString
  }

  def isFair(b : BigInt) = { val s = b.toString ; s == s.reverse }

  def solveCase(lines : Iterator[String]) : String = {
    val Array(a, b) = lines.next.split(" ").map(BigInt(_))
    val aDigits = (a.toString.length + 1) / 2
    val bDigits = (b.toString.length / 2) + 1
    var found = 0
    for (numDigits <- aDigits to bDigits) {
      val palindrome = Palindrome(numDigits)

      def findFairSquare(digitToIncrement : Int) : Stream[BigInt] = {
        palindrome.incrementAt(digitToIncrement)
        val square = palindrome.squared
        if (isFair(square)) {
          square #:: findFairSquare(palindrome.midpoint) // found one!  start again at midpoint
        } else if (digitToIncrement == 0) {
          Stream.empty // ran out of digits to mess with
        } else {
          findFairSquare(digitToIncrement - 1) // try the next digit over
        }
      }

      for (fairSquare <- findFairSquare(0)) {
        if (fairSquare < a) {
          // don't count it yet
        } else if (fairSquare > b) {
          return found.toString
        } else {
          found += 1
        }
      }
    }
    found.toString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |1 4
        |10 120
        |100 1000
        |""".stripMargin.lines,
      """Case #1: 2
        |Case #2: 0
        |Case #3: 2""".stripMargin.lines
    )
    val powersOfTen = "100" :: (1 to 100).toList.map { i => s"1 1${new Array[Int](i).mkString}" }
    runner.solveAll(powersOfTen.iterator, print)

    runner.pollDirectory(".")
  }
}