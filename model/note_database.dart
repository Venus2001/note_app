
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

class NoteDatabase extends ChangeNotifier {
  static const String _boxName = 'notesBox';
  static Box<Note>? _box;

  // Initialize Hive و ایجاد باکس
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(NoteAdapter());
    _box = await Hive.openBox<Note>(_boxName);
  }

  // لیست نکته‌ها (ریال تایم)
  List<Note> get currentNotes => _box?.values.toList() ?? [];

  // اضافه کردن نکته جدید
  Future<void> addNote(String text) async {
    final newNote = Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
    );

    await _box?.put(newNote.id, newNote);
    notifyListeners();
  }

  // آپدیت نکته موجود
  Future<void> updateNote(String id, String newText) async {
    final note = _box?.get(id);
    if (note != null) {
      note.text = newText; // متن جدید را تنظیم کنید
      await _box?.put(id, note); // تغییرات را ذخیره کنید
      notifyListeners(); // اطلاع‌رسانی برای آپدیت UI
    }
  }
  // حذف نکته
  Future<void> deleteNote(String id) async {
    await _box?.delete(id);
    notifyListeners();
  }

  // بستن باکس هنگام پایان کار (اختیاری)
  Future<void> close() async {
    await _box?.close();
  }
}