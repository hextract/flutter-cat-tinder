import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../../domain/entities/cat.dart';

part 'cat_database.g.dart';

class CatEntries extends Table {
  TextColumn get id => text()();
  TextColumn get url => text()();
  TextColumn get breedName => text()();
  TextColumn get breedDescription => text()();
  TextColumn get origin => text()();
  TextColumn get temperament => text()();
  TextColumn get lifeSpan => text()();
  TextColumn get weight => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CatEntries])
class CatDatabase extends _$CatDatabase {
  CatDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> saveCats(List<Cat> cats) async {
    await batch((batch) {
      batch.insertAll(
        catEntries,
        cats.map((cat) => CatEntriesCompanion(
              id: Value(cat.id),
              url: Value(cat.url),
              breedName: Value(cat.breedName),
              breedDescription: Value(cat.breedDescription),
              origin: Value(cat.origin),
              temperament: Value(cat.temperament),
              lifeSpan: Value(cat.lifeSpan),
              weight: Value(cat.weight),
            )),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<List<Cat>> getCats() async {
    final catRows = await select(catEntries).get();
    return catRows
        .map((row) => Cat(
              id: row.id,
              url: row.url,
              breedName: row.breedName,
              breedDescription: row.breedDescription,
              origin: row.origin,
              temperament: row.temperament,
              lifeSpan: row.lifeSpan,
              weight: row.weight,
            ))
        .toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cats.db'));
    return NativeDatabase(file);
  });
}
