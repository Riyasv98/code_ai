import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModelCreator extends StatefulWidget {
  const ModelCreator({super.key});

  @override
  State<ModelCreator> createState() => _ModelCreatorState();
}

class _ModelCreatorState extends State<ModelCreator> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController modelNameController = TextEditingController();
  String result = "";
  String className = "";
  List<String> columnNames = [];
  List<String> columnNameValues = [];

  void copyText(String text){
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Model Creator"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Class Name : ",
                              style:TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.deepPurple)),
                          Container(
                            height: 20,
                            width:200,
                            child: TextField(
                              controller: modelNameController,
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 8, bottom: 10.0),
                        child: TextFormField(
                          controller: _descriptionController,
                          maxLines: 12,
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            _descriptionController.clear();
                            setState(() {});
                          },
                          child: Text("Clear")),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("Parser"),
                    onPressed: () {
                      generateModel(_descriptionController.text);
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        // Add copy functionality here
                        copyText(result);
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      width: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SelectableText(
                          result,
                          maxLines: 10,
                          style: TextStyle(
                            fontSize: 18.0, // Set the font size as needed
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        result = "";
                        setState(() {});
                      },
                      child: Text("Clear")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getNameAndType(String name) {
    String result = name;
    String input = name;

    // Define a regular expression to match the field name and type
    RegExp regex = RegExp(r'\[([^\]]+)\]\s+\[([^\]]+)\]');

    // Use the firstMatch method to find the first match in the input string
    Match? match = regex.firstMatch(input);

    // Check if a match was found
    if (match != null) {
      // Extract the matched groups (field name and type)
      String fieldName = match.group(1)!;
      String fieldType = match.group(2)!;
      columnNameValues.add(fieldName);

      result = "[" +
          (fieldName.contains("_")
              ? convertToCamelCaseWithUnderScore(fieldName.toLowerCase())
              : isCamelCase(fieldName)?fieldName:convertToCamelCase(fieldName)) +
          "] [" +
          fieldType +
          "]";
    } else {
      print('No match found');
    }
    return result;
  }
  bool isCamelCase(String inputString) {
    RegExp regExp = RegExp(r'^[a-z]+(?:[A-Z][a-z])$');
    return regExp.hasMatch(inputString);
  }
  String convertToCamelCaseWithUnderScore(String inputString) {
    List<String> words = inputString.split('_');

    for (int i = 1; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }

    return words.join('');
  }

  String convertToCamelCase(String inputString) {
    // String firstChar = inputString.substring(0, 1).toLowerCase();
    // String remainingChars = inputString.substring(1);
    //
    // return '$firstChar$remainingChars';
    // String capitalLetters = '';
    //
    // for (int i = 0; i < inputString.length; i++) {
    //   if (inputString[i].toUpperCase() == inputString[i] && inputString[i] != inputString[i].toLowerCase()) {
    //     capitalLetters += inputString[i];
    //   }
    // }
    return inputString.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return match.group(0)!.toLowerCase();
    });
  }

  void generateModel(String text) {
    columnNames = [];
    columnNameValues = [];
    String sql = '''
      '$text'
    ''';

    List<String> lines = sql.split('\n');
    List<String> quotedLines = lines.map((line) {
      String ss = getNameAndType(line.trim());

      return ss.isNotEmpty ? ss : '';
    }).toList();


    quotedLines.removeWhere((element) => element.isEmpty);
    // String result = quotedLines.join('\n');

    classify(quotedLines);
    // print(result);
  }

  String dartify(String columnType) {
    // Implement your logic to map SQL column types to Dart types
    // You can customize this function based on your specific needs
    // For simplicity, let's assume a direct mapping for demonstration purposes
    return columnType;
  }

  // String convertFirstLetterToLowerCase(String inputString) {
  //   if (inputString.isEmpty) {
  //     return inputString; // Return the empty string if input is empty
  //   }
  //
  //   String firstLetter = inputString[0].toLowerCase();
  //   String remainingLetters = inputString.substring(1);
  //
  //   return '$firstLetter$remainingLetters';
  // }

  void classify(List<String> sqlColumns) {
    className = modelNameController.text;

    String dartClass = "";
    String modelFromJson;
    String modelToJson;
    String columnTypeWithName = "";

    modelFromJson = "import 'dart:convert';\n\n\n" +
        className +
        " " +
        className[0].toLowerCase() +
        className.substring(1) +
        "FromJson(String str) => " +
        className +
        ".fromJson(json.decode(str));\n\n";
    modelToJson = "String " +
        className[0].toLowerCase() +
        className.substring(1) +
        "ToJson(" +
        className +
        " data) => json.encode(data.toJson());\n\n";

    for (String column in sqlColumns) {
      List<String> matches = RegExp(r'\[(.*?)\]')
          .allMatches(column)
          .map((match) => match.group(1)!)
          .toList();
      String columnName = matches[0];
      columnNames.add(columnName);
      String columnType = getDartType(matches[1]);

      dartClass += " " + dartify(columnType) + "? " + columnName + ";\n";
      columnTypeWithName = dartClass;
    }

    dartClass = "class " + className + " {\n" + dartClass + "\n";
    dartClass += className + " ({\n this." + columnNames.join(",\n this.");
    dartClass += "\n});\n\n";

    String copyWith= "";
    copyWith =className+" copyWith({\n"+(columnTypeWithName.replaceAll(";", ","))+"}) => \n";
    List<String> toCopyWithList = columnNames.map((e) {
      String ss =
          e + ': ' + e+"?? "+"this."+e;
      return ss;
    }).toList();
    copyWith += className+"(\n"+toCopyWithList.join(",\n");
    copyWith +="\n);\n\n";
    dartClass += copyWith;
    //copyWith

    String fromJson = "";
    fromJson +=
        "\n factory " + className + ".fromJson(Map<String, dynamic> json) { \n";
    fromJson += " return " + className + " (\n";

    List<String> fromJsonList = columnNames.map((e) {
      String ss =
          e + ": json['" + (columnNameValues[columnNames.indexOf(e)]) + "']";
      return ss;
    }).toList();
    fromJson += fromJsonList.join(",\n");
    fromJson += "\n); \n}\n\n";
    dartClass += fromJson;
    //fromjson

    String toJson = "";
    toJson += "Map<String, dynamic> toJson() => {\n";
    List<String> toJsonList = columnNames.map((e) {
      String ss =
          "'" + (columnNameValues[columnNames.indexOf(e)]) + "'" + ':' + e;
      return ss;
    }).toList();
    toJson += toJsonList.join(",\n");
    toJson += "};";
    dartClass += toJson;
    //toJson
    dartClass += "\n}";

    result = modelFromJson + modelToJson + dartClass;
    setState(() {});
    print(dartClass);
  }

  String getDartType(String databaseType) {
    Map<String, String> dartTypes = {
      "int": "int",
      "varchar": "String",
      "nvarchar": "String",
      "float": "double",
      "decimal": "double",
      "tinyint": "int",
      "smallint": "int",
      "image":"String",
      "bit": "bool",
      "datetime":
      "String", // You might want to use a proper date-time library in Dart
    };

    // Use the provided databaseType to look up the Dart type
    String dartType = dartTypes[databaseType.toLowerCase()] ?? "dynamic";

    return dartType;
  }
}