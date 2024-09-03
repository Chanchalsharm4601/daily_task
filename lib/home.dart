import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'list_item_actions.dart'; // Import your list item actions widget
import 'custom_search_delegate.dart'; // Import your custom search delegate widget
import 'speech_recognition_service.dart'; // Adjust the import path as per your project
import 'package:daily_task/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SpeechRecognitionService _speechService;
  TextEditingController _textController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _speechService = SpeechRecognitionService();
    _speechService.initialize();
  }

  void _listen() async {
    HomeProvider provider = Provider.of<HomeProvider>(context, listen: false);

    if (provider.isListening) {
      _speechService.stop(); // Stop listening
      provider.setListening(false);
    } else {
      bool available = await _speechService.startListening((text, confidence) {
        setState(() {
          _textController.text = text;
        });
      });

      if (available) {
        provider.setListening(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech recognition not available')),
        );
      }
    }
  }

  void _updateFilteredWords(HomeProvider provider) {
    setState(() {
      if (_searchQuery.isEmpty) {
        provider.filteredWords = List.from(provider.confirmedWords);
      } else {
        provider.filteredWords = provider.confirmedWords
            .where((word) => word.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSearchChanged(HomeProvider provider) {
    setState(() {
      _searchQuery = _searchController.text;
      _updateFilteredWords(provider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "All Lists",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.check_circle_sharp),
          onPressed: () {
            // Action for menu button
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show search field
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(Provider.of<HomeProvider>(context, listen: false).confirmedWords, _updateFilteredWords),
              );
            },
            icon: Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredWords.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Theme.of(context).primaryColor,
                            value: provider.isCheckedList[provider.confirmedWords.indexOf(provider.filteredWords[index])],
                            onChanged: (bool? value) {
                              provider.toggleCheck(provider.confirmedWords.indexOf(provider.filteredWords[index]), value!);
                            },
                          ),
                          Expanded(
                            child: Text(
                              provider.filteredWords[index],
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListItemActions(
                            index: provider.confirmedWords.indexOf(provider.filteredWords[index]),
                            text: provider.filteredWords[index],
                            onDelete: () => provider.deleteWord(provider.confirmedWords.indexOf(provider.filteredWords[index])),
                            onEdit: (newText) => provider.editWord(provider.confirmedWords.indexOf(provider.filteredWords[index]), newText),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Enter text',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: _listen,
                      tooltip: 'Listen',
                      child: Icon(
                        Provider.of<HomeProvider>(context).isListening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<HomeProvider>(context, listen: false).addWord(_textController.text.trim());
                        _textController.clear();
                      },
                      child: Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
