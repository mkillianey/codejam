package codejam
package y2013qual

import com.google.common.collect.HashMultiset
import scala.collection.JavaConversions._

object Treasure {

  def log(msg : => String) {
    System.out.println(msg)
    System.out.flush()
  }

  type Key = Int
  case class Chest(index : Int, keyToOpen : Key, treasureKeys : Seq[Key]) {
    override def toString = s"Chest#${index}: ${keyToOpen}->[${treasureKeys.mkString(",")}]"
  }

  def solveCase(lines : Iterator[String]) : String = {

    def hasEnoughKeys(keys : Seq[Key], chests : Seq[Chest]) : Boolean = {
      val keysNeeded = chests.groupBy { _.keyToOpen }.mapValues { _.size }.withDefaultValue(0)
      val keysAvailable = (keys ++ chests.flatMap { _.treasureKeys}).groupBy(k => k).mapValues { _.size }.withDefaultValue(0)
      keysNeeded.keys.forall { key => keysNeeded(key) <= keysAvailable(key)  }
    }

    def allChestsReachable(keys : Seq[Key], chests : Seq[Chest]) : Boolean = {
      if (chests.isEmpty) {
        true
      } else if (keys.isEmpty) {
        false
      } else {
        val (openable, unopenable) = chests.partition(chest => keys.contains(chest.keyToOpen))
        allChestsReachable(openable.flatMap { _.treasureKeys }, unopenable)
      }
    }

    def solve(keys : Seq[Key], locked : Seq[Chest], unlocked : List[Chest]) : Option[List[Chest]] = {
      if (locked.isEmpty) {
        return Some(unlocked.reverse)
      }
      if (!allChestsReachable(keys, locked)) {
        return None
      }
      locked.filter{ chest => keys.contains(chest.keyToOpen) }.toStream.flatMap(chest => {
        solve(
            (keys ++ chest.treasureKeys) diff Seq(chest.keyToOpen),
            locked diff Seq(chest),
            chest :: unlocked)
      }).headOption
    }

    val Array(numKeys, numChests) = lines.next().split(" ").map(_.toInt)
    val initialKeys = lines.next().split(" ").map(_.toInt)
    val chests = (1 to numChests).toSeq.map(i => {
      val pieces = lines.next().split(" ").map(_.toInt)
      Chest(i, pieces(0), pieces.drop(2))
    })
    if (!hasEnoughKeys(initialKeys, chests)) {
      "IMPOSSIBLE"
    } else {
      solve(initialKeys, chests, List()) match {
        case Some(orderingOfChests) => orderingOfChests.map(_.index).mkString(" ")
        case None => "IMPOSSIBLE"
      }
    }
  }

  def main(args: Array[String]) {
    val runner = new SolverRunner(solveCase)
    runner.testSamples(
      """3
        |1 4
        |1
        |1 0
        |1 2 1 3
        |2 0
        |3 1 2
        |3 3
        |1 1 1
        |1 0
        |1 0
        |1 0
        |1 1
        |2
        |1 1 1
        |""".stripMargin.lines,
      """Case #1: 2 1 4 3
        |Case #2: 1 2 3
        |Case #3: IMPOSSIBLE""".stripMargin.lines
    )
    runner.pollDirectory(".")
  }
}