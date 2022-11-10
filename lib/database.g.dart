// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CreationDao? _creationDaoInstance;

  MovieDao? _movieDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `creation` (`id` INTEGER PRIMARY KEY AUTOINCREMENT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movies` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `thumb` TEXT NOT NULL, `video` TEXT NOT NULL, `duration` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `isFavourite` INTEGER NOT NULL, `isDraft` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CreationDao get creationDao {
    return _creationDaoInstance ??= _$CreationDao(database, changeListener);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }
}

class _$CreationDao extends CreationDao {
  _$CreationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _creationEntityInsertionAdapter = InsertionAdapter(database, 'creation',
            (CreationEntity item) => <String, Object?>{'id': item.id});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CreationEntity> _creationEntityInsertionAdapter;

  @override
  Future<List<CreationEntity>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM creation',
        mapper: (Map<String, Object?> row) =>
            CreationEntity(id: row['id'] as int?));
  }

  @override
  Future<void> insert(CreationEntity entity) async {
    await _creationEntityInsertionAdapter.insert(
        entity, OnConflictStrategy.replace);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _movieEntityInsertionAdapter = InsertionAdapter(
            database,
            'movies',
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'thumb': item.thumb,
                  'video': item.video,
                  'duration': item.duration,
                  'createdAt': item.createdAt,
                  'isFavourite': item.isFavourite ? 1 : 0,
                  'isDraft': item.isDraft ? 1 : 0
                },
            changeListener),
        _movieEntityUpdateAdapter = UpdateAdapter(
            database,
            'movies',
            ['id'],
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'thumb': item.thumb,
                  'video': item.video,
                  'duration': item.duration,
                  'createdAt': item.createdAt,
                  'isFavourite': item.isFavourite ? 1 : 0,
                  'isDraft': item.isDraft ? 1 : 0
                },
            changeListener),
        _movieEntityDeletionAdapter = DeletionAdapter(
            database,
            'movies',
            ['id'],
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'thumb': item.thumb,
                  'video': item.video,
                  'duration': item.duration,
                  'createdAt': item.createdAt,
                  'isFavourite': item.isFavourite ? 1 : 0,
                  'isDraft': item.isDraft ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieEntity> _movieEntityInsertionAdapter;

  final UpdateAdapter<MovieEntity> _movieEntityUpdateAdapter;

  final DeletionAdapter<MovieEntity> _movieEntityDeletionAdapter;

  @override
  Stream<List<MovieEntity>> getAll() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM movies ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => MovieEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            thumb: row['thumb'] as String,
            video: row['video'] as String,
            duration: row['duration'] as int,
            createdAt: row['createdAt'] as int,
            isFavourite: (row['isFavourite'] as int) != 0,
            isDraft: (row['isDraft'] as int) != 0),
        queryableName: 'movies',
        isView: false);
  }

  @override
  Future<MovieEntity?> getById(int id) async {
    return _queryAdapter.query('SELECT * FROM movies WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MovieEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            thumb: row['thumb'] as String,
            video: row['video'] as String,
            duration: row['duration'] as int,
            createdAt: row['createdAt'] as int,
            isFavourite: (row['isFavourite'] as int) != 0,
            isDraft: (row['isDraft'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<int> insert(MovieEntity movie) {
    return _movieEntityInsertionAdapter.insertAndReturnId(
        movie, OnConflictStrategy.replace);
  }

  @override
  Future<void> update(MovieEntity movie) async {
    await _movieEntityUpdateAdapter.update(movie, OnConflictStrategy.replace);
  }

  @override
  Future<void> delete(MovieEntity movie) async {
    await _movieEntityDeletionAdapter.delete(movie);
  }
}
