import 'package:flutter/material.dart';

class ChatMessage {
  final String sender;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.content,
    required this.timestamp,
  });
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  List<ChatMessage> chatMessages = [
    ChatMessage(sender: 'Alice', content: 'Hello there!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Alice', content: 'I am doing well. How about you?', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'I am good too. Thanks!', timestamp: DateTime.now()),
    ChatMessage(sender: 'Bob', content: 'Hi, how are you?', timestamp: DateTime.now()),
  ];

  String searchQuery = '';
  int currentSearchIndex = 0;
  List<dynamic> filteredMessages = [];
  final ScrollController _scrollController = ScrollController();

  void filterMessages(String query) {
    List<dynamic> arr = [];
    for (var i = 0; i < chatMessages.length; i++) {
      if (chatMessages[i].content.toLowerCase().contains(query.toLowerCase())) {
        arr.add(i);
      }
    }

    setState(() {
      searchQuery = query;
      currentSearchIndex = 0;
      filteredMessages = arr;
    });
    scrollToMessage(filteredMessages[currentSearchIndex]);
  }

  void goToPreviousSearchResult() {
    if (currentSearchIndex > 0) {
      setState(() {
        currentSearchIndex--;
      });
    }
    scrollToMessage(filteredMessages[currentSearchIndex]);
  }

  void goToNextSearchResult() {
    if (currentSearchIndex < filteredMessages.length - 1) {
      setState(() {
        currentSearchIndex++;
      });
    }
    scrollToMessage(filteredMessages[currentSearchIndex]);
  }

  void scrollToMessage(int index) {
    const double itemExtent = 60.0;
    final double offset = index * itemExtent;
    _scrollController.animateTo(offset, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  List<TextSpan> buildMessageWithHighlight(String messageContent, String query) {
    final RegExp regex = RegExp('($query)', caseSensitive: false);
    final List<Match> matches = regex.allMatches(messageContent).toList();
    if (matches.isEmpty) {
      return [TextSpan(text: messageContent)];
    }

    final List<TextSpan> textSpans = [];
    int prevMatchEnd = 0;

    for (var match in matches) {
      if (match.start > prevMatchEnd) {
        textSpans.add(TextSpan(text: messageContent.substring(prevMatchEnd, match.start)));
      }
      textSpans.add(
        TextSpan(
          text: messageContent.substring(match.start, match.end),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      prevMatchEnd = match.end;
    }

    if (prevMatchEnd < messageContent.length) {
      textSpans.add(
        TextSpan(
          text: messageContent.substring(prevMatchEnd),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat App'),
        ),
        body: Column(
          children: [
            TextField(
              onChanged: (query) {
                filterMessages(query);
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
              ),
            ),
            Text('Result ${currentSearchIndex + 1} of ${filteredMessages.length}'),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  ChatMessage message = chatMessages[index];
                  return ListTile(
                    title: Text.rich(
                      TextSpan(children: buildMessageWithHighlight(message.content, searchQuery)),
                    ),
                    subtitle: Text(message.timestamp.toString()),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: goToPreviousSearchResult,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: goToNextSearchResult,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
