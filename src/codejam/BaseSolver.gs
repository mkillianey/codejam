package codejam

uses java.io.*
uses java.lang.*
uses java.util.*

/**
 * Base class for reducing the boilerplate overhead of solving Google codejam problems.
 *
 * Extend this class and implement {@link #solveOneCase(java.io.BufferedReader}.
 */
abstract class BaseSolver {  
  
  construct( ) {
  }
  
  abstract function solveOneCase(reader : BufferedReader) : String

  /**
   * A helper method to make it easier to manually test/debug single cases.
   *
   * Do not implement this!
  */
  public final function tryOneCase(lines : Iterable<String>) {
    print("Trying this input:")
    for (line in lines) {
      print("    ${line}")
    }
    var startTime = System.currentTimeMillis()
    var solution = solveOneCase(new BufferedReader(new StringReader(lines.join("\n"))))
    var endTime = System.currentTimeMillis()
    print("Gives this output in ${endTime-startTime} milliseconds:")
    print("    ${solution}")
  }

  /**
   * Solves all of the cases in the given reader, writing the results to the
   * given writer.
   */
  public function solveAll(reader : Reader, writer : Writer = null) {
    var bufferedReader = new BufferedReader(reader)
    var numCases = bufferedReader.readLine().toInt()
    var i = 1
    while (i <= numCases) {
      var startTime = System.currentTimeMillis()
      var solution = solveOneCase(bufferedReader)
      var endTime = System.currentTimeMillis()
      print("Case #${i} (${endTime-startTime} milliseconds): ${solution}")
      if (writer != null) {
        writer.write("Case #${i}: ${solution}\n")
        writer.flush()
      }
      i++
    }
  }

  /**
   * Solves the file with the given name, writing the output to a file with
   * the given name.  If no output filename is given, the name is chosen by
   * taking the input filename, stripping it of any ".in" file extension,
   * and adding the extension ".out".
   */
  public function solveFile(inputFilename : String, outputFilename : String = null) {
    var inputFile = new File(inputFilename)
    if (outputFilename == null) {
      if (inputFilename.endsWith(".in")) {
        outputFilename = inputFilename.substring(0, inputFilename.length - 3) + ".out"
      } else {
        outputFilename = inputFilename + ".out"
      }
    }
    var outputFile = new File(outputFilename)
    if (outputFile.exists()) {
      if (inputFile.lastModified() < outputFile.lastModified()) {
        print("Skipping ${inputFilename} because existing output file ${outputFilename} is newer")
        return
      }
      if (outputFile.delete()) {
        print("Deleting output file ${outputFile} and regenerating solution")
      } else {
        throw new IOException("Can't delete file ${outputFile}")
      }
    }
    using (var reader = new BufferedReader(new FileReader(inputFile))) {
      using (var writer = new BufferedWriter(new FileWriter(outputFile))) {
        solveAll( reader, writer )
      }
    }
  }

  /**
   * Polls the given directory every few seconds for files to solve and, if it finds
   * them, invokes the solver on them.
   *
   * Files to be solved should end with the extension ".in"
   */
  public function pollDirectory(directoryName : String, prefix : String, seconds : int = 2) {
    var lastAttempt : Map<String, Long> = {}
    print("Polling directory ${directoryName} for files to solve")
    while (true) {
      var directory = new File(directoryName)
      for (child in directory.Children) {
        if (!child.Name.startsWith(prefix) || !child.Name.endsWith(".in")) {
          continue
        }
        var lastModified = child.lastModified()
        if (lastAttempt.containsKey(child.Name)) {
          if (lastModified <= lastAttempt.get(child.Name)) {
            continue
          }
          print("Re-attempting modified file ${child.Name}")
        } else {
          print("Attempting new file ${child.Name}")
        }
        lastAttempt.put(child.Name, lastModified)
        try {
          solveFile(child.Name)
          print("Done solving ${child.Name}")
        } catch (e : RuntimeException) {
          print("Threw exception while solving ${child.Name}")
        }
      }
      Thread.sleep(seconds) // wait for a few seconds and try again
    }
  }
}