package codejam
package practice

// Solution for Google code jam Practice Problems Problem A: Alien Numbers
// https://code.google.com/codejam/contest/32003/dashboard#s=p0

object AlienNumbers {

  def solveCase(lines : Iterator[String]) : String = {
    val pieces = lines.next().split(" ").map(_.trim)

    val fromDigits = pieces(1).toCharArray
    val fromBase = fromDigits.length
    val fromLang = fromDigits.zip(0 until fromBase).toMap

    val toDigits = pieces(2).toCharArray
    val toBase = toDigits.length
    val toLang = (0 until toBase).zip(toDigits).toMap

    def decode(chs : Iterator[Char], accumulator : Int) : Int = {
      if (chs.hasNext) decode(chs, accumulator * fromBase + fromLang(chs.next()))
      else accumulator
    }

    def encode(n : Int, sb : StringBuilder) : StringBuilder = {
      val d = n / toBase
      val m = n % toBase
      if (d != 0)
        encode(d, sb)
      sb.append(toLang(m))
    }
    val encodedNumber = pieces(0).toCharArray
    val num = decode(encodedNumber.iterator, 0)
    encode(num, new StringBuilder).toString()
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
        """4
          |9 0123456789 oF8
          |Foo oF8 0123456789
          |13 0123456789abcdef 01
          |CODE O!CDE? A?JM!.""".stripMargin.lines,
        """Case #1: Foo
          |Case #2: 9
          |Case #3: 10011
          |Case #4: JAM!""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}
