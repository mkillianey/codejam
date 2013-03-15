package codejam.y2008qual


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