import 'dart:io';
import 'dart:convert';
import 'package:bookshelf_console/catalog.dart';

void main() {
  final counter = makeCounter();
  var running = true;
  while (running) {
    printMenu();
    stdout.write('> ');
    final command = stdin.readLineSync()?.trim() ?? '';

    counter();

    switch (command) {
      case '1':
        printAll(library);
        break;
      case '2':
        stdout.write('Введите автора: ');
        printAll(
          searchByField(
            library,
            'author',
            stdin.readLineSync(encoding: utf8) ?? '',
          ),
        );
        break;
      case '3':
        stdout.write('Введите название: ');
        printAll(
          searchByField(
            library,
            'title',
            stdin.readLineSync(encoding: utf8) ?? '',
          ),
        );
        break;
      case '4':
        stdout.write('Введите жанр: ');
        final genre = stdin.readLineSync() ?? '';
        printAll(
          library
              .where(
                (b) =>
                    (b['genre'] as String).toLowerCase() == genre.toLowerCase(),
              )
              .toList(),
        );
        break;
      case '5':
        stdout.write('Прочитанные? (да/нет): ');
        final ans = (stdin.readLineSync() ?? '').toLowerCase();
        printAll(filterByRead(library, ans == 'да'));
        break;
      case '6':
        stdout.write('Сортировать по (title/author/year/pages): ');
        final field = stdin.readLineSync() ?? 'title';
        stdout.write('По убыванию? (да/нет): ');
        final desc = (stdin.readLineSync() ?? '') == 'да';
        printAll(sortBy(library, field, descending: desc));
        break;
      case '7':
        printStatistics(library);
        break;
      case '8':
        addBook(library);
        break;
      case '9':
        deleteBook(library);
        break;
      case '0':
        running = false;
        print('Работа завершена.');
        break;
      default:
        print('Неизвестная команда. Повторите ввод.');
    }
  }
}

void printMenu() {
  print('\n=== Меню BookShelf ===');
  print('1 - Показать весь каталог');
  print('2 - Поиск по автору');
  print('3 - Поиск по названию');
  print('4 - Фильтр по жанру');
  print('5 - Фильтр по прочитанным');
  print('6 - Сортировка');
  print('7 - Статистика');
  print('8 - Добавить книгу');
  print('9 - Удалить книгу');
  print('0 - Выход');
}
