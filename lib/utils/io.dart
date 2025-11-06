import 'dart:io';

void clearScreen() {
    stdout.write(Process.runSync("cls", [], runInShell: true).stdout);
  }

  void pause() {
    stdout.write('\nPress Enter to continue...');
    stdin.readLineSync();
  }