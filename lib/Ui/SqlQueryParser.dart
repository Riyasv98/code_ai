import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SqlQueryParser extends StatefulWidget {
  const SqlQueryParser({super.key});

  @override
  State<SqlQueryParser> createState() => _SqlQueryParserState();
}

class _SqlQueryParserState extends State<SqlQueryParser> {
  TextEditingController _descriptionController = TextEditingController();
  String sql = "";
  String result = "";

  void format(String description) {
    setState(() {
      sql = '"' + description.replaceAll("\n", '";\nquery +=" ') + '"';
      result =sql;
    });
    print("val" + sql);
  }

  void reformat(String description) {
    description = description.replaceAll("query +=", '');
    description = description.replaceAll(";", ' ');
    description = description.replaceAll('""', "\n");
    sql = description.replaceAll('"', "");
    result =sql;
    setState(() {});
    print("val" + sql);
  }

  void copyText(String text){
    Clipboard.setData(ClipboardData(text: text));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQL Query Parser"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
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
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text(" Query to String"),
                                onPressed: () {
                                  format(_descriptionController.text);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text("String to Query"),
                                onPressed: () {
                                  reformat(_descriptionController.text);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
}