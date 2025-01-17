/*
 * Copyright 2020. Huawei Technologies Co., Ltd. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:agconnect_remote_config/agconnect_remote_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  _buttonOneClicked() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PageModeOne(), fullscreenDialog: true));
  }

  _buttonTwoClicked() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const PageModeTwo(), fullscreenDialog: true));
  }

  _clearData() async {
    await AGCRemoteConfig.instance.clearAll();
  }

  _buttonCustomClicked() async {
    await AGCRemoteConfig.instance.setCustomAttributes(
        {'key1': 'value1', 'key2': true, 'key3': 3, 'key4': 3.14});
  }

  _getCustomAttributes() async {
    await AGCRemoteConfig.instance.getCustomAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                  onPressed: _buttonOneClicked,
                  color: Colors.blue,
                  child: const Text(
                    'Mode 1:Fetch And Activate Immediately',
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  onPressed: _buttonTwoClicked,
                  color: Colors.blue,
                  child: const Text(
                    'Mode 2:Fetch And Activate Next Time',
                    style: TextStyle(color: Colors.white),
                  )),
              const Text('Please clear data before switching modes'),
              MaterialButton(
                  onPressed: _clearData,
                  color: Colors.blue,
                  child: const Text(
                    'Clear Data',
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  onPressed: _buttonCustomClicked,
                  color: Colors.blue,
                  child: const Text(
                    'setCustomAttributes',
                    style: TextStyle(color: Colors.white),
                  )),
              MaterialButton(
                  onPressed: _getCustomAttributes,
                  color: Colors.blue,
                  child: const Text(
                    'getCustomAttributes',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class PageModeOne extends StatefulWidget {
  const PageModeOne({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageModeOneState();
  }
}

class _PageModeOneState extends State<PageModeOne> {
  Map? _allValue;

  @override
  void initState() {
    super.initState();
    _fetchAndActivateImmediately();
  }

  _fetchAndActivateImmediately() async {
    await AGCRemoteConfig.instance
        .fetch()
        .catchError((error) => log(error.toString()));
    await AGCRemoteConfig.instance.applyLastFetched();
    Map? value = await AGCRemoteConfig.instance.getMergedAll();
    setState(() {
      _allValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mode 1'),
        ),
        body: Center(
          child: Text('$_allValue'),
        ));
  }
}

class PageModeTwo extends StatefulWidget {
  const PageModeTwo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PageModeTwoState();
  }
}

class _PageModeTwoState extends State<PageModeTwo> {
  Map? _allValue;

  @override
  void initState() {
    super.initState();
    _fetchAndActivateNextTime();
  }

  _fetchAndActivateNextTime() async {
    await AGCRemoteConfig.instance.applyLastFetched();
    Map? value = await AGCRemoteConfig.instance.getMergedAll();
    setState(() {
      _allValue = value;
    });
    await AGCRemoteConfig.instance
        .fetch()
        .catchError((error) => log(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mode 2'),
        ),
        body: Center(
          child: Text('$_allValue'),
        ));
  }
}
