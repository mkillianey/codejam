package codejam.y2013round1c

import codejam.SolverRunner
import com.google.common.collect.{RangeMap, Range, TreeRangeMap}
import scala.collection.JavaConversions._

// Solution for Google code jam 2013 Round 1C Problem C

object TheGreatWall {

  def log( msg : => String) {
    println(msg)
  }

  case class Attack(day : Int,
                    position : Range[Integer],
                    strength : Int)

  case class Tribe(index : Int,
                   startDay : Int,
                   numAttacks : Int,
                   position : Range[Integer],
                   startStrength : Int,
                   deltaDay : Int,
                   deltaPosition : Int,
                   deltaStrength : Int) {

    def attacks() : List[Attack] =
      (0 until numAttacks).map {
        index => {
           Attack(startDay + index * deltaDay,
                  Range.closed(
                    position.lowerEndpoint() + index * deltaPosition,
                    position.upperEndpoint() + index * deltaPosition),
                  startStrength + index * deltaStrength
          )
        }
      }.toList

  }

  def solveCase(lines : Iterator[String]) : String = {
    val numTribes = lines.next.toInt
    val tribes = (1 to numTribes).map {
      index => {
        val Array(a, b, c, d, e, f, g, h) = lines.next.split(" ").map(_.toInt)
        val pos = Range.closed(Integer.valueOf(c), Integer.valueOf(d))
        val tribe = Tribe(index, a, b, pos, e, f, g, h)
        //log(s"Tribe $index is $tribe")
        tribe
      }
    }
    val attacks = tribes.flatMap(_.attacks())

    val battlefield = attacks.map(_.position).reduce((p1, p2) => p1.span(p2))
    val wall = TreeRangeMap.create[Integer, Integer]()
    wall.put(battlefield, 0) // initialize

    val attacksByDay = attacks.groupBy(_.day)

    var numSuccessfulAttacks = 0
    for (day <- attacksByDay.keySet.toList.sorted) {
      //log(s"On day $day, there are ${attacksByDay(day)} attacks")
      // check for success
      val wallPartsToRaise : RangeMap[Integer, Integer] = TreeRangeMap.create()
      for (attack <- attacksByDay(day).sortBy(_.strength)) {
        val attackedWall = wall.subRangeMap(attack.position)
        var success = false
        attackedWall.asMapOfRanges().entrySet().foreach { entry => {
          if (entry.getValue < attack.strength) {
            success = true
            wallPartsToRaise.put(entry.getKey, attack.strength)
          }
        }}
        if (success) {
          //log(s"On day $day, attack $attack was successful")
          numSuccessfulAttacks += 1
        } else {
          //log(s"On day $day, attack $attack failed")
        }
      }
      // rebuild sections of the wall
      wall.putAll(wallPartsToRaise)
      //log(s"Wall is $wall")
    }
    numSuccessfulAttacks.toString
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """2
        |2
        |0 3 0 2 10 2 3 -2
        |10 3 2 3 8 7 2 0
        |3
        |1 2 0 5 10 2 8 0
        |0 3 0 1 7 1 2 2
        |3 3 0 5 1 1 4 0""".stripMargin.lines,
      """Case #1: 5
        |Case #2: 6
        |""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }

}
