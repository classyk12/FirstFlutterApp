// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//use this import all of your packages when you need to use them
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp()); //starts the app

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //MOTHER WIDGET: holds all other widgets
    //----> is the constructor of the application
    //and anything in this build method is rendered everytime the application is loaded
    //all of your fields should be decleared and initialized here

    return MaterialApp(
      //defines that it uses google material design
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        body: Center(
          child: RandomWords(),
        ),
      ),
    );
  }
}

//use this to create a minimal state class
//RandomWordsState ---> state
//RandomWords ----> widget to be maintained by the state
//it is dependent on the RandomWords class
class RandomWordsState extends State<RandomWords> {
  //create a list of WordPair to be displayed in a listview
//create a bigger font property
  final _suggestions = <WordPair>[];
  //this will hold saved workds by the user --> a set is used stead of a list because set does not usually allow duplicate entries
  final _savedSuggestions = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.black);
  //all app logic and state resides here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        //use this to add appbar toolbar such as in xf
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
            color: (Colors.black),
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  //use this method to build the rows of a listview and define its elements
  Widget _buildRow(WordPair pair) {
    //use this flag to check if the word havent been already added to the SET
    final bool alreadySaved = _savedSuggestions.contains(pair);
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      //use this to add icons to the listview elements
      trailing: Icon(
        //if alreadySaved = true, use Icons.Favourite, else Icons.favourite_border
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.black,
      ),
      //tap event for listview row
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedSuggestions.remove(pair);
          } else {
            _savedSuggestions.add(pair);
          }
        });
      },
    );
  }

  //use this method to build our listview widget
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0), //this defines the padding
        itemBuilder: (context, i) {
          //this builds the items in the listview
          if (i.isOdd) {
            return Divider(); //returns a divider after each row in the listview
          }
          final index = i ~/
              2; //this one truncates all other numbers after the decimal points and return a whole number
          if (index >= _suggestions.length) {
            //if the index is more/equal to lenght of the array
            _suggestions.addAll(generateWordPairs()
                .take(10)); // display 10 words at a time in a list
          }
          return _buildRow(_suggestions[index]);
        });
  }

  void _pushSaved() {
    //get the count of favourited words
    var count = _savedSuggestions.length;
    String message;
    count > 0 ? message = count.toString() : message = '0';
    Navigator.of(context).push(
        //create a new route
        MaterialPageRoute<void>(builder: (BuildContext context) {
      //build the listview with an iterable using the elements in the set
      final Iterable<ListTile> tiles = _savedSuggestions.map((WordPair pair) {
        return ListTile(
          title: Text(pair.asPascalCase, style: _biggerFont),
        );
      });

      //use this to create horizontal spacing between cells of the listview
      final List<Widget> divider = ListTile.divideTiles(
              context: context, tiles: tiles, color: Colors.grey)
          .toList();

      //a build method returns a scaffold
      return Scaffold(
        appBar: AppBar(title: Text("saved suggestions (${message})")),
        //define the body here
        body: ListView(children: divider),
      );
    }));
  }
}

//use this to create the stateful widget RANDOMWORDS
//all stateful widgets must have a state attached to them, HENCE: RANDOMWORDSSTATE
class RandomWords extends StatefulWidget {
  @override
  //define name of the state and call the CreateState Method
  RandomWordsState createState() => RandomWordsState();
}
