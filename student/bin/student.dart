import 'dart:io';

class Student {
  String name;
  int age;

  Student(this.name, this.age);

  @override
  String toString() => 'Name: $name, Age: $age';
}

void main(List<String> arguments) {
  List<Student> students = [];

  while (true) {
    print("\n===== Student Menu =====");
    print("1. Add Student");
    print("2. Show Data");
    print("3. Exit");
    stdout.write("Choose an option: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write("Enter student name: ");
        String? name = stdin.readLineSync();

        int? age;
        while (age == null) {
          stdout.write("Enter student age: ");
          String? input = stdin.readLineSync();
          try {
            age = int.parse(input!);
          } catch (e) {
            print("❌ Invalid age! Please enter a valid number.");
          }
        }

        students.add(Student(name ?? "Unknown", age));
        print("✅ Student added successfully!");
        break;

      case '2':
        if (students.isEmpty) {
          print("⚠️ No student data available.");
        } else {
          print("\n--- Student Data ---");
          for (var s in students) {
            print(s);
          }
        }
        break;

      case '3':
        print("👋 Exiting program...");
        return;

      default:
        print("❌ Invalid choice! Please try again.");
    }
  }
}
