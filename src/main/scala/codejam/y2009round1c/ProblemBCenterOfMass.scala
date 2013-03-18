package codejam.y2009round1c

// Solution for Google code jam 2009 Round 1C Problem B: Center of Mass
// https://code.google.com/codejam/contest/189252/dashboard#s=p1

object AppB extends App {

  class Point3D(val x : Double, val y : Double, val z : Double) {
    def +(other : Point3D) = new Point3D(x + other.x, y + other.y, z + other.z)
    def *(t : Double) = new Point3D(x * t, y * t, z * t)
    def distance = Math.sqrt(x * x + y * y + z * z)
  }

  def log(msg : => String) {
    println(msg)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val n = lines.next.toInt
    val flies = (1 to n).map(_ => {
      val vs = lines.next.split(" ").map(_.toDouble)
      (new Point3D(vs(0), vs(1), vs(2)), new Point3D(vs(3), vs(4), vs(5)))
    })
    val center = flies.reduce((fly1, fly2) => ((fly1._1 + fly2._1), (fly1._2 + fly2._2)))
    def distanceAt(t : Double) = (center._1 + center._2 * t).distance

    val delta = 0.00000001
    def findMinimum(lo : Double, hi : Double) : (Double, Double) = {
      val dlo = distanceAt(lo)
      val dhi = distanceAt(hi)
      val mid = (lo + hi) / 2
      val dmid = distanceAt(mid)
      if ((hi - lo).abs < delta && (dhi - dlo).abs < delta) {
        (dmid / n, mid)
      } else {
        //log(s"f(${lo})=${dlo}, f(${mid})=${dmid}, f(${hi})=${dhi}")
        if (dlo <= dmid && dlo <= dhi) {
          findMinimum(lo, (lo + 2 * hi) / 3)
        } else if (dhi <= dlo && dhi <= dmid) {
          findMinimum((2 * lo + hi) / 3, hi)
        } else {
          findMinimum((5 * lo + hi) / 6, (lo + 5 * hi) / 6)
        }
      }
    }
    val (dist, pos) = findMinimum(0, 1e50)
    f"$dist%1.8f $pos%1.8f"
  }

  new codejam.SolverRunner(solveCase).pollDirectory(".")
}

// Tests

import org.scalatest.FunSuite

class BSpec extends FunSuite {

  test("input1") {
    val input = """3
                  |3 0 -4 0 0 3
                  |-3 -2 -1 3 0 0
                  |-3 -1 2 0 3 0""".stripMargin.lines
    val output = AppB.solveCase(input)
    assert(output === "0.00000000 1.00000000")
  }

  test("input2") {
    val input = """3
                  |-5 0 0 1 0 0
                  |-7 0 0 1 0 0
                  |-6 3 0 1 0 0""".stripMargin.lines
    val output = AppB.solveCase(input)
    assert(output === "1.00000000 6.00000000")
  }

  test("input3") {
    val input = """4
                  |1 2 3 1 2 3
                  |3 2 1 3 2 1
                  |1 0 0 0 0 -1
                  |0 10 0 0 -10 -1""".stripMargin.lines
    val output = AppB.solveCase(input)
    assert(output === "3.36340601 1.00000000")
  }

}