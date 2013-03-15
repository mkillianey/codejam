package codejam.y2011round1a

uses java.lang.Comparable
uses java.lang.Integer
uses java.lang.Math
uses java.util.Collections
uses java.util.HashMap
uses java.util.List

class Solver {

  static class Card implements Comparable<Card> {
    var _c : int as DrawCards
    var _s : int as IncreaseScore
    var _t : int as MoreTurns
    construct (s : String) {
      var items = s.split(" ").map(\ x -> x.toInt())
      _c = items[0]
      _s = items[1]
      _t = items[2]
    }
    override function equals(other : Object) : boolean {
      return other typeis Card
          && _c == other._c
          && _s == other._s
          && _t == other._t
    }
    override function hashCode() : int {
      return _c + _s + _t
    }
    override function compareTo(other : Card) : int {
      if (_t != other._t) { return other._t - _t } // more turns is earlier
      if (_c != other._c) { return other._c - _c } // more cards is earlier
      if (_s != other._s) { return other._s - _s } // higher score is earlier
      return 0
    }
  }

  static class GameState {
    var _score : int as Score
    var _turns : int as Turns
    var _hand : List<Card> as Hand
    var _deck : List<Card> as Deck
    construct(score : int, turns : int, hand : List<Card>, deck : List<Card>) {
      _score = score
      _turns = turns
      _hand = hand
      _deck = deck
      Collections.sort(_hand)
    }
    function play(card : Card) : GameState {
      var newHand = Hand.copy()
      newHand.remove(card)
      var newDeck = Deck
      if (card.DrawCards > 0 && !Deck.Empty) {
        var numCardsToDraw = Math.min(card.DrawCards, Deck.size())
        newHand.addAll(Deck.subList(0, numCardsToDraw))
        newDeck = Deck.subList(numCardsToDraw, Deck.size())
      }
      return new GameState(Score + card.IncreaseScore, Turns - 1 + card.MoreTurns, newHand, newDeck)
    }
    override function hashCode() : int {
      return _score + _turns + _hand.hashCode() + _deck.hashCode()
    }
    override function equals(other : Object) : boolean {
      if (other typeis GameState) {
        return _score == other._score
            && _turns == other._turns
            && _hand.equals(other._hand)
            && _deck.size() == other._deck.size()
      }
      return false
    }
  }

  var _cache = new HashMap<GameState, Integer>()

  function solve(state : GameState) : Integer {
    if (state.Turns == 0 || state.Hand.Empty) {
      return state.Score
    }
    var solution = _cache.get(state)
    if (solution != null) {
      return solution
    }
    for (card in state.Hand) {
      if (card.MoreTurns > 0) {
        return solve(state.play(card)) // can always play cards that give more turns
      }
    }
    var highScore = state.Score
    var exploredCards : List<Card> = {}
    for (card in state.Hand) {
      if (exploredCards.hasMatch( \ exploredCard : Card ->
          exploredCard.IncreaseScore >= card.IncreaseScore &&
          exploredCard.DrawCards >= card.DrawCards)) {
        continue
      }
      var attempt = solve(state.play(card))
      highScore = Math.max(highScore, attempt)
      exploredCards.add(card)
    }
    _cache.put(state, highScore)
    return highScore
  }
}

