package codejam.y2013round1c

import codejam.SolverRunner
import scala.collection.mutable
import com.google.common.base.Splitter

// Solution for Google code jam 2013 Round 1C Problem A

object Consonants {

  def log( msg : => String) {
    println(msg)
  }

  def isVowel(ch : Char) =
    (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u')

  def solveCase(lines : Iterator[String]) : String = {
    val pieces = lines.next.split(" ")
    val word = pieces(0)
    val wordChars = word.toCharArray
    val n = pieces(1).toInt

    def firstConsonantRunEndsAt(index : Int, needed : Int) : Option[Int] = {
      if (needed == 0) {
        Some(index)
      } else if (index >= wordChars.length) {
        None
      } else if (isVowel(wordChars(index))) {
        firstConsonantRunEndsAt(index+1, n)
      } else {
        firstConsonantRunEndsAt(index+1, needed-1)
      }
    }

    var nValue : Long = 0
    var endsAt = firstConsonantRunEndsAt(0, n)
    for {
      startIndex <- 0 until wordChars.length
      if endsAt.isDefined
    } {
      if (endsAt.isDefined && startIndex + n > endsAt.get) {
        endsAt = firstConsonantRunEndsAt(endsAt.get, 1)
      }
      if (endsAt.isDefined) {
        nValue += wordChars.length - endsAt.get + 1
      }
    }
    nValue.toString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """4
        |quartz 3
        |straight 3
        |gcj 2
        |tsetse 2""".stripMargin.lines,
      """Case #1: 4
        |Case #2: 11
        |Case #3: 3
        |Case #4: 11""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }

}
