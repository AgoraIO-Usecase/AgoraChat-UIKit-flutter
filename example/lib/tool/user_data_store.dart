// 单例模式
import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit_example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

const String languageKey = 'languageKey';

class UserDataStore {
  static UserDataStore? _instance;
  String? dbName;
  factory UserDataStore() {
    _instance ??= UserDataStore._();
    return _instance!;
  }

  Database? _db;

  UserDataStore._();

  Future<void> init({VoidCallback? onOpened}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await openDemoDB();
    onOpened?.call();
  }

  Future<void> dispose() async {
    await _db?.close();
  }

  // 打开db
  Future<void> openDemoDB() async {
    String databasesPath = await getDatabasesPath();
    dbName =
        '${appKey.replaceAll('#', '_')}_${ChatUIKit.instance.currentUserId!}.db';
    String path = '$databasesPath/$dbName';
    debugPrint('path: $path');
    await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE "${ChatUIKit.instance.currentUserId!}" ("id" TEXT PRIMARY KEY, "nickname" TEXT, "avatar" TEXT, "remark" TEXT, "type" INTEGER)',
        );
      },
      onOpen: (db) {
        _db = db;
        debugPrint('db opened');
      },
    );
  }

  // 插入或更新数据
  Future<void> saveUserData(ChatUIKitProfile profile) async {
    await _db?.rawInsert(
      'INSERT OR REPLACE INTO "${ChatUIKit.instance.currentUserId!}" (id, nickname, avatar, remark, type) VALUES (?, ?, ?, ?, ?)',
      [
        profile.id,
        profile.showName,
        profile.avatarUrl,
        profile.remark,
        profile.type.index
      ],
    );
  }

  // 批量插入或更新数据
  Future<void> saveUserDatas(List<ChatUIKitProfile> profiles) async {
    Batch? batch = _db?.batch();
    for (var profile in profiles) {
      batch?.insert(
        ChatUIKit.instance.currentUserId!,
        {
          'id': profile.id,
          'nickname': profile.showName,
          'avatar': profile.avatarUrl,
          'remark': profile.remark,
          'type': profile.type.index,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch?.commit();
  }

  // 获取所有数据
  Future<ChatUIKitProfile?> loadProfile(String id) async {
    List<Map<String, dynamic>>? maps = await _db?.query(
      ChatUIKit.instance.currentUserId!,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps?.isNotEmpty == true) {
      return ChatUIKitProfile(
        id: maps?.first['id'] as String,
        showName: maps?.first['nickname'] as String,
        avatarUrl: maps?.first['avatar'] as String,
        remark: maps?.first['remark'] as String,
        type: ChatUIKitProfileType.values[maps?.first['type'] as int],
      );
    }
    return null;
  }

  Future<List<ChatUIKitProfile>> loadAllProfiles() async {
    debugPrint('${ChatUIKit.instance.currentUserId}');
    List<Map<String, dynamic>>? maps = await _db
        ?.rawQuery('SELECT * FROM "${ChatUIKit.instance.currentUserId}"');
    return List.generate(maps?.length ?? 0, (i) {
      final info = maps?[i];
      return ChatUIKitProfile(
        id: info?['id'] as String,
        showName: info?['nickname'] as String?,
        avatarUrl: info?['avatar'] as String?,
        remark: info?['remark'] as String?,
        type: ChatUIKitProfileType.values[info?['type'] as int],
      );
    });
  }
}
