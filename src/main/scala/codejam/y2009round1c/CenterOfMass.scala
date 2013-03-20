package codejam
package y2009round1c

// Solution for Google code jam 2009 Round 1C Problem B: Center of Mass
// https://code.google.com/codejam/contest/189252/dashboard#s=p1

object CenterOfMass {

  class Point3D(val x : Double, val y : Double, val z : Double) {
    def +(other : Point3D) = new Point3D(x + other.x, y + other.y, z + other.z)
    def *(t : Double) = new Point3D(x * t, y * t, z * t)
    def distance = Math.sqrt(x * x + y * y + z * z)
  }

  def log(msg : => String) {
    //println(msg)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val n = lines.next.toInt
    val flies = (1 to n).map(_ => {
      val vs = lines.next.split(" ").map(_.toDouble)
      (new Point3D(vs(0), vs(1), vs(2)), new Point3D(vs(3), vs(4), vs(5)))
    })
    val center = flies.reduce((fly1, fly2) => ((fly1._1 + fly2._1), (fly1._2 + fly2._2)))
    def distanceAt(t : Double) = (center._1 + center._2 * t).distance / n

    val delta = 0.00000001
    def findMinimum(tlo : Double, thi : Double) : (Double, Double) = {
      val dlo = distanceAt(tlo)
      val dhi = distanceAt(thi)
      if ((thi - tlo).abs < delta && (dhi - dlo).abs < delta) {
        log(s"f(${tlo})=${dlo}, f(${thi})=${dhi}")
        if (dlo <= dhi) (dlo, tlo) else (dhi, thi)
      } else {
        val tmid = (tlo + thi) / 2
        val dmid = distanceAt(tmid)
        log(s"f(${tlo})=${dlo}, f(${tmid})=${dmid}, f(${thi})=${dhi}")
        if (dlo < dmid && dlo < dhi) {
          findMinimum(tlo, (tlo + 2 * thi) / 3)
        } else if (dhi < dlo && dhi < dmid) {
          findMinimum((2 * tlo + thi) / 3, thi)
        } else {
          findMinimum((5 * tlo + thi) / 6, (tlo + 5 * thi) / 6)
        }
      }
    }
    val (dist, time) = findMinimum(0, 1e50)
    f"$dist%1.8f $time%1.8f"
  }


  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |3
        |3 0 -4 0 0 3
        |-3 -2 -1 3 0 0
        |-3 -1 2 0 3 0
        |3
        |-5 0 0 1 0 0
        |-7 0 0 1 0 0
        |-6 3 0 1 0 0
        |4
        |1 2 3 1 2 3
        |3 2 1 3 2 1
        |1 0 0 0 0 -1
        |0 10 0 0 -10 -1""".stripMargin.lines,
      """Case #1: 0.00000000 1.00000000
        |Case #2: 1.00000000 6.00000000
        |Case #3: 3.36340601 1.00000000""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}

