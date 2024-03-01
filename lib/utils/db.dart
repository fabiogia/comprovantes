import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Construtor com acesso privado
  DB._();
  // Criar uma instancia de DB
  static final DB instance = DB._();
  //Instancia do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'comprovantes.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_createTableModelo);
    await _inserirDadosIniciais(db);
  }

  _inserirDadosIniciais(db) async {
    // await db.insert('modelo', {'titulo': 'Vale Alimentação (Valdinei Vizinho)', 'formato': 'Vale Alimentação - {hoje}'});
    await db.insert('modelo',
        {'titulo': 'Colegio filhos 1', 'formato': 'Colegio filhos - {hoje}-1'});
    await db.insert('modelo',
        {'titulo': 'Colegio filhos 2', 'formato': 'Colegio filhos - {hoje}-2'});
    await db.insert('modelo',
        {'titulo': 'Contador Nunes', 'formato': 'Contador Nunes - {hoje}'});
    await db
        .insert('modelo', {'titulo': 'Unimed', 'formato': 'Unimed - {hoje}'});
    await db.insert('modelo', {'titulo': 'ENEL', 'formato': 'ENEL - {hoje}'});
    await db
        .insert('modelo', {'titulo': 'Saneago', 'formato': 'Saneago - {hoje}'});
    // await db.insert('modelo', {'titulo': 'Onix Helen', 'formato': 'Onix Helen - {contadoronix}/36 - {hoje}'});
    await db.insert('modelo',
        {'titulo': 'Simples Nacional', 'formato': 'Simples Nacional - {hoje}'});
    await db.insert('modelo', {'titulo': 'Sogra', 'formato': 'Sogra - {hoje}'});
    await db.insert(
        'modelo', {'titulo': 'Tim Live', 'formato': 'Tim Live - {hoje}'});
    await db.insert('modelo',
        {'titulo': 'Seguro AGSMB', 'formato': 'Seguro AGSMB - {hoje}'});
    await db.insert(
        'modelo', {'titulo': 'Cartão Nubank', 'formato': 'Nubank - {hoje}'});
    await db.insert('modelo', {
      'titulo': 'Cartão Itaucard Visa',
      'formato': 'Itaucard Visa - {hoje}'
    });
    await db
        .insert('modelo', {'titulo': 'Cartão C6', 'formato': 'C6 - {hoje}'});
  }

  String get _createTableModelo => '''
    CREATE TABLE modelo (
      id INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
      titulo TEXT NOT NULL,
      formato TEXT NOT NULL
    );
  ''';
}
