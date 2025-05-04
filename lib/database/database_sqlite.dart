
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqLite {
  
  // Future<dynamic> openConnection() async {
  Future<void> openConnection() async {

    final databasePath = await getDatabasesPath();
    final databaseFinalPath = join(databasePath, 'SQLITE_EXAMPLE');
    // openDatabase(path)

    await openDatabase(
      databaseFinalPath,
      version: 2,
      onConfigure: (db) async {
        print('onConfigure sendo Chamado');
        await db.execute('PRAGMA foreing_keys = ON');
      },
      // Chamado somente no momento de criação do banco de dados.
      // Primeira vez que carrega o aplicativo
      onCreate: (Database db, int version) {
        print('onCreate Chamado');
        final batch = db.batch();
        batch.execute('''
        create table teste(
          id Integer primary key autoincrement,
          nome varchar(200)
        )
        ''');
        batch.execute('''
        create table produto(
          id Integer primary key autoincrement,
          nome varchar(200)
        )
        ''');
        // batch.execute('''
        // create table categoria(
        //   id Integer primary key autoincrement,
        //   nome varchar(200)
        // )
        // ''');
        batch.commit();
      },
      // Será chamado sempre que houver uma alteração no version incremental (1 -> 2)
      onUpgrade: (Database db, int oldVersion, int version) {
        print('onUpgrade Chamado');
        final batch = db.batch();

        if(oldVersion == 1) {
        batch.execute('''
        create table produto(
          id Integer primary key autoincrement,
          nome varchar(200)
        )
        ''');
        // batch.execute('''
        // create table categoria(
        //   id Integer primary key autoincrement,
        //   nome varchar(200)
        // )
        // ''');
        }
        // if(oldVersion == 2) {
        // batch.execute('''
        // create table categoria(
        //   id Integer primary key autoincrement,
        //   nome varchar(200)
        // )
        // ''');
        // }
        batch.commit();
      },
      // Será chamado sempre que houver uma alteração no version decremental (2 -> 1)
      onDowngrade: (Database db, int oldVersion, int version) {
        print('onDowngrade Chamado');
        final batch = db.batch();
        if(oldVersion == 3) {
          batch.execute('''
           drop table categoria;
          ''');
        }
        batch.commit();
      },
      );

  }

}