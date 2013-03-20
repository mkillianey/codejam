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
      writeln(s"Case #$i: $answer")
      log(s"Solved case #$i in $elapsedTime millisec")
      elapsedTime
    }).sum
    log(s"Finished $n cases in $total millisec")
  }

  def using[A <: { def close() }, B](resource: A) (block: A => B) : B = {
    try {
      block(resource)
    } finally {
      resource.close()
    }
  }

  def pollDirectory(path : String) {
    pollDirectory(new File(path),
      (f : File) => f.getName.endsWith(".in"),
      (f : File) => new File(f.getParentFile, f.getName.replace(".in", ".out")))
  }

  def pollDirectory(dir : File,
                    matcher : File => Boolean,
                    outMaker : File => File) {
    val sleepForMillis = 1000
    if (!dir.exists) {
      log(s"Directory $dir does not exist")
    } else {
      log(s"Polling directory ${dir.getAbsolutePath} every $sleepForMillis milliseconds")
      while (true) {
        Thread.sleep(sleepForMillis)
        dir.listFiles().filter(matcher).foreach(inputFile => {
          val outputFile = outMaker(inputFile)
          if (outputFile.exists && (inputFile.lastModified <= outputFile.lastModified)) {
            // skipping because we've already got a current solution to this
          } else {
            outputFile.delete()
            Source.fromFile(inputFile)
            val lines = Source.fromFile(inputFile).getLines()
            using(new PrintWriter(new FileWriter(outputFile))) { writer =>
              log(s"Writing ${inputFile.getName} to ${outputFile.getName}")
              solveAll(lines, writer.println(_))
              log(s"Done writing ${outputFile.getName}")
            }
          }
        })
      }
    }
  }

  def testSamples(input : Iterator[String], expectedLines : Iterator[String]) {
    val actualBuffer = new collection.mutable.ArrayBuffer[String]()
    solveAll(input, s => { actualBuffer.appendAll(s.lines) ; log(s) } )
    val actual = actualBuffer.toArray
    val expected = expectedLines.toArray
    val errors = expected.zip(actual).filter(p => (p._1 != p._2))
    log(s"${errors.length} errors in sample data")
    errors.foreach(e => {
        log(s"EXPECTED: ${e._1}")
        log(s"ACTUAL:   ${e._2}")
      })
  }
}