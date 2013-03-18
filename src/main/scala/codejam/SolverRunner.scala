package codejam

import io.Source
import java.io.{FileWriter, File, PrintWriter}

class SolverRunner(val solveCase : Iterator[String] => String) {

  def log(msg : => String) {
    println(msg)
  }

  def solveAll(lines : Iterator[String], writeln : String => Unit) {
    val n = lines.next().toInt
    val total = (1 to n).map(i => {
      val start = System.currentTimeMillis()
      val answer = solveCase(lines)
      val elapsedTime = System.currentTimeMillis() - start
      log(s"Solved case #${i} in ${elapsedTime} millisec")
      writeln(s"Case #${i}: ${answer}")
      elapsedTime
    }).sum
    log(s"Finished ${n} cases in ${total} millisec")
  }

  def using[A <: { def close() }, B](resource: A) (block: A => B) {
    try {
      block(resource)
    } finally {
      resource.close()
    }
  }

  def pollDirectory(d : File) {
    val matcher =  (f : File) => f.getName.endsWith(".in")
    val outMaker = (f : File) => new File(f.getParentFile, f.getName.replace(".in", ".out"))
    pollDirectory(d, matcher, outMaker)
  }

  def pollDirectory(dir : File, matcher : File => Boolean, outMaker : File => File) {
    val sleepForMillis = 1000
    if (!dir.exists) {
      log(s"Directory ${dir} does not exist")
      return
    }
    log(s"Polling directory ${dir.getAbsolutePath} every ${sleepForMillis} milliseconds")
    while (true) {
      Thread.sleep(sleepForMillis)
      dir.listFiles().filter(matcher).foreach(inputFile => {
        val outputFile = outMaker(inputFile)
        if (outputFile.exists && (inputFile.lastModified <= outputFile.lastModified)) {
          // skipping because we've already got a current solution to this
        } else {
          outputFile.delete()
          Source.fromFile(inputFile)
          val lines = Source.fromFile(inputFile).getLines
          using(new PrintWriter(new FileWriter(outputFile))) { writer =>
            log(s"Writing ${inputFile.getName} to ${outputFile.getName}")
            solveAll(lines, writer.println)
            log(s"Done writing ${outputFile.getName}")
          }
        }
      })
    }
  }
}