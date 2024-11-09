
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/AddressModel.dart';

class AddressDatabase {
  static final AddressDatabase instance = AddressDatabase._init();
  static Database? _database;

  AddressDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('address.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE addresses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        street TEXT,
        subLocality TEXT,
        locality TEXT,
        administrativeArea TEXT,
        country TEXT,
        subThoroughfare TEXT,
        lat REAL,
        lon REAL
      )
    ''');
  }

  // Veri ekleme
  Future<int> newAddress(AddressModel address) async {
    final db = await instance.database;
    return await db.insert('addresses', address.toMap());
  }

  // Tüm veriyi listeleme
  Future<List<AddressModel>> readAllAddresses() async {
    final db = await instance.database;
    final result = await db.query('addresses');
    return result.map((map) => AddressModel.fromMap(map)).toList();
  }

  // Tek veriyi id ile getirme
  Future<AddressModel?> readAddress(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return AddressModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // Veri güncelleme
  Future<int> updateAddress(AddressModel address) async {
    final db = await instance.database;
    return db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  // Veri silme
  Future<int> deleteAddress(int id) async {
    final db = await instance.database;
    return await db.delete(
      'addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteAllAddress() async {
    final db = await instance.database;
    return await db.delete(
      'addresses'
    );
  }

  // Veritabanını kapatma
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}