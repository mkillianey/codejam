package codejam.practice

// Solution for Google code jam Practice Problems Problem B: Always Turn Left
// https://code.google.com/codejam/contest/32003/dashboard#s=p1

object AlwaysTurnLeft extends App {

  abstract class Direction
  object North extends Direction
  object South extends Direction
  object East extends Direction
  object West extends Direction

  case class Location(val row : Int, val col : Int) {
    def walk(d : Direction) = d match {
      case North => new Location(row - 1, col)
      case South => new Location(row + 1, col)
      case East => new Location(row, col + 1)
      case West => new Location(row, col - 1)
    }
  }

  case class Explorer(val loc : Location, val dir : Direction) {
    def turnLeft = dir match {
      case North => new Explorer(loc, West)
      case West => new Explorer(loc, South)
      case South => new Explorer(loc, East)
      case East => new Explorer(loc, North)
    }
    def turnRight = dir match {
      case North => new Explorer(loc, East)
      case East => new Explorer(loc, South)
      case South => new Explorer(loc, West)
      case West => new Explorer(loc, North)
    }
    def turn180 = { turnRight turnRight }

    def walk = new Explorer(loc.walk(dir), dir)

    override def toString = s"[${loc}, ${dir}]"
  }

  class Room(val loc : Location) {
    var dirs = 0
    def leave(d : Direction) = d match {
      case North => dirs |= 1
      case South => dirs |= 2
      case West => dirs |= 4
      case East => dirs |= 8
    }
    def enter(d : Direction) = d match {
      case North => dirs |= 2
      case South => dirs |= 1
      case West => dirs |= 8
      case East => dirs |= 4
    }
    override def toString = f"${dirs}%x"
  }

  def solveCase(lines : Iterator[String]) : String = {
    val pieces = lines.next().split(" ").map(_.trim)
    val (path1, path2) = (pieces(0), pieces(1))
    val entrance = new Location(-1, 0)
    val maze = new collection.mutable.HashMap[Location, Room]()
    def followPath(path : Iterator[Char], explorer : Explorer) : Explorer =
      if (path.hasNext) {
        path.next match {
          case 'L' => followPath(path, explorer.turnLeft)
          case 'R' => followPath(path, explorer.turnRight)
          case 'W' => {
            val leavingRoom = maze.getOrElseUpdate(explorer.loc, new Room(explorer.loc))
            leavingRoom.leave(explorer.dir)
            val newExplorer = explorer.walk
            val enteringRoom = maze.getOrElseUpdate(newExplorer.loc, new Room(newExplorer.loc))
            enteringRoom.enter(newExplorer.dir)
            followPath(path, newExplorer)
          }
        }
      } else explorer

    val explorerAfterPath1 = followPath(path1.iterator, new Explorer(entrance, South))
    val exit = explorerAfterPath1.loc
    val explorerAfterPath2 = followPath(path2.iterator, explorerAfterPath1.turn180)
    // explorerAfterPath2 should be at entrance
    maze.remove(entrance)
    maze.remove(exit)

    val minRow = maze.keys.map(_.row).min
    val maxRow = maze.keys.map(_.row).max
    val minCol = maze.keys.map(_.col).min
    val maxCol = maze.keys.map(_.col).max
    var sb = new StringBuilder
    (minRow to maxRow).foreach(row => {
      sb.append('\n')
      (minCol to maxCol).foreach(col => sb.append(maze(new Location(row, col)).toString))
    })
    sb.toString
  }
  new codejam.SolverRunner(solveCase).pollDirectory(".")
}

// Tests

import org.scalatest.FunSuite

class AlwaysTurnLeftSpec extends FunSuite {

  test("input1") {
    val input = """WRWWLWWLWWLWLWRRWRWWWRWWRWLW WWRRWLWLWWLWWLWWRWWRWWLW""".stripMargin.lines
    val output = AlwaysTurnLeft.solveCase(input)
    assert(output === """
                        |ac5
                        |386
                        |9c7
                        |e43
                        |9c5""".stripMargin)
  }

  test("input2") {
    val input = """WW WW""".stripMargin.lines
    val output = AlwaysTurnLeft.solveCase(input)
    assert(output === """
                        |3""".stripMargin)
  }


}