import 'dart:async';
import 'package:flutter/material.dart';

class BackAlleyScreen extends StatefulWidget {
  const BackAlleyScreen({super.key});

  @override
  State<BackAlleyScreen> createState() => _BackAlleyScreenState();
}

class _BackAlleyScreenState extends State<BackAlleyScreen> {
  bool isQueryVisible = false;
  bool isTableVisible = false;
  bool isQuestionVisible = false;
  bool isCorrectVisible = false;
  bool isWrongVisible = false;
  String? activeInvestigationText; // For typewriter logic

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final List<List<String>> _securityLogData = [
    [
      'M-890',
      'Metro_Logistics',
      'Truck-12',
      'Sam Rivera',
      '00:05:00',
      'Viore Loading Dock',
    ],
    [
      'M-891',
      'Press_Corp',
      'Sedan-4',
      'Izzy Fox',
      '00:15:00',
      'Giovanni Front',
    ],
    [
      'M-892',
      'Aqua_Cleaners',
      'Van-9',
      'Maria Santos',
      '00:30:00',
      'Service Entrance',
    ],
    [
      'M-893',
      'Viore Corp',
      'Truck-1',
      'Elena Rossi',
      '00:45:00',
      'Viore Loading Dock',
    ],
    [
      'M-899',
      'District Coffee',
      'Bike-1',
      'Unknown',
      '01:00:00',
      'Side Entrance',
    ],
    ['M-894', 'Silver_Lining', 'Van-3', 'Leo Moretti', '01:15:00', 'Main Gate'],
    [
      'M-895',
      'Zenith_Telecom',
      'Utility-5',
      'Tech_Unit_4',
      '01:30:00',
      'Viore Roof',
    ],
    [
      'M-896',
      'Giovanni Ltd',
      'Sedan-1',
      'Cassian Miller',
      '01:45:00',
      'The Loupe Parking',
    ],
    [
      'M-900',
      'Viore Corp',
      'Truck-2',
      'Elena Rossi',
      '02:00:00',
      'Viore Loading Dock',
    ],
    [
      'M-897',
      'Metro_Logistics',
      'Truck-15',
      'Silas Vane',
      '02:10:00',
      'Viore Loading Dock',
    ],
    [
      'M-898',
      'District_Library',
      'Van-22',
      'Unknown',
      '02:20:00',
      'Drop-off Zone',
    ],
    [
      'M-901',
      'Viore Corp',
      'Truck-7',
      'Elena Rossi',
      '02:30:00',
      'Viore Garage',
    ],
    [
      'M-902',
      'Giovanni Ltd',
      'Van-2',
      'Staff_Member',
      '02:45:00',
      'Storage Unit B',
    ],
    [
      'M-901',
      'Viore Corp',
      'Truck-7',
      'Silas Vane',
      '03:15:00',
      'Giovanni Alley',
    ],
    [
      'M-904',
      'Fast_Lane_Auto',
      'Tow-1',
      'Jim Brock',
      '03:35:00',
      'Side Street',
    ],
    [
      'M-905',
      'Viore Corp',
      'Truck-2',
      'Silas Vane',
      '03:45:00',
      'Viore Loading Dock',
    ],
  ];

  late List<List<String>> _filteredLogs;

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_securityLogData);
  }

  void _runSqlQuery() {
    String query = _sqlController.text.toUpperCase().trim();
    setState(() {
      if (query.isEmpty || !query.contains("SELECT")) {
        _filteredLogs = List.from(_securityLogData);
      } else {
        _filteredLogs = _securityLogData.where((row) {
          bool matches = true;
          if (query.contains("GIOVANNI ALLEY") &&
              !row[5].toUpperCase().contains("GIOVANNI ALLEY"))
            matches = false;
          if (query.contains("03:00") && row[4].compareTo("03:00:00") < 0)
            matches = false;
          if (query.contains("03:30") && row[4].compareTo("03:30:00") > 0)
            matches = false;
          return matches;
        }).toList();
      }
      isTableVisible = true;
    });
  }

  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FlexColumnWidth(3),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(2),
    3: FlexColumnWidth(3),
    4: FlexColumnWidth(3),
    5: FlexColumnWidth(4),
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
                child: Image.asset(
                  'assets/backalley_loc.png',
                  fit: BoxFit.fill,
                ),
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
                top: constraints.maxHeight * 0.53,
                left: constraints.maxWidth * 0.72,
                child: _buildAsteriskIcon(45),
              ),
              Positioned(
                top: constraints.maxHeight * 0.50,
                left: constraints.maxWidth * 0.66,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  40,
                  "A metal casing protecting the electrical connections that power the streetlights and external security systems.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.30,
                left: constraints.maxWidth * 0.54,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  40,
                  "A high-angle security camera that monitors foot traffic.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.65,
                left: constraints.maxWidth * 0.30,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  45,
                  "A steel waste container. ",
                ),
              ),

              // Typewriter Display
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

  Widget _buildOverlayIcon(String asset, double width, String description) {
    return FloatingBubble(
      child: GestureDetector(
        onTap: () => setState(() => activeInvestigationText = description),
        child: Image.asset(asset, width: width, fit: BoxFit.contain),
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
                    'assets/backalley_question.png',
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
                  top: popupHeight * 0.35,
                  left: popupWidth * 0.15,
                  right: popupWidth * 0.08,
                  child: const Text(
                    "Find the manifest_id for any vehicle scheduled to be in the Giovanni Alley between 03:00 and 03:30. Who was the registered driver_name?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 13,
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
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 35,
                  right: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (_answerController.text.trim().toUpperCase() ==
                            "SILAS VANE") {
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
      fontSize: 8,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/security_cam.png', fit: BoxFit.fill),
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
          left: constraints.maxWidth * 0.035,
          right: constraints.maxWidth * 0.035,
          child: Row(
            children: [
              Expanded(flex: 3, child: Text('manifest_id', style: headerStyle)),
              Expanded(
                flex: 3,
                child: Text('company_owner', style: headerStyle),
              ),
              Expanded(flex: 2, child: Text('vehicle_id', style: headerStyle)),
              Expanded(flex: 3, child: Text('driver_name', style: headerStyle)),
              Expanded(
                flex: 3,
                child: Text('scheduled_time', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: Text('location_tag', style: headerStyle),
              ),
            ],
          ),
        ),
        Positioned(
          top: constraints.maxHeight * 0.285,
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
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );
    return List<TableRow>.generate(_filteredLogs.length, (index) {
      return TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? const Color(0xFFFFF9C4).withOpacity(0.7)
              : const Color(0xFFF0E68C).withOpacity(0.5),
        ),
        children: _filteredLogs[index].map((cell) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              cell,
              style: cellStyle,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildQueryView(BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/backalley_query.png', fit: BoxFit.fill),
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
}

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 2),
      ),
      child: Text(
        _displayedText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Consolas',
        ),
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
