import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_list_example/custom_object.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DataListScreen(),
    );
  }
}

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  List<CustomObject> _dataList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_dataList.isEmpty) {
      fetchData();
    }
  }

  fetchData() async {
    try {
      var response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _dataList =
              jsonResponse.map((data) => CustomObject.fromJson(data)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _dataList = [];
          _isLoading = false;
          _errorMessage = 'Data not received.';
        });
      }
    } catch (err) {
      setState(() {
        _dataList = [];
        _isLoading = false;
        _errorMessage = 'Data fetching failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : _errorMessage.isNotEmpty
              ? Text(_errorMessage)
              : _dataList.isEmpty
                  ? const Text('No data')
                  : ListView.builder(
                      itemCount: _dataList.length,
                      itemBuilder: (ctx, index) {
                        var listItem = _dataList[index];
                        return ListTile(
                          title: Text(
                            listItem.title ?? '',
                          ),
                          subtitle: Text(
                            listItem.body ?? '',
                          ),
                        );
                      },
                    ),
    );
  }
}
