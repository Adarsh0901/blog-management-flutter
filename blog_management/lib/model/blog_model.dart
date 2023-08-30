class Blog {
  const Blog(
      {required this.id,
      required this.title,
      required this.description,
        required this.author,
      required this.imageUrl,
      required this.timeStamp,
      this.rate = 0.0,
      this.reviews});
  final String id;
  final String title;
  final String description;
  final String author;
  final String imageUrl;
  final double rate;
  final DateTime timeStamp;
  final List? reviews;
}

class Review {
  const Review(
      {required this.rTitle,
      required this.rDescription,
      required this.rTimeStamp,
      this.rating = 0.0});
  final String rTitle;
  final String rDescription;
  final DateTime rTimeStamp;
  final double rating;
}
