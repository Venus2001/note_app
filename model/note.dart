import 'package:hive/hive.dart';


//flutter packages pub run build_runner build

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  Note({required this.id, required this.text});

  @HiveField(1)
  String id;

  @HiveField(2)
  String text;

}