import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) {
  //Задание 1.
  print('Проект: BookShelf');
  print('Версия Dart: ${Platform.version}');
  print('Версия Операционной системы: ${Platform.operatingSystem}');
  print('');

  //Задание 2.
  stdout.write('Название: ');
  final String titleRaw = stdin.readLineSync() ?? '';
  final String title;
  if (titleRaw.trim().isEmpty) {
    print('Ошибка: название не может быть пустым. Подсатвлено "Без названия".');
    title = 'Без названия';
  } else {
    title = titleRaw.trim();
  }
  stdout.write('Автор: ');
  final String authorRaw = stdin.readLineSync() ?? 'неизвестен';
  final String author;
  if (authorRaw.trim().isEmpty) {
    print('Ошибка: автор не может быть пустым. Подставлено "неизвестен".');
    author = 'неизвестен';
  } else {
    author = authorRaw.trim();
  }

  stdout.write('Год издания: ');
  final String yearRaw = stdin.readLineSync() ?? '';
  final int year;
  if (int.tryParse(yearRaw) == null) {
    print('Ошибка: "$yearRaw" - не число. Год = 0');
    year = 0;
  } else {
    year = int.parse(yearRaw);
  }

  stdout.write('Количество страниц: ');
  final int pagesRaw = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  final int pages;
  if (pagesRaw <= 0) {
    print('Ошибка: страниц должно быть больше 0. Подставлено 1');
    pages = 1;
  } else {
    pages = pagesRaw;
  }
  stdout.write('Оценка(0-5): ');
  final double ratingRaw = double.tryParse(stdin.readLineSync() ?? '') ?? 0.0;
  final double rating;
  if (ratingRaw < 0 || ratingRaw > 5) {
    print('Ошибка: оценка должна быть от 0 до 5. Подставлено 0.');
    rating = 0.0;
  } else {
    rating = ratingRaw;
  }
  stdout.write('Прочитана? (да/нет или 1/0):');
  final String readR = (stdin.readLineSync(encoding: utf8) ?? '').trim().toLowerCase();
  final bool isRead = readR == 'да' || readR == '1';

  //Задание 3.
  final String category = pages < 150
      ? 'брошюра'
      : pages < 400
      ? 'книга'
      : 'том';
  final double hours = pages / 50.0;
  final int currentYear = DateTime.now().year;
  final int age = currentYear - year;

  final String initials = author
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => '${w[0].toUpperCase()}.')
      .join(' ');
  print('');
  print('=' * 44);
  print('«$title»');
  print('Автор: $author');
  print('Инициалы: $initials');
  print('Год: $year (возраст: $age лет)');
  print('Страниц: $pages ($category)');
  print('Время чтения: ~${hours.toStringAsFixed(1)} ч');
  print('Оценка: ${rating.toStringAsFixed(1)}/5');
  print('Прочитана: ${isRead ? "да" : "нет"}');
  print('=' * 44);

  //Задание 4.
  final List<String> shelf = <String>[
    'Норвежский лес',
    'Кафка на пляже',
    'Охота на овец',
    'Хроники Заводной Птицы',
    '1Q84',
  ];
  print('\nПолка Мураками: $shelf');
  print('Длина: ${shelf.length}');
  print('Первая: ${shelf.first}');
  print('Последняя: ${shelf.last}');

  shelf.insert(0, 'Слушай песню ветра'); // в начало
  shelf.add('Мужчины без женщин'); //в конец
  shelf.remove('Охота на овец'); // удаление по значению
  print('После изменений: $shelf');

  stdout.write('\nЖанры через запятую: ');
  final String genresRaw = stdin.readLineSync() ?? '';
  final Set<String> genres = genresRaw
      .split(',')
      .map((g) => g.trim())
      .where((g) => g.isNotEmpty)
      .toSet();
  genres.add('магический реализм');
  genres.add('магический реализм'); //дубликат не добавится
  print('Жанры: $genres (уникальных: ${genres.length})');

  final Map<String, int> pagesByBook = <String, int>{
    'Норвежский лес': 416,
    'Кафка на пляже': 656,
    'Охота на овец': 384,
    'Хроники Заводной Птицы': 832,
    '1Q84': 1152,
  };

  pagesByBook.forEach((book, p) => print('$book - $p стр.'));

  String maxBook = '';
  int maxPages = 0;
  int total = 0;
  pagesByBook.forEach((book, p) {
    total += p;
    if (p > maxPages) {
      maxPages = p;
      maxBook = book;
    }
  });
  print('Самая толстая: $maxBook ($maxPages стр.)');
  print(
    'Всего: $total, в среднем:'
    '${(total / pagesByBook.length).toStringAsFixed(1)}',
  );

  final bool includeExtra = true;
  final List<String> all = <String>[
    'стартовая полка',
    ...shelf,
    if (includeExtra) 'бонусная книга',
    for (final g in genres) 'жанр: $g',
  ];
  print('all: $all');

  //Задание 5.
  print('\n   Операторы   ');
  
  // "/" - вещественное деление: 7 / 2 = 3.5
  // "~/" - целочисленное деление: 7 ~/ 2 = 3
  // "%" - остаток от деления: 7 % 2 = 1
  print('7 / 2=${7 / 2}');
  print('7 ~/ 2=${7 ~/ 2}');
  print('7 % 2 = ${7 % 2}');

  bool sideEffect() {
    print(' sideEffect вызван ');
    return true;
  }

  //false && ... - правый операнд не вычисляется (ленивость &&)
  //ignore: dead_code
  print(false && sideEffect());

  //true || ... - правый операнд не вычисляется (ленивость ||)
  //ignore: dead_code
  print(true || sideEffect());

  // true && ... - правый операнд вычисляется 
  print(true && sideEffect());

  String? maybeNull;
  // ?. - безопасный доступ, ?? - значение по умолчанию, ??= - присвоить если null
  //ignore: dead_code
  print(maybeNull?.length);
  print(maybeNull ?? 'по умолчанию');
  maybeNull ??= 'заполнено';
  print(maybeNull);

  // ссылку менять нельзя, содержимое можно
  final List<int> finalList = [1, 2, 3];
  finalList.add(4);
  print('finalList: $finalList');

  // нельзя менять и ссылку, и содержимое
  const List<int> constList = [1, 2, 3];
  print('constList: $constList');
  try {
    constList.add(4);
  } catch (e) {
    print('Попытка изменить const-список: $e');
  }
  // каскад .. - цепочка вызовов на одном объекте без промежуточных переменных 
  final StringBuffer sb = StringBuffer()
    ..write('Book')
    ..write('Shelf')
    ..write('-')
    ..write('каталог книг');
  print(sb.toString());
}
