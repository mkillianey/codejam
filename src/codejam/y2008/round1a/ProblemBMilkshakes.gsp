uses java.lang.AssertionError

// Solution for Google code jam 2008 Round 1A Problem B: Milkshakes
// http://code.google.com/codejam/contest/32016/dashboard#s=p1

uses codejam.SolutionRunner
uses java.io.BufferedReader
uses java.io.StringReader
uses java.lang.Integer
uses java.util.ArrayList
uses java.util.List

var sampleInput = new StringReader({
    "2",
    "5",
    "3",
    "1 1 1",
    "2 1 0 2 0",
    "1 5 0",
    "1",
    "2",
    "1 1 0",
    "1 1 1",
    ""}.join("\n"))

class Customer {
  var _malted : Integer as MaltedFavorite
  var _unmalted : List<Integer> as UnmaltedFavorites
  function hasMaltedFavorite() : boolean { return _malted != null }
  override function toString() : String { return "${MaltedFavorite}: ${UnmaltedFavorites}" }
}

function solve(totalFlavors : int, customers : ArrayList<Customer>) : String {
  //print("${totalFlavors} flavors, ${customers.size()} customers:")
  //for (customer in customers) {
  //  print("    ${customer}")
  //}
  var isMalted = (0..|totalFlavors).map(\ _ -> false)
  while (true) {
    var allCustomersSatisfied = true
    for (customer in customers index i) {
      if (customer.hasMaltedFavorite() and isMalted[customer.MaltedFavorite - 1]) {
        //print("Customer ${i}: ${customer} likes ${customer.MaltedFavorite}")
        continue
      }
      var unmaltedFavorite = customer.UnmaltedFavorites.firstWhere( \ flavor -> !isMalted[flavor - 1])
      if (unmaltedFavorite != null) {
        //print("Customer ${i}: ${customer} likes ${unmaltedFavorite}")
        continue
      }
      if (customer.hasMaltedFavorite()) {
        print("Try making ${customer.MaltedFavorite} malted for customer ${customer}")
        isMalted[customer.MaltedFavorite - 1] = true
        allCustomersSatisfied = false
        continue
      }
      print("Customer ${i}: ${customer} is unsatisfiable")
      return "IMPOSSIBLE"
    }
    if (allCustomersSatisfied) {
      return isMalted.map( \ elt -> elt ? "1" : "0").join(" ")
    }
  }
  throw new AssertionError("Should not reach this line")
}

var runner = SolutionRunner.from(\ reader -> {
  var totalFlavors = reader.readLine().toInt()
  var numCustomers = reader.readLine().toInt()
  var customers : ArrayList<Customer> = new ArrayList<Customer>(numCustomers)
  for (_ in 0..|numCustomers) {
    var line : Integer[] = reader.readLine().split(" ").map(\ elt -> elt.toInt())
    var flavorsLiked = line[0]
    var malted : Integer = null
    var unmalted : List<Integer> = {}
    for (i in 0..|flavorsLiked) {
      var flavor = line[2*i + 1]
      if (line[2*i + 2] == 0) {
        unmalted.add(flavor)
      } else {
        malted = flavor
      }
    }
    var customer = new Customer() { :MaltedFavorite = malted, :UnmaltedFavorites = unmalted }
    customers.add(customer)
  }
  return solve(totalFlavors, customers)
})

runner.solveAll(sampleInput)
runner.pollDirectory(:prefix = "B")
