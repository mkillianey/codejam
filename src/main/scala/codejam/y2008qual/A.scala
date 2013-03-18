package codejam.y2008qual

import io.Source
import java.io.{File, FileOutputStream, PrintStream}

// Solution for Google code jam 2008 Qualification Round Problem A: Saving the Universe
// http://code.google.com/codejam/contest/32013/dashboard#s=p0

object AppA {

  def solveCase(lines : Iterator[String]) : String = {
    val S = lines.next().toInt
    val engines = lines.take(S).toList
    val Q = lines.next().toInt
    val queries = lines.take(Q).toList

    val switches = new collection.mutable.HashMap[String, Int]
    engines.foreach(switches(_) = 0)
    queries.reverse.foreach(q => {
      switches(q) = switches.filterKeys(_ != q).values.min + 1
    })
    switches.values.min.toString
  }

  def main(args : Array[String]) {
    val runner = new codejam.SolverRunner(solveCase)
    runner.pollDirectory(new File("."))
  }
}

// Tests

import org.scalatest.FunSuite

class ASpec extends FunSuite {

  test("input1") {
    val input = """5
                  |Yeehaw
                  |NSM
                  |Dont Ask
                  |B9
                  |Googol
                  |10
                  |Yeehaw
                  |Yeehaw
                  |Googol
                  |B9
                  |Googol
                  |NSM
                  |B9
                  |NSM
                  |Dont Ask
                  |Googol""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "1")
  }

  test("input2") {
    val input = """5
                  |Yeehaw
                  |NSM
                  |Dont Ask
                  |B9
                  |Googol
                  |7
                  |Googol
                  |Dont Ask
                  |NSM
                  |NSM
                  |Yeehaw
                  |Yeehaw
                  |Googol""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "0")
  }

}