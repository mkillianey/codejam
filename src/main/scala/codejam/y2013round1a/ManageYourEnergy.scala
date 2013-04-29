package codejam.y2013round1a

import codejam.SolverRunner
import scala.::


// Solution for Google code jam 2013 Round 1 Problem B: MaximumEnergy
// https://code.google.com/codejam/contest/2418487/dashboard#s=p1

object ManageYourEnergy {

  def log(msg : => String) {
    // println(msg)
  }

  def solveCase(lines : Iterator[String]) : String = {
    val Array(maxEnergy, regenerationParam, numActivities) = lines.next.split(" ").map(_.toLong)
    val regeneration = maxEnergy.min(regenerationParam)
    log(s"MaxEnergy=$maxEnergy, regeneration=$regeneration")

    val allActivities = lines.next.split(" ").map(_.toLong).toList

    allActivities.tails.foldLeft((maxEnergy, 0.toLong)) {
      case ((energy, gain), activities) if !activities.isEmpty => {
        log(s"  Energy=$energy, gain=$gain, activities:  ${activities.mkString(", ")}")
        val activity = activities.head
        activities.indexWhere { _ > activity } match {
          case -1 => {
            log(s"  Spending $energy on activity for gain of ${energy*activity}")
            (regeneration, gain + energy*activity)
          }
          case distance => {
            val energyToSave = 0.toLong.max(maxEnergy - distance*regeneration)
            val energyToSpend = 0.toLong.max(energy - energyToSave)
            log(s"  Found better activity at distance $distance, reserving $energyToSave and spending $energyToSpend")
            (energy - energyToSpend + regeneration, gain + energyToSpend*activity)
          }
        }
      }
      case ((energy, gain), _) => {
        log(s"Final energy=$energy, total gain=$gain")
        (energy, gain)
      }
    }._2.toString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |5 2 2
        |2 1
        |5 2 2
        |1 2
        |3 3 4
        |4 1 3 5""".stripMargin.lines,
      """Case #1: 12
        |Case #2: 12
        |Case #3: 39""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}