import 'dart:io';

// Задание 1. Структура данных каталога
typedef Book = Map<String, Object?>;

final List<Book> library = [
  {'title': 'Норвежский лес', 'author': 'Х. Мураками', 'year': 1987, 'pages': 416, 'genre': 'роман', 'read': true},
  {'title': 'Кафка на пляже', 'author': 'Х. Мураками', 'year': 2002, 'pages': 656, 'genre': 'роман', 'read': true},
  {'title': 'Дюна', 'author': 'Ф. Герберт', 'year': 1965, 'pages': 688, 'genre': 'фантастика', 'read': true},
  {'title': '1984', 'author': 'Дж. Оруэлл', 'year': 1949, 'pages': 320, 'genre': 'антиутопия', 'read': false},
  {'title': '451 градус по Фаренгейту', 'author': 'Р. Брэдбери', 'year': 1953, 'pages': 256, 'genre': 'антиутопия', 'read': false},
  {'title': 'Мастер и Маргарита', 'author': 'М. Булгаков', 'year': 1967, 'pages': 480, 'genre': 'роман', 'read': true},
  {'title': 'Основы Dart', 'author': 'С. А. Чернышев', 'year': 2024, 'pages': 521, 'genre': 'учебник', 'read': true},
  {'title': 'Flutter на практике', 'author': 'Ф. Заметти', 'year': 2020, 'pages': 328, 'genre': 'учебник', 'read': false},
  {'title': 'Гарри Поттер и философский камень', 'author': 'Дж. Роулинг', 'year': 1997, 'pages': 332, 'genre': 'фэнтези', 'read': true},
];

// Задание 3. Вывод
void printAll(List<Book> books, {String emptyMessage = 'Ничего не найдено.'}) {
  if (books.isEmpty) {
    print(emptyMessage);
    return;
  }
  for (int i = 0; i < books.length; i++) {
    final b = books[i];
    final readMark = b['read'] == true ? '[V]' : '[ ]';
    print('${i + 1}. $readMark "${b['title']}" - ${b['author']} (${b['year']}, ${b['pages']} стр., ${b['genre']})');
  }
}

// Задание 3. Поиск по подстроке в указанном поле
List<Book> searchByField(List<Book> books, String field, String query) {
  final q = query.toLowerCase().trim();
  if (q.isEmpty) return [];

  return books.where((b) {
    final text = (b[field]?.toString() ?? '').toLowerCase();
    return text.contains(q);
  }).toList();
}

// Задание 3. Фильтрация по признаку прочтения
List<Book> filterByRead(List<Book> books, bool isRead) {
  return books.where((b) => b['read'] == isRead).toList();
}

// Задание 3. Сортировка; направление задаётся именованным параметром
List<Book> sortBy(List<Book> books, String field, {bool descending = false}) {
  final copy = [...books];
  copy.sort((a, b) {
    final valA = a[field];
    final valB = b[field];
    int cmp;
    if (valA is num && valB is num) {
      cmp = valA.compareTo(valB);
    } else {
      cmp = (valA?.toString() ?? '').compareTo(valB?.toString() ?? '');
    }
    return descending ? -cmp : cmp;
  });
  return copy;
}

// Задание 4. Статистика с методами Iterable
void printStatistics(List<Book> books) {
  if (books.isEmpty) {
    print('Каталог пуст.');
    return;
  }
  
  final total = books.length;
  final readCount = books.where((b) => b['read'] == true).length;
  
  final totalPages = books.fold<int>(0, (sum, b) => sum + (b['pages'] as int));
  final avgPages = (totalPages / total).toStringAsFixed(1);

  final oldest = books.reduce((a, b) => (a['year'] as int) < (b['year'] as int) ? a : b);
  final newest = books.reduce((a, b) => (a['year'] as int) > (b['year'] as int) ? a : b);
  final biggest = books.reduce((a, b) => (a['pages'] as int) > (b['pages'] as int) ? a : b);

  final genres = books.map((b) => b['genre']).toSet();
  
  final Map<String, int> genreCounts = {};
  for (var genre in genres) {
    genreCounts[genre as String] = books.where((b) => b['genre'] == genre).length;
  }

  final percentRead = (readCount / total * 100).toStringAsFixed(1);

  print('\n--- Статистика каталога ---');
  print('Всего книг: $total (прочитано: $readCount)');
  print('Суммарное число страниц: $totalPages, в среднем: $avgPages');
  print('Самая старая: "${oldest['title']}" (${oldest['year']})');
  print('Самая новая: "${newest['title']}" (${newest['year']})');
  print('Самая объёмная: "${biggest['title']}" (${biggest['pages']} стр.)');
  print('Уникальные жанры: ${genres.map((g) => g.toString()).join(', ')}');
  print('Книг по жанрам: $genreCounts');
  print('Прочитано: $percentRead%');
}
// Задание 5. Добавление
void addBook(List<Book> books) {
  stdout.write('Название: ');
  final title = stdin.readLineSync() ?? 'Без названия';
  
  stdout.write('Автор: ');
  final author = stdin.readLineSync() ?? 'Неизвестен';
  
  final year = askInt('Год издания', min: 0, max: 2026);
  final pages = askInt('Количество страниц', min: 1);
  
  stdout.write('Жанр: ');
  final genre = stdin.readLineSync() ?? 'неизвестно';
  
  stdout.write('Прочитана? (да/нет): ');
  final read = (stdin.readLineSync() ?? '').toLowerCase() == 'да';

  books.add({
    'title': title,
    'author': author,
    'year': year,
    'pages': pages,
    'genre': genre,
    'read': read,
  });
  print('Книга добавлена!');
}

// Задание 5. Удаление
void deleteBook(List<Book> books) {
  if (books.isEmpty) {
    print('Каталог пуст.');
    return;
  }
  printAll(books);
  final index = askInt('Введите номер книги для удаления', min: 1, max: books.length);
  
  stdout.write('Вы уверены? (да/нет): ');
  final confirm = (stdin.readLineSync() ?? '').toLowerCase();
  if (confirm == 'да') {
    final removed = books.removeAt(index - 1);
    print('Книга "${removed['title']}" удалена.');
  } else {
    print('Удаление отменено.');
  }
}

// Задание 6. Функции высшего порядка
typedef BookPredicate = bool Function(Book book);

List<Book> filter(List<Book> books, BookPredicate test) {
  return books.where(test).toList();
}

Function makeCounter() {
  int count = 0;
  return () {
    count++;
    return count;
  };
}

// Надёжный ввод числа из методички (Listing 2)
int askInt(String prompt, {int min = 0, int? max}) {
  int? value;
  do {
    stdout.write('$prompt: ');
    value = int.tryParse(stdin.readLineSync() ?? '');
    if (value == null || value < min || (max != null && value > max)) {
      print('Некорректное значение. Ожидается целое число'
          '${max == null ? ' не меньше $min' : ' от $min до $max'}.');
      value = null;
    }
  } while (value == null);
  return value;
}