import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/models/product.dart';
import 'package:flutter_store/models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tech_shop.db');
    return await openDatabase(
      path,
      version: 7, // Увеличиваем версию базы данных
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT, avatar TEXT)',
    );
    await db.execute(
      'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, price REAL, category TEXT, imageUrl TEXT)',
    );
    await db.execute(
      'CREATE TABLE orders(id INTEGER PRIMARY KEY, userId TEXT, products TEXT, totalAmount REAL, date TEXT)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE users ADD COLUMN avatar TEXT DEFAULT "assets/default_avatar.png"',
      );
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE products ADD COLUMN imageUrl TEXT DEFAULT "https://via.placeholder.com/150"',
      );
    }
    if (oldVersion < 5) {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS orders(id INTEGER PRIMARY KEY, userId TEXT, products TEXT, totalAmount REAL, date TEXT)',
      );
    }
    if (oldVersion < 7) {
      await db.execute(
        'DROP TABLE IF EXISTS orders',
      );
      await db.execute(
        'CREATE TABLE orders(id INTEGER PRIMARY KEY, userId TEXT, products TEXT, totalAmount REAL, date TEXT)',
      );
    }
  }

  Future<int> insertUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    Database db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<Product?> getProduct(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    Database db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Product>> getAllProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<List<User>> getUsers() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> insertOrder(Order order) async {
    Database db = await database;
    return await db.insert('orders', order.toMap());
  }

  Future<List<Order>> getOrdersByUserId(String userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  Future<void> insertSampleProducts() async {
    List<Product> sampleProducts = [
      Product(
        name: 'Беспроводные наушники Sony WH-1000XM5',
        description: 'Передовая система шумоподавления Наши беспроводные наушники WH-1000XM5 с функцией шумоподавления, которая использует несколько микрофонов, не пропускают большую часть высокочастотных и среднечастотных шумов и отлично подавляют звук как самолета, так и человеческого голоса.',
        price: 99.99,
        category: 'Headphones',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/5234126/img_id1272024432336578090.jpeg/optimize',
      ),
      Product(
        name: 'Смартфон Nothing Phone (1) 8/256 ГБ',
        description: 'Компания Nothing, которую некогда сооснователь OnePlus Карл Пей открыл в Лондоне, официально представила свой первый смартфон Nothing Phone (1) Главной фишкой Nothing Phone (1) является задняя полупрозрачная крышка с подсветкой под названием Glyph. Ее можно гибко настраивать в зависимости от ситуации — звонков, SMS, уведомлений и так далее.',
        price: 699.99,
        category: 'Smartphones',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/5243677/img_id8411841722787083443.jpeg/optimize',
      ),
      Product(
        name: 'Ноутбук Honor MagicBook X14 Pro, Intel Core i5-13500H (2.6 ГГц), RAM 16 ГБ, SSD 1000 ГБ, Intel Iris Xe Graphics',
        description: 'Ультрабук Honor MagicBook X14 Pro подойдет для выполнения повседневных задач дома и в офисе. Компактные размеры дают возможность без труда перемещать его и брать в поездки.',
        price: 1299.99,
        category: 'Laptops',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/12505310/2a0000018d0d86870b7ab81956e24ad083ce/optimize',
      ),
      Product(
        name: 'Чайник Kitfort КТ-6171',
        description: 'Стильный и вместительный чайник КТ-6171 предназначен для кипячения воды дома, в офисе, на даче. Отлично подойдёт для тёплых встреч с семьёй и друзьями. За один раз в чайнике можно вскипятить до 1,8 л воды.',
        price: 199.99,
        category: 'Home Appliances',
        imageUrl: 'https://avatars.mds.yandex.net/get-mpic/7519991/img_id4208299801477492209.jpeg/optimize',
      ),
    ];

    for (Product product in sampleProducts) {
      await insertProduct(product);
    }
  }
}
