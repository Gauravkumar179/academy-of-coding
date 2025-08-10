import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'dart:ui'; // For ImageFilter.blur

class GeminiTextScreen extends StatefulWidget {
  const GeminiTextScreen({super.key});

  @override
  State<GeminiTextScreen> createState() => _GeminiTextScreenState();
}

class _GeminiTextScreenState extends State<GeminiTextScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<_Message> messages = [];
  String? lastPrompt;
  bool loading = false;

  bool _isEducationRelated(String prompt) {
    // Simple keyword-based check (customize as needed)
    final keywords = [
      "learn",
      "study",
      "education",
      "teach",
      "school",
      "college",
      "university",
      "course",
      "class",
      "homework",
      "assignment",
      "exam",
      "test",
      "coding",
      "programming",
      "math",
      "science",
      "history",
      "language",
      "subject",
      "tell",
    ];
    final lowerPrompt = prompt.toLowerCase();
    return keywords.any((kw) => lowerPrompt.contains(kw));
  }

  late GenerativeModel model;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  void _initModel() {
    final ai = FirebaseAI.googleAI(auth: FirebaseAuth.instance);
    model = ai.generativeModel(model: 'gemini-1.5-flash');
  }

  Future<void> generateText({String? forcedPrompt}) async {
    final prompt = forcedPrompt ?? _controller.text.trim();
    if (prompt.isEmpty) return;

    // Check if current or any previous user message is education-related
    bool hasEducationContext = _isEducationRelated(prompt);
    if (!hasEducationContext) {
      for (var msg in messages) {
        if (msg.isUser && _isEducationRelated(msg.text)) {
          hasEducationContext = true;
          break;
        }
      }
    }

    if (!hasEducationContext) {
      setState(() {
        messages.add(
          _Message(
            "Sorry, I can only assist with education-related questions.",
            isUser: false,
          ),
        );
      });
      return;
    }

    setState(() {
      loading = true;
      if (forcedPrompt == null) {
        messages.add(_Message(prompt, isUser: true));
        _controller.clear();
      }
      lastPrompt = prompt;
    });

    await Future.delayed(const Duration(milliseconds: 100));
    _scrollToBottom();

    try {
      final List<Content> history = [];

      for (var msg in messages) {
        history.add(
          msg.isUser ? Content.text(msg.text) : Content.text(msg.text),
        );
      }

      history.add(Content.text(prompt));

      final result = await model.generateContent(history);

      setState(() {
        messages.add(
          _Message(
            result.text != null && result.text!.isNotEmpty
                ? result.text!
                : "No response received.",
            isUser: false,
          ),
        );
      });
    } catch (e) {
      setState(() {
        messages.add(_Message('Error: ${e.toString()}', isUser: false));
      });
    } finally {
      setState(() => loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearAllMessages() {
    setState(() {
      messages.clear();
      lastPrompt = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[700],
        title: const Text('AI Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Retry last message',
            onPressed: loading ? null : _clearAllMessages,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background4.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  controller: _scrollController,
                  itemCount: messages.length + (loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (loading && index == messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Thinking...",
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        ),
                      );
                    }

                    final msg = messages[index];
                    return Row(
                      mainAxisAlignment: msg.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isUser)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                'assets/bot_avatar.jpg',
                              ),
                            ),
                          ),
                        Flexible(
                          child: msg.isUser
                              ? _buildUserBubble(msg.text)
                              : _buildGlassBubble(msg.text),
                        ),
                        if (msg.isUser)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                'assets/user_avatar.png',
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              _buildInputBar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton.small(
              onPressed: loading ? null : () => generateText(),
              backgroundColor: Colors.lightGreenAccent[700],
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildUserBubble(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _buildGlassBubble(String text) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ),
  );
}

class _Message {
  final String text;
  final bool isUser;

  _Message(this.text, {required this.isUser});
}
