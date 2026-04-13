import 'dart:async'; // REQUIRED FOR TIMER
import 'package:flutter/material.dart';

class VioreHqScreen extends StatefulWidget {
  const VioreHqScreen({super.key});

  @override
  State<VioreHqScreen> createState() => _VioreHqScreenState();
}

class _VioreHqScreenState extends State<VioreHqScreen> {
  bool isQueryVisible = false;
  bool isTableVisible = false;
  bool isQuestionVisible = false;
  bool isCorrectVisible = false;
  bool isWrongVisible = false;
  String? activeInvestigationText; // NEW STATE FOR TYPEWRITER

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final List<List<String>> _intelligenceData = [
    ['Viore Corp', '172.16.10.0/24', 'NullByte-v7', 'ACTIVE', '1,500,000'],
    ['Giovanni Ltd', '208.70.1.0/24', 'Legacy_SAP_v4', 'EXPIRED', '12,000'],
    ['Thorne Appraisals', '192.168.5.1', 'GemScan_Pro', 'ACTIVE', '45,000'],
    ['District Coffee', '10.0.0.0/8', 'POS_Brew_v2', 'ACTIVE', '5,000'],
    ['Press_Corp', '45.12.33.0/24', 'EditMaster_Pro', 'ACTIVE', '250,000'],
    ['Thorne Security', '10.0.0.5/32', 'SpyGlass_Lite', 'TRIAL', '85,000'],
    ['Blue_Dolphin_Pub', '192.168.10.12', 'BarKeep_3000', 'ACTIVE', '2,500'],
    ['Metro_Logistics', '172.16.20.0/24', 'FleetTrack_v9', 'ACTIVE', '400,000'],
    ['Silver_Lining_Inc', '208.70.5.50', 'CloudVault_01', 'ACTIVE', '95,000'],
    ['Pearl_City_Gym', '10.0.0.122', 'FitLogic_Pro', 'EXPIRED', '1,200'],
    ['Vane_Logistics_Sub', '172.16.10.45', 'Courier_Sync', 'ACTIVE', '15,000'],
    ['District_Library', '45.12.90.0/24', 'BookStack_SQL', 'ACTIVE', '50,000'],
    ['Zenith_Telecom', '172.16.0.0/16', 'NetCommander', 'ACTIVE', '3,200,000'],
    ['Old_Town_Bakery', '192.168.1.10', 'FlourPower_v1', 'EXPIRED', '400'],
    ['Aqua_Cleaners', '10.10.5.1', 'DryWash_Manager', 'TRIAL', '3,000'],
    ['Rossi_Cyber_Cons', '172.16.10.101', 'ShieldWall_v2', 'ACTIVE', '110,000'],
    ['Golden_Grains', '208.70.1.5', 'Harvest_Tracker', 'EXPIRED', '8,500'],
    ['The_Loupe_Lounge', '192.168.55.1', 'Pour_Control_X', 'ACTIVE', '12,000'],
    [
      'Municipal_Records',
      '45.12.1.0/24',
      'Archive_Deep_04',
      'ACTIVE',
      '500,000',
    ],
    ['Fast_Lane_Auto', '10.0.4.20', 'GearShift_ERP', 'ACTIVE', '22,000'],
    ['Urban_Design_Co', '172.16.88.10', 'SketchBuild_3D', 'ACTIVE', '140,000'],
    ['Miller_Finance', '208.70.1.15', 'TaxCalc_Gold', 'ACTIVE', '35,000'],
    ['Spark_Electricity', '45.12.15.5', 'GridMaster_v5', 'ACTIVE', '900,000'],
    ['Neon_Signs_Ltd', '192.168.3.3', 'GlowControl', 'TRIAL', '4,500'],
    ['Dela_Cruz_Imports', '172.16.55.20', 'CargoLog_v2', 'EXPIRED', '60,000'],
    ['Tech_Savvy_Repair', '10.0.9.9', 'FixIt_Toolkit', 'ACTIVE', '7,500'],
  ];

  late List<List<String>> _filteredLogs;

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_intelligenceData);
  }

  void _runSqlQuery() {
    String query = _sqlController.text.toUpperCase().trim();
    setState(() {
      if (query.isEmpty || !query.contains("SELECT")) {
        _filteredLogs = List.from(_intelligenceData);
      } else {
        _filteredLogs = _intelligenceData.where((row) {
          bool matches = true;
          if (query.contains("EXPIRED") && row[3] != "EXPIRED") matches = false;
          if (query.contains("ACTIVE") && row[3] != "ACTIVE") matches = false;
          if (query.contains("TRIAL") && row[3] != "TRIAL") matches = false;
          if (query.contains("NULLBYTE-V7") &&
              !row[2].toUpperCase().contains("NULLBYTE-V7"))
            matches = false;
          if (query.contains("VIORE CORP") &&
              !row[0].toUpperCase().contains("VIORE CORP"))
            matches = false;
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
                child: Image.asset('assets/viore_hq_loc.png', fit: BoxFit.fill),
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
                left: constraints.maxWidth * 0.48,
                child: _buildAsteriskIcon(55),
              ),
              Positioned(
                top: constraints.maxHeight * 0.47,
                left: constraints.maxWidth * 0.810,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  45,
                  "A secure workstation displaying encrypted logs.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.80,
                left: constraints.maxWidth * 0.35,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  50,
                  "Access credentials found on a discarded badge.",
                ),
              ),

              // Typewriter Overlay
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
                    'assets/viore_question.png',
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
                    "Who is the owner of the NullByte-v7 software?",
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
                            "VIORE CORP") {
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
          child: Image.asset('assets/intelligence.png', fit: BoxFit.fill),
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
          left: constraints.maxWidth * 0.03,
          right: constraints.maxWidth * 0.01,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: const Text('company_name', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: const Text('public_ip_range', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: const Text('unique software', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: const Text('license status', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('asset_value', style: headerStyle),
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
                  horizontal: 6.0,
                ),
                child: Text(cell, style: cellStyle),
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
          child: Image.asset('assets/viore_query.png', fit: BoxFit.fill),
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

  // Updated method to trigger typewriter
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

// Typewriter Component from Police Station
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
