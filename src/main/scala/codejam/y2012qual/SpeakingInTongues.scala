package codejam
package y2012qual

// Solution for Google code jam 2012 Qualification Round Problem A: Speaking in Tongues
// https://code.google.com/codejam/contest/1460488/dashboard#s=p0

object SpeakingInTongues {

  // The problem gives us one mapping (a zoo -> y qee), and the rest are from the sample
  val givenSeeds = Map(
    "a zoo" -> "y qee",
    "ejp mysljylc kd kxveddknmc re jsicpdrysi" -> "our language is impossible to understand",
    "rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd" -> "there are twenty six factorial possibilities",
    "de kr kd eoya kw aej tysr re ujdr lkgc jv" -> "so it is okay if you want to just give up")
  val givenMapping = givenSeeds.flatMap(e => e._1.zip(e._2)).toMap

  // We have one missing key...what is it?
  val missingKeys = (('a' to 'z').toSet -- givenMapping.keys)
  val missingValues = (('a' to 'z').toSet -- givenMapping.values)
  assert(missingKeys.size == 1, s"Missing keys: $missingKeys not size 1")
  assert(missingValues.size == 1, s"Missing values: $missingValues not size 1")

  // Total mapping includes the extra key
  val totalMapping = givenMapping + (missingKeys.head -> missingValues.head)

  def solveCase(lines : Iterator[String]) : String = {
    lines.next.map(totalMapping)
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.solveCase(List(('a' to 'z') mkString "").iterator)
    runner.testSamples(
      """3
        |ejp mysljylc kd kxveddknmc re jsicpdrysi
        |rbcpc ypc rtcsra dkh wyfrepkym veddknkmkrkcd
        |de kr kd eoya kw aej tysr re ujdr lkgc jv""".stripMargin.lines,
      """Case #1: our language is impossible to understand
        |Case #2: there are twenty six factorial possibilities
        |Case #3: so it is okay if you want to just give up""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}