import 'dart:async'; // Added for Timer
import 'package:flutter/material.dart';

class LoupeScreen extends StatefulWidget {
  const LoupeScreen({super.key});

  @override
  State<LoupeScreen> createState() => _LoupeScreenState();
}

class _LoupeScreenState extends State<LoupeScreen> {
  bool isQueryVisible = false;
  bool isTableVisible = false;
  bool isQuestionVisible = false;
  bool isCorrectVisible = false;
  bool isWrongVisible = false;
  String? activeInvestigationText; // Added: State for typewriter logic

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final List<List<String>> _tradeSecretsData = [
    // trans_id, payer_name, recipient_name, amount, payment_method
    ['T-090', 'Sarah Jenkins', 'The Loupe', '25', 'Credit'],
    ['T-091', 'Leo Moretti', 'The Loupe', '10', 'Cash'],
    ['T-092', 'Unknown', 'The Loupe', '45', 'Cash'],
    ['T-093', 'David Chen', 'The Loupe', '15', 'Credit'],
    ['T-099', 'Leo Moretti', 'The Loupe', '15', 'Cash'],
    ['T-100', 'Elena Rossi', 'Silas Vane', '20', 'Cash'],
    ['T-100a', 'Julian Thorne', 'The Loupe', '85', 'Credit'],
    ['T-100b', 'Silas Vane', 'The Loupe', '12', 'Cash'],
    ['T-101', 'Cassian Miller', 'Silas Vane', '5000', 'Wire_Transfer'],
    ['T-102', 'Cassian Miller', 'Julian Thorne', '2000', 'Wire_Transfer'],
    ['T-103', 'Marco Miller', 'The Loupe', '30', 'Credit'],
    ['T-104', 'Victor Thorne', 'The Loupe', '60', 'Cash'],
    ['T-105', 'Victor Thorne', 'Julian Thorne', '500', 'Cash'],
    ['T-106', 'Isabella Fox', 'The Loupe', '12', 'Credit'],
    ['T-107', 'Ben Dela-Cruz', 'The Loupe', '22', 'Cash'],
    ['T-108', 'Silas Vane', 'The Loupe', '150', 'Credit'],
    ['T-109', 'Cassian Miller', 'The Loupe', '40', 'Credit'],
    ['T-110', 'Julian Thorne', 'Victor Thorne', '100', 'Cash'],
    ['T-111', 'Elena Vane', 'The Loupe', '10', 'Cash'],
    ['T-112', 'Marco Giovanni', 'The Loupe', '300', 'Credit'],
    ['T-113', 'Cassian Miller', 'Sarah Jenkins', '50', 'Cash'],
    ['T-114', 'Silas Vane', 'The Loupe', '500', 'Cash'],
    ['T-115', 'Julian Thorne', 'The Loupe', '200', 'Credit'],
    ['T-116', 'Marcus Dela-Cruz', 'The Loupe', '35', 'Cash'],
    ['T-117', 'Sam Rivera', 'The Loupe', '18', 'Credit'],
  ];
  late List<List<String>> _filteredLogs;

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_tradeSecretsData);
  }

  void _runSqlQuery() {
    String query = _sqlController.text.toUpperCase().trim();

    setState(() {
      if (query.isEmpty || !query.contains("SELECT")) {
        _filteredLogs = List.from(_tradeSecretsData);
      } else {
        _filteredLogs = _tradeSecretsData.where((row) {
          bool matches = true;

          // PAYMENT METHOD filters
          if (query.contains("CASH") && row[4].toUpperCase() != "CASH") {
            matches = false;
          }
          if (query.contains("CREDIT") && row[4].toUpperCase() != "CREDIT") {
            matches = false;
          }
          if (query.contains("WIRE_TRANSFER") &&
              row[4].toUpperCase() != "WIRE_TRANSFER") {
            matches = false;
          }

          // PAYER filters
          if (query.contains("CASSIAN MILLER") &&
              !row[1].toUpperCase().contains("CASSIAN MILLER")) {
            matches = false;
          }
          if (query.contains("SILAS VANE") &&
              !row[1].toUpperCase().contains("SILAS VANE")) {
            matches = false;
          }
          if (query.contains("JULIAN THORNE") &&
              !row[1].toUpperCase().contains("JULIAN THORNE")) {
            matches = false;
          }

          // RECIPIENT filters
          if (query.contains("THE LOUPE") &&
              !row[2].toUpperCase().contains("THE LOUPE")) {
            matches = false;
          }
          if (query.contains("SARAH JENKINS") &&
              !row[2].toUpperCase().contains("SARAH JENKINS")) {
            matches = false;
          }

          // AMOUNT filter
          if (query.contains("5000") && row[3] != "5000") {
            matches = false;
          }
          if (query.contains("2000") && row[3] != "2000") {
            matches = false;
          }

          return matches;
        }).toList();
      }
      isTableVisible = true;
    });
  }

  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FlexColumnWidth(4),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(4),
    3: FlexColumnWidth(4),
    4: FlexColumnWidth(3),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/loupe_loc.png', fit: BoxFit.fill),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/back_button.png',
                              height: 40,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () => Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            ),
                            child: Image.asset(
                              'assets/home_button.png',
                              height: 40,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isQueryVisible = true;
                                isTableVisible = false;
                                isQuestionVisible = false;
                              });
                            },
                            child: Image.asset(
                              'assets/query_button.png',
                              height: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Icons
              Positioned(
                top: constraints.maxHeight * 0.54,
                left: constraints.maxWidth * 0.57,
                child: _buildAsteriskIcon(50),
              ),
              Positioned(
                top: constraints.maxHeight * 0.54,
                left: constraints.maxWidth * 0.62,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  40,
                  "A sealed, unmarked envelope filled with money.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.35,
                left: constraints.maxWidth * 0.13,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  50,
                  "A long wooden shelf lined with bottles.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.35,
                left: constraints.maxWidth * 0.48,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  35,
                  "A small stage for entertainment.",
                ),
              ),

              // Typewriter Overlay logic applied from Police Station
              if (activeInvestigationText != null)
                Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: TypewriterText(
                      key: ValueKey(activeInvestigationText),
                      text: activeInvestigationText!,
                      onFinished: () =>
                          setState(() => activeInvestigationText = null),
                    ),
                  ),
                ),

              // Popups
              if (isQueryVisible) _buildPopUpContainer(constraints),
              if (isQuestionVisible) _buildQuestionPopUp(constraints),
              if (isCorrectVisible) _buildCorrectPopUp(constraints),
              if (isWrongVisible) _buildWrongPopUp(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAsteriskIcon(double width) {
    return FloatingBubble(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isQuestionVisible = true;
            isQueryVisible = false;
            isTableVisible = false;
          });
        },
        child: Image.asset(
          'assets/asterisk.png',
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildQuestionPopUp(BoxConstraints constraints) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double popupHeight = constraints.maxHeight * 0.65;
    final double popupWidth = constraints.maxWidth * 0.68;

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SizedBox(
            width: popupWidth,
            height: popupHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/loupe_question.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: InkWell(
                    onTap: () => setState(() => isQuestionVisible = false),
                    child: Image.asset('assets/close_button.png', height: 25),
                  ),
                ),
                Positioned(
                  top: popupHeight * 0.40,
                  left: popupWidth * 0.15,
                  right: popupWidth * 0.08,
                  child: const Text(
                    "Who paid Silas Vane 5,000 three days before the heist?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Positioned(
                  top: popupHeight * 0.68,
                  left: popupWidth * 0.23,
                  right: popupWidth * 0.15,
                  child: TextField(
                    controller: _answerController,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Luckiest Guy',
                    ),
                    decoration: const InputDecoration(
                      hintText: "TYPE ANSWER...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Positioned(
                  bottom: popupHeight * 0.0,
                  left: 35,
                  right: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (_answerController.text.trim().toUpperCase() ==
                            "CASSIAN MILLER") {
                          setState(() {
                            isQuestionVisible = false;
                            isCorrectVisible = true;
                            isWrongVisible = false;
                          });
                        } else {
                          setState(() {
                            isQuestionVisible = false;
                            isWrongVisible = true;
                            isCorrectVisible = false;
                          });
                        }
                      },
                      child: Image.asset(
                        'assets/submit_button.png',
                        height: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectPopUp(BoxConstraints constraints) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: SizedBox(
          width: constraints.maxWidth * 0.65,
          height: constraints.maxHeight * 0.50,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/correct.png', fit: BoxFit.contain),
              ),
              Positioned(
                top: 10,
                right: 110,
                child: InkWell(
                  onTap: () => setState(() => isCorrectVisible = false),
                  child: Image.asset('assets/close_button.png', height: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWrongPopUp(BoxConstraints constraints) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: SizedBox(
          width: constraints.maxWidth * 0.65,
          height: constraints.maxHeight * 0.50,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/wrong.png', fit: BoxFit.contain),
              ),
              Positioned(
                top: 10,
                right: 110,
                child: InkWell(
                  onTap: () => setState(() => isWrongVisible = false),
                  child: Image.asset('assets/close_button.png', height: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopUpContainer(BoxConstraints constraints) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SizedBox(
            width: constraints.maxWidth * 0.68,
            height: constraints.maxHeight * 0.75,
            child: isTableVisible
                ? _buildTableView(constraints)
                : _buildQueryView(constraints),
          ),
        ),
      ),
    );
  }

  Widget _buildTableView(BoxConstraints constraints) {
    const headerStyle = TextStyle(
      fontFamily: 'Consolas',
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/trade_secrets.png', fit: BoxFit.fill),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: InkWell(
            onTap: () => setState(() => isTableVisible = false),
            child: Image.asset('assets/close_button.png', height: 25),
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.210,
          left: constraints.maxWidth * 0.05,
          right: constraints.maxWidth * 0.01,
          child: Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text('trans_id', style: headerStyle),
              ),
              const Expanded(
                flex: 4,
                child: Text('payer_name', style: headerStyle),
              ),
              const Expanded(
                flex: 5,
                child: Text('recipient_name', style: headerStyle),
              ),
              const Expanded(
                flex: 3,
                child: Text('amount', style: headerStyle),
              ),
              const Expanded(
                flex: 5,
                child: Text('payment_method', style: headerStyle),
              ),
            ],
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.290,
          left: constraints.maxWidth * 0.02,
          right: constraints.maxWidth * 0.03,
          bottom: constraints.maxHeight * 0.05,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Table(
              columnWidths: _columnWidths,
              children: _buildTableRowsList(),
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> _buildTableRowsList() {
    const cellStyle = TextStyle(
      fontFamily: 'Consolas',
      color: Colors.black,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
    return List<TableRow>.generate(_filteredLogs.length, (index) {
      return TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? const Color(0xFFFFF9C4).withOpacity(0.7)
              : const Color(0xFFF0E68C).withOpacity(0.5),
        ),
        children: _filteredLogs[index]
            .map(
              (cell) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 7.0,
                ),
                child: Text(
                  cell,
                  style: cellStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget _buildQueryView(BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/loupe_query.png', fit: BoxFit.fill),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: InkWell(
            onTap: () => setState(() => isQueryVisible = false),
            child: Image.asset('assets/close_button.png', height: 25),
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.10,
          left: constraints.maxWidth * 0.05,
          right: constraints.maxWidth * 0.08,
          bottom: constraints.maxHeight * 0.18,
          child: TextField(
            controller: _sqlController,
            maxLines: null,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: "ENTER SQL QUERY...",
              border: InputBorder.none,
            ),
          ),
        ),
        Positioned(
          bottom: constraints.maxHeight * 0.03,
          left: constraints.maxWidth * 0.03,
          right: constraints.maxWidth * 0.03,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => isTableVisible = true),
                child: Image.asset('assets/tables_button.png', height: 35),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => _sqlController.clear(),
                    child: Image.asset('assets/clear_button.png', height: 35),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _runSqlQuery,
                    child: Image.asset('assets/run_button.png', height: 35),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Updated to include description logic
  Widget _buildOverlayIcon(String asset, double width, String description) {
    return FloatingBubble(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeInvestigationText = description;
          });
        },
        child: Image.asset(asset, width: width, fit: BoxFit.contain),
      ),
    );
  }
}

class FloatingBubble extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  const FloatingBubble({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.offset = 8.0,
  });
  @override
  State<FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<FloatingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, widget.offset * _controller.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

// Added TypewriterText class to make the screen functional
class TypewriterText extends StatefulWidget {
  final String text;
  final VoidCallback onFinished;

  const TypewriterText({
    super.key,
    required this.text,
    required this.onFinished,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  int _charIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_charIndex < widget.text.length) {
        if (mounted) {
          setState(() {
            _displayedText += widget.text[_charIndex];
            _charIndex++;
          });
        }
      } else {
        _timer?.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) widget.onFinished();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blueGrey, width: 2),
      ),
      child: Text(
        _displayedText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Consolas',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
