package codejam;

import java.io.BufferedReader;

/**
 * Solver of Google codejam problems.
 *
 * Note: This interface should contain only a single method so that
 * it can be invoked in Gosu by passing a block with a signature that
 * matches the {@link #solve} method.
 */
public interface Solver {

  /**
   * Reads exactly one Google codejam case from the given reader.
   *
   * @return the answer to the case (the part that appears after "Case #n: ")
   */
  String solve(BufferedReader reader);
}

