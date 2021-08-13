import 'package:sqflite/sqflite.dart';

final String tableFavorites = 'Favorites';
final String tableSeriesCheckPoints = 'SeriesCheckPoints';
final String columnId = '_id';
final String columnUrl = 'url';
final String columnEpisodeUrl = 'episodeURL';
final String columnCheckPoint = 'checkPoint';
final String columnLast = 'last';
final String columnPoster = 'poster';

class Favorite {
  late var id;
  late var url;
  late var poster;

  Favorite();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnUrl: url,
      columnPoster: poster,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Favorite.fromMap(Map<String, Object?> map) {
    id = map[columnId];
    url = map[columnUrl];
    poster = map[columnPoster];
  }
}

class FavoriteProvider {
  static Database? db;

  static Future<Database?> open(String path) async {
    if (db == null) {
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableFavorites ( 
  $columnId integer primary key autoincrement, 
  $columnUrl text not null,
  $columnPoster text not null)
''');
      });
      return db;
    } else {
      return db;
    }
  }

  Future<Favorite> insert(Favorite favorite) async {
    favorite.id = await db!.insert(tableFavorites, favorite.toMap());
    return favorite;
  }

  Future<Favorite> getFavorite(int id) async {
    List<Map<String, Object?>> maps = await db!.query(tableFavorites,
        columns: [columnId, columnUrl, columnPoster],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Favorite.fromMap(maps.first);
    }
    return Favorite.fromMap({});
  }

  Future<List<Favorite>> getAll() async {
    List<Favorite> favList = [];
    (await db!.rawQuery("Select * From Favorites")).forEach((fav) {
      favList.add(Favorite.fromMap(fav));
    });
    return favList;
  }

  Future<int> delete(int id) async {
    return await db!
        .delete(tableFavorites, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Favorite favorite) async {
    return await db!.update(tableFavorites, favorite.toMap(),
        where: '$columnId = ?', whereArgs: [favorite.id]);
  }

  Future close() async => db!.close();
}

class SeriesCheckPoint {
  late var id;
  late var url; //diziLink
  late var episodeUrl; //episodeUrl
  late var checkPoint; //checkPoint
  late var last; //checkPoint

  SeriesCheckPoint();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnUrl: url,
      columnEpisodeUrl: episodeUrl,
      columnCheckPoint: checkPoint,
      columnLast: last,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  SeriesCheckPoint.fromMap(Map<String, Object?> map) {
    id = map[columnId];
    url = map[columnUrl];
    episodeUrl = map[columnEpisodeUrl];
    checkPoint = map[columnCheckPoint];
    last = map[columnLast];
  }
}

class SeriesCheckPointProvider {
  static Database? db;

  static Future<Database?> open(String path) async {
    if (db == null) {
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableSeriesCheckPoints ( 
  $columnId integer primary key autoincrement, 
  $columnUrl text not null,
  $columnEpisodeUrl text not null,
  $columnCheckPoint text not null,
  $columnLast boolean not null)
''');
      });
      return db;
    } else {
      return db;
    }
  }

  Future<SeriesCheckPoint> insert(SeriesCheckPoint seriesCheckPoint) async {
    seriesCheckPoint.id =
        await db!.insert(tableSeriesCheckPoints, seriesCheckPoint.toMap());
    return seriesCheckPoint;
  }

  Future<SeriesCheckPoint> getSeriesCheckPoint(int id) async {
    List<Map<String, Object?>> maps = await db!.query(tableSeriesCheckPoints,
        columns: [columnId, columnUrl, columnPoster],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SeriesCheckPoint.fromMap(maps.first);
    }
    return SeriesCheckPoint.fromMap({});
  }

  Future<int> delete(int id) async {
    return await db!.delete(tableSeriesCheckPoints,
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(SeriesCheckPoint seriesCheckPoint) async {
    return await db!.update(tableSeriesCheckPoints, seriesCheckPoint.toMap(),
        where: '$columnId = ?', whereArgs: [seriesCheckPoint.id]);
  }

  Future close() async => db!.close();
}
