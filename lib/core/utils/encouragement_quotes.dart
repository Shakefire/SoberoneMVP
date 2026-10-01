class EncouragementQuote {
  final String text;
  final String author;

  const EncouragementQuote({required this.text, required this.author});
}

class QuotesRepository {
  static const List<EncouragementQuote> quotes = [
    EncouragementQuote(
      text: "It does not matter how slowly you go as long as you do not stop.",
      author: "Confucius",
    ),
    EncouragementQuote(
      text: "Rock bottom became the solid foundation on which I rebuilt my life.",
      author: "J.K. Rowling",
    ),
    EncouragementQuote(
      text: "You don't have to see the whole staircase, just take the first step.",
      author: "Martin Luther King Jr.",
    ),
    EncouragementQuote(
      text: "Recovery is not a race. You don't have to feel guilty if it takes you longer than you thought it would.",
      author: "Anonymous",
    ),
    EncouragementQuote(
      text: "Strength does not come from physical capacity. It comes from an indomitable will.",
      author: "Mahatma Gandhi",
    ),
    EncouragementQuote(
      text: "One day you will tell your story of how you overcame what you went through and it will be someone else's survival guide.",
      author: "Brené Brown",
    ),
    EncouragementQuote(
      text: "Every strike brings me closer to the next home run.",
      author: "Babe Ruth",
    ),
  ];

  static EncouragementQuote getQuoteForDay(DateTime date) {
    final index = (date.day + date.month * 31) % quotes.length;
    return quotes[index];
  }
}
