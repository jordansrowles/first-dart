import 'dart:html';
import 'dart:async';
import 'package:azure_cosmosdb/azure_cosmosdb.dart' as cosmos;
import 'http_overrides.dart';
import 'package:test/test.dart';

// comment
/**
 * multiline comment
 */

const MY_VALUE = "Jordan";

final my_final = "Rowles";
var mutable = "Test";
var image = {
  'tags': ['tag1', 'tag2'],
  'url': "//path/to/file.png"
};

// inline, nested, anonymous functions
example_method() {
  nested_method_2() {
    nested_inline() => print("Hi!");
    nested_inline();
  };
  nested_method_2();
}

void main(List<String> args) {
  // program entry point
}

// this is their version of a class. Now look at this crazy fucking shit.
// c-sharp:
//    class Person : A, B, IDescribable

class Person extends BaseClass with MyMixin implements Describable {
  String name;
  DateTime? hired;

  Person(this.name, this.hired) : super(name) {
  }

  void Describe() {
    print("Person: $name");

    var hiredDate = this.hired;
    if (hiredDate != null) {
      int years = DateTime.now().difference(hiredDate).inDays ~/ 365;
      print("hired $years years ago");
    } else {
      print("not hired");
    }
  }
}

class BaseClass {
  String name;
  BaseClass(this.name) {}
}

mixin MyMixin {
  int calculated_pay = 0;
  int CalculatePay(int base, int addition) {
    calculated_pay = base + addition;
    return calculated_pay;
  }
}

abstract class Describable {
  void Describe();
}

// something.where((name) => name.contains('turn')).forEach(print);

/**
 * examaple of a DTO
 */
class QuestionDTO extends cosmos.BaseDocumentWithEtag {
  @override
  final String id;
  
  String? label;
  String? category;
  DateTime? added_date;

  QuestionDTO(this.id, this.label, this.category, this.added_date); // yoooo auto assignment

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'category': category,
    'added_date': added_date?.toUtc().toIso8601String()
  };

  static QuestionDTO build(Map json) {
    var added_date = json['added_date'];
    if (added_date != null) {
      added_date = DateTime.parse(added_date).toLocal();
    }
    final item = QuestionDTO(
      json['id'],
      json['label'],
      json['category'],
      added_date
    );
    item.setEtag(json);
    return item;
  }
}

// extensions methods: adding 'sum' to List<int>
extension on List<int> {
  int get sum => fold(0, (a,b) => a + b);
}
test_extensions() {
  print([1, 2, 3].sum);
}

// decently designed enums... (see full_emum_example.dart for full beastly shit)
enum PlainEnum { item1, item2, item3 }
enum EnumWithType<T> {
  numbers<int>([1, 2, 3]),
  strings<String>(['A', 'B', 'C']);

  final List<T> items;
  const EnumWithType(this.items);
}
test_enum_with_type() {
  expect(EnumWithType.numbers.items, [1,2,3]);
}

// async/await uses 'Future's
Future gatherNewsReports() async {
  final path = 'https://dart.dev/f/dailyNewsDigest.txt';
  return (await HttpRequest.getString(path));
}
printNewsTest() async {
  try {
    String news = await gatherNewsReports();
    print(news);
  } catch (e) {
    print('Error: $e');
  }
}
printNewsSyncTest() {
  final news = gatherNewsReports();
  news.then((content) => print(content));
}

//    waiting on futures
Future<String> futureWait1() => Future.value('futureWait1');
Future<String> futureWait2() => Future.value('futureWait2');
testWaitingOnFutures() {
  Future.wait([futureWait1(), futureWait2()])
    .then((var item) => print(item[1]))
    .catchError((e) => print('Error: $e'));
} // how javascript-esque is that slick shit?

// testing cosmos stuff
class DatabaseContext {

  Future<cosmos.Database> GetServer() async {
    final cosmosDB = cosmos.Server('https://localhost:8081/', masterKey: '/* your master key*/');
    final database = await cosmosDB.databases.openOrCreate('sample');
    return database;
  }

  Future<List<QuestionDTO>> GetQuestions() async {
    var questions;
    final server = await GetServer();
    final collection = server.collections.openOrCreate('questions', partitionKeys: ['/id']);
    
    final query = cosmos.Query('SELECT * FROM c WHERE c.label = @label',
      params: { '@label': 'example_label_1' });
    
    
    throw Exception();
    //return await collection.query<QuestionDTO>(cosmos.Query(''));
  }
}
