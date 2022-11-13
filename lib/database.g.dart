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

  DraftMovieDao? _draftMovieDaoInstance;

  DraftMovieMediaDao? _draftMovieMediaDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `draft_movies` (`projectId` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, PRIMARY KEY (`projectId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `draft_movies_media` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `projectId` INTEGER NOT NULL, `path` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movies` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `thumb` TEXT NOT NULL, `video` TEXT NOT NULL, `duration` INTEGER NOT NULL, `createdAt` INTEGER NOT NULL, `isFavourite` INTEGER NOT NULL, `isDraft` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DraftMovieDao get draftMovieDao {
    return _draftMovieDaoInstance ??= _$DraftMovieDao(database, changeListener);
  }

  @override
  DraftMovieMediaDao get draftMovieMediaDao {
    return _draftMovieMediaDaoInstance ??=
        _$DraftMovieMediaDao(database, changeListener);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }
}

class _$DraftMovieDao extends DraftMovieDao {
  _$DraftMovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _draftMovieEntityInsertionAdapter = InsertionAdapter(
            database,
            'draft_movies',
            (DraftMovieEntity item) => <String, Object?>{
                  'projectId': item.projectId,
                  'createdAt': item.createdAt
                },
            changeListener),
        _draftMovieEntityDeletionAdapter = DeletionAdapter(
            database,
            'draft_movies',
            ['projectId'],
            (DraftMovieEntity item) => <String, Object?>{
                  'projectId': item.projectId,
                  'createdAt': item.createdAt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DraftMovieEntity> _draftMovieEntityInsertionAdapter;

  final DeletionAdapter<DraftMovieEntity> _draftMovieEntityDeletionAdapter;

  @override
  Stream<List<DraftMovieEntity>> getAll() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM draft_movies ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => DraftMovieEntity(
            projectId: row['projectId'] as int,
            createdAt: row['createdAt'] as int),
        queryableName: 'draft_movies',
        isView: false);
  }

  @override
  Future<DraftMovieEntity?> getById(int projectId) async {
    return _queryAdapter.query(
        'SELECT * FROM draft_movies WHERE projectId = ?1',
        mapper: (Map<String, Object?> row) => DraftMovieEntity(
            projectId: row['projectId'] as int,
            createdAt: row['createdAt'] as int),
        arguments: [projectId]);
  }

  @override
  Future<void> insert(DraftMovieEntity draft) async {
    await _draftMovieEntityInsertionAdapter.insert(
        draft, OnConflictStrategy.replace);
  }

  @override
  Future<void> delete(DraftMovieEntity draft) async {
    await _draftMovieEntityDeletionAdapter.delete(draft);
  }
}

class _$DraftMovieMediaDao extends DraftMovieMediaDao {
  _$DraftMovieMediaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _draftMovieMediaEntityInsertionAdapter = InsertionAdapter(
            database,
            'draft_movies_media',
            (DraftMovieMediaEntity item) => <String, Object?>{
                  'id': item.id,
                  'projectId': item.projectId,
                  'path': item.path
                },
            changeListener),
        _draftMovieMediaEntityDeletionAdapter = DeletionAdapter(
            database,
            'draft_movies_media',
            ['id'],
            (DraftMovieMediaEntity item) => <String, Object?>{
                  'id': item.id,
                  'projectId': item.projectId,
                  'path': item.path
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DraftMovieMediaEntity>
      _draftMovieMediaEntityInsertionAdapter;

  final DeletionAdapter<DraftMovieMediaEntity>
      _draftMovieMediaEntityDeletionAdapter;

  @override
  Stream<List<DraftMovieMediaEntity>> getAll() {
    return _queryAdapter.queryListStream('SELECT * FROM draft_movies_media',
        mapper: (Map<String, Object?> row) => DraftMovieMediaEntity(
            id: row['id'] as int?,
            projectId: row['projectId'] as int,
            path: row['path'] as String),
        queryableName: 'draft_movies_media',
        isView: false);
  }

  @override
  Stream<List<DraftMovieMediaEntity>> getAllByProject(int projectId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM draft_movies_media WHERE projectId = ?1',
        mapper: (Map<String, Object?> row) => DraftMovieMediaEntity(
            id: row['id'] as int?,
            projectId: row['projectId'] as int,
            path: row['path'] as String),
        arguments: [projectId],
        queryableName: 'draft_movies_media',
        isView: false);
  }

  @override
  Future<void> insertAll(List<DraftMovieMediaEntity> media) async {
    await _draftMovieMediaEntityInsertionAdapter.insertList(
        media, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteAll(List<DraftMovieMediaEntity> media) async {
    await _draftMovieMediaEntityDeletionAdapter.deleteList(media);
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
            id: row['id'] as int,
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
            id: row['id'] as int,
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
