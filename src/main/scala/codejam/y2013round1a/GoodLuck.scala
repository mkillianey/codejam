package codejam
package y2013round1a

import codejam.SolverRunner

// Solution for Google code jam 2013 Round 1 Problem C: GoodLuck
// https://code.google.com/codejam/contest/2418487/dashboard#s=p2

object GoodLuck {

  def log(msg : => String) {
    // println(msg)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val Array(r /*numCases*/,
              n /*numbersToPick*/,
              m /*maxNumber*/,
              k /*numProducts*/) = lines.next.split(" ").map(_.toInt)

    val occurrences = new collection.mutable.HashMap[List[Int], Int]().withDefaultValue(0)

    def populate(nLeft : Int, nPicked : List[Int]) {
      nLeft match {
        case 0 => {
          val sortedPicked = nPicked.sorted
          occurrences(sortedPicked) += 1
        }
        case _ => {
          for (i <- (2 to m)) {
            populate(nLeft-1, i :: nPicked)
          }
        }
      }
    }
    populate(n, List())

    def possible(product : Int, factors : List[Int]) : Boolean = {
      if (product == 1) {
        true
      } else if (factors.isEmpty) {
        false
      } else if ((product % factors.head == 0) && possible(product / factors.head, factors.tail)) {
        true
      } else {
        possible(product, factors.dropWhile { f => f == factors.head })
      }
    }

    println(s"Different permutations: ${occurrences.size}")

    (1 to r).map { x => {
      val products = lines.next.split(" ").map(_.toInt)
      val possibilities = for {
        o <- occurrences
        if products.forall { p => possible(p, o._1) }
      } yield o
      val answer = possibilities.maxBy(_._2)._1.mkString("")
      "\n" + answer
    }}.mkString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """1
        |2 3 4 4
        |9 4 36 1
        |1 1 1 1""".stripMargin.lines,
      """Case #1:
        |343
        |222""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}