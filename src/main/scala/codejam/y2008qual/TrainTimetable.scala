package codejam.y2008qual

// Solution for Google code jam 2008 Qualification Round Problem B. Train Timetable
// http://code.google.com/codejam/contest/32013/dashboard#s=p1

object TrainTimetable {

  abstract class Trip (val start : Int, val end : Int)
  case class AtoB (override val start : Int, override val end : Int) extends Trip(start, end)
  case class BtoA (override val start : Int, override val end : Int) extends Trip(start, end)

  def log(msg : => String) {
    //println(msg)
  }
  
  def solveCase(lines : Iterator[String]) : String = {

    def timeToMinutes(s : String) = {
      val pieces = s.split(":").map(_.toInt)
      pieces(0) * 60 + pieces(1)
    }

    val turnaroundTime = lines.next().toInt
    val Array(na, nb) = lines.next().split(" ").map(_.toInt)

    val trips = (0 until na + nb).map(i => {
      val Array(start, end) = lines.next().split(" ").map(timeToMinutes)
      if (i < na) new AtoB(start, end) else new BtoA(start, end)
      }).sortBy(_.start)

    trips.foreach(x => log(x.toString))

    var numTrainsThatStartedAtA = 0
    var numTrainsThatStartedAtB = 0

    var numTrainsWaitingAtA = 0
    var numTrainsWaitingAtB = 0

    val unfinished = trips.foldLeft(List[Trip]()) ((pending, trip) => {
      val (ended, enroute) = pending.partition(_.end + turnaroundTime <= trip.start)
      ended.foreach(t => t match {
          case AtoB(_, _) => numTrainsWaitingAtB += 1 ; log(s"${t} arrived at B")
          case BtoA(_, _) => numTrainsWaitingAtA += 1 ; log(s"${t} arrived at A")
        })
      trip match {
        case AtoB(_, _) =>
            if (numTrainsWaitingAtA > 0) {
              numTrainsWaitingAtA -= 1
              log(s"Took a train from A for ${trip}")
            } else {
              numTrainsThatStartedAtA += 1
              log(s"Need another train at A for ${trip}")
            }
        case BtoA(_, _) =>
          if (numTrainsWaitingAtB > 0) {
            numTrainsWaitingAtB -= 1
            log(s"Took a train from B for ${trip}")
          } else {
            numTrainsThatStartedAtB += 1
            log(s"Need another train at B for ${trip}")
          }
      }
      trip :: enroute
    })
    log(s"Unfinished trips: ${unfinished}")
    s"${numTrainsThatStartedAtA} ${numTrainsThatStartedAtB}"
  }

  def main(args : Array[String]) {
    val runner = new codejam.SolverRunner(solveCase)
    runner.testSamples(
      """2
        |5
        |3 2
        |09:00 12:00
        |10:00 13:00
        |11:00 12:30
        |12:02 15:00
        |09:00 10:30
        |2
        |2 0
        |09:00 09:01
        |12:00 12:02""".stripMargin.lines,
      """Case #1: 2 2
        |Case #2: 2 0""".stripMargin.lines)
    runner.pollDirectory(".")
}
}