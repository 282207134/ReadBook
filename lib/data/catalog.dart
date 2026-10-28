class Book {
  const Book(
    this.id,
    this.title,
    this.author,
    this.price,
    this.cover,
    this.category,
    this.stars,
  );

  final int id;
  final String title, author, cover, category;
  final int price;
  final int stars;
  String get image => 'assets/images/$cover.png';
  String get priceLabel => money(price);
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';

const books = [
  Book(
    0,
    'The Mars Room',
    'Steven Curran',
    1055,
    'mars_room',
    'Art & Photography',
    3,
  ),
  Book(1, 'How to Stop Time', 'Matt Haig', 2012, 'stop_time', 'Fiction', 5),
  Book(
    2,
    'Blue Highways',
    'Steven Holzner',
    1899,
    'blue_highways',
    'Art & Photography',
    5,
  ),
  Book(
    3,
    'Hardwiring Happiness',
    'Rick Hanson',
    1725,
    'hardwiring',
    'Mind, Body & Spirit',
    4,
  ),
  Book(
    4,
    'The Benefits of Being an Octopus',
    'Ann Braden',
    1695,
    'octopus',
    'Children’s Books',
    4,
  ),
  Book(
    5,
    'A Teaspoon of Earth and Sea',
    'Dina Nayeri',
    2470,
    'teaspoon',
    'Fiction',
    3,
  ),
];

const categories = [
  'Art & Photography',
  'Biography',
  'Children’s Books',
  'Crafts & Hobbies',
  'Crime & Thriller',
  'Fiction',
  'Food & Drink',
  'Graphic Novels, Anime & Manga',
  'History & Archaeology',
  'Mind, Body & Spirit',
  'Social Sciences',
];

const authors = [
  'Aaron Stephen',
  'Abel Travis',
  'Abram Hunter',
  'Albert Smith',
  'Alexis Fredrick',
  'Anderson Lindsey',
  'Barney Harvey',
  'Bennie Freeman',
  'Bobby Murray',
  'Bradford Harris',
];

const shippingNames = [
  'Standard (5-9 Business Days)',
  'Expedited (2-6 Business Days)',
  '2-Day (3 Business Days)',
  '1-Day (2 Business Days)',
];
const shippingPrices = [0, 199, 399, 599];

const synopsis =
    'For an introductory-level course in natural hazards. '
    '“Natural Hazards” uses real-life examples of hazards and disasters to '
    'explore how and why they happen and what we can do to limit their effects. '
    'The text is up-to-date coverage of recent disasters brings a fresh '
    'perspective to the material.';
