package codejam

uses java.io.BufferedReader
uses java.io.BufferedWriter
uses java.io.File
uses java.io.FileReader
uses java.io.FileWriter
uses java.io.IOException
uses java.io.Reader
uses java.io.StringReader
uses java.io.Writer
uses java.lang.Iterable
uses java.lang.RuntimeException
uses java.lang.System
uses java.lang.Thread
uses java.lang.Long
uses java.util.Map
uses java.util.concurrent.Future
uses java.lang.Void
uses java.util.concurrent.FutureTask

/**
 * Runner for reducing the boilerplate overhead of solving Google codejam problems.
 */
public class SolutionRunner {

  var _newLine : String
  var _solver : block(reader : BufferedReader) : String

  private construct(solver : block(reader : BufferedReader) : String) {
    this._newLine = System.getProperty("line.separator")
    this._solver = solver
  }

  /**
   * Creates a new SolutionRunner from the given solver.
   */
  static public function from(solver : block(reader : BufferedReader) : String) : SolutionRunner {
    return new SolutionRunner(solver)
  }
  
  /**
   * A helper method to make it easier to manually test/debug single cases.
  */
  public function solveOneCase(lines : Iterable<String>) {
    print("Trying this input:")
    for (line in lines) {
      print("    ${line}")
    }
    var startTime = System.currentTimeMillis()
    var solution = _solver(new BufferedReader(new StringReader(lines.join("\n"))))
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
    var totalElapsedTime = 0L
    while (i <= numCases) {
      var startTime = System.currentTimeMillis()
      var solution = _solver(bufferedReader)
      var endTime = System.currentTimeMillis()
      var elapsedTime = endTime - startTime
      print("Case #${i} (${elapsedTime} milliseconds): ${solution}")
      totalElapsedTime += elapsedTime
      if (writer != null) {
        writer.write("Case #${i}: ${solution}${_newLine}")
        writer.flush()
      }
      i++
    }
    print("${numCases} cases solved in ${totalElapsedTime} milliseconds")
  }

  private function calculateOutputFilename(inputFilename : String) : String {
    if (inputFilename.endsWith(".in")) {
      inputFilename = inputFilename.substring(0, inputFilename.length - 3)
    }
    return inputFilename + ".out"
  }

  /**
   * Solves the file with the given name, writing the output to a file with
   * the given name.  If no output filename is given, the name is chosen by
   * taking the input filename, stripping it of any ".in" file extension,
   * and adding the extension ".out".
   */
  public function solveFile(inputFilename : String, outputFilename : String = null) {
    if (outputFilename == null) {
      outputFilename = calculateOutputFilename(inputFilename)
    }
    var inputFile = new File(inputFilename)
    var outputFile = new File(outputFilename)
    if (outputFile.exists()) {
      print("Deleting previous output file ${outputFilename}")
      if (!outputFile.delete()) {
        throw new IOException("Can't delete file ${outputFilename}")
      }
    }
    print("Solving ${inputFilename} to file ${outputFilename}")
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
   * Files to be solved should end with the extension ".in" and their solutions will be
   * written to a file with the same basename and the extension ".out"
   */
  public function pollDirectory(directoryName : String = ".", prefix : String = "", seconds : int = 2) {
    var lastAttempt : Map<String, Long> = {}
    var canonicalPathToDirectory = new File(directoryName).CanonicalPath
    print("Polling directory ${canonicalPathToDirectory} for files to solve starting with \"${prefix}\"")
    while (true) {
      var directory = new File(canonicalPathToDirectory)
      for (child in directory.Children) {
        if (!child.Name.startsWith(prefix) || !child.Name.endsWith(".in")) {
          continue
        }
        if (lastAttempt.containsKey(child.Name)) {
          if (child.lastModified() <= lastAttempt.get(child.Name)) {
            continue
          }
          print("Re-attempting modified file ${child.Name}")
        } else {
          print("Attempting new file ${child.Name}")
        }
        var outputFilename = calculateOutputFilename(child.Name)
        var outputFile = new File(outputFilename)
        if (outputFile.exists()) {
          if (lastAttempt.containsKey(child.Name) and child.lastModified() < outputFile.lastModified()) {
            print("Skipping ${child.Name} because we've already solved it: existing output file ${outputFilename} is newer")
            continue
          }
        }
        lastAttempt.put(child.Name, child.lastModified())
        try {
          solveFile(child.Name, outputFilename)
          print("Done solving ${child.Name}")
        } catch (e : IOException) {
          print("Threw ${e.Class.Name} while solving ${child.Name}:  ${e.Message}")
        } catch (e : RuntimeException) {
          print("Threw ${e.Class.Name} while solving ${child.Name}:  ${e.Message}")
        }
      }
      Thread.sleep(seconds) // wait for a few seconds and try again
    }
  }
}
