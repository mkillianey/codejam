package codejam.y2009round1c

// Solution for Google code jam 2009 Round 1C Problem A: All Your Base
// https://code.google.com/codejam/contest/189252/dashboard#s=p0

object AppA extends App {

  def log(msg : => String) {
    println(msg)
  }

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
    log(s"${line}=${result} in base ${base}: ${digits}")
    result
  }

  new codejam.SolverRunner(solveCase).pollDirectory(".")
}

// Tests

import org.scalatest.FunSuite

class ASpec extends FunSuite {

  test("input1") {
    val input = """11001001""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "201")
  }

  test("input2") {
    val input = """cats""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "75")
  }

  test("input3") {
    val input = """zig""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "11")
  }

}