package codejam.practice

// Solution for Google code jam Practice Problems Problem A: Alien Numbers
// https://code.google.com/codejam/contest/32003/dashboard#s=p0

object AppA extends App {

  def solveCase(lines : Iterator[String]) : String = {
    val pieces = lines.next().split(" ").map(_.trim)

    val fromDigits = pieces(1).toCharArray
    val fromBase = fromDigits.length
    val fromLang = fromDigits.zip(0 until fromBase).toMap

    val toDigits = pieces(2).toCharArray
    val toBase = toDigits.length
    val toLang = (0 until toBase).zip(toDigits).toMap

    def decode(chs : Iterator[Char], accumulator : Int) : Int = {
      if (chs.hasNext) decode(chs, accumulator * fromBase + fromLang(chs.next))
      else accumulator
    }

    def encode(n : Int, sb : StringBuilder) : StringBuilder = {
      val d = n / toBase
      val m = n % toBase
      if (d != 0)
        encode(d, sb)
      sb.append(toLang(m))
    }

    val num = decode(pieces(0).toCharArray.iterator, 0)
    encode(num, new StringBuilder).toString
  }

  new codejam.SolverRunner(solveCase).pollDirectory(".")
}

// Tests

import org.scalatest.FunSuite

class ASpec extends FunSuite {

  test("input1") {
    val input = """9 0123456789 oF8""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "Foo")
  }

  test("input2") {
    val input = """Foo oF8 0123456789""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "9")
  }

  test("input3") {
    val input = """13 0123456789abcdef 01""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "10011")
  }

  test("input4") {
    val input = """CODE O!CDE? A?JM!.""".stripMargin.lines
    val output = AppA.solveCase(input)
    assert(output === "JAM!")
  }

}