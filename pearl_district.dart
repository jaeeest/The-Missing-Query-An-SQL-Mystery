import 'package:flutter/material.dart';

class PearlDistrictScreen extends StatefulWidget {
  const PearlDistrictScreen({super.key});

  @override
  State<PearlDistrictScreen> createState() => _PearlDistrictScreenState();
}

class _PearlDistrictScreenState extends State<PearlDistrictScreen> {
  bool isQueryVisible = false;
  bool isTableVisible = false;
  bool isQuestionVisible = false;
  bool isCorrectVisible = false;
  bool isWrongVisible = false;

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

final List<List<String>> _insuranceData = [
    ['Giovanni Ltd', '4,500,000', '5,000,000', 'CRITICAL'],
    ['Viore Corp', '15,000', '0', 'STABLE'],
    ['Thorne Security', '150,000', '200,000', 'WARNING'],
    ['District Coffee', '5,000', '10,000', 'STABLE'],
    ['Press_Corp', '500,000', '1,000,000', 'WARNING'],
    ['Metro_Logistics', '1,200,000', '500,000', 'STABLE'],
    ['Silver_Lining_Inc', '20,000', '100,000', 'STABLE'],
    ['Dela_Cruz_Imports', '3,000,000', '3,500,000', 'CRITICAL'],
    ['Zenith_Telecom', '10,000,000', '25,000,000', 'STABLE'],
    ['Old_Town_Bakery', '2,000', '5,000', 'STABLE'],
    ['Aqua_Cleaners', '800', '2,000', 'STABLE'],
    ['Rossi_Cyber_Cons', '45,000', '50,000', 'STABLE'],
    ['Golden_Grains', '2,500,000', '10,000', 'LIQUIDATED'],
    ['The_Loupe_Lounge', '120,000', '250,000', 'STABLE'],
    ['Municipal_Records', '0', '0', 'N/A'],
    ['Fast_Lane_Auto', '85,000', '150,000', 'STABLE'],
    ['Urban_Design_Co', '300,000', '450,000', 'WARNING'],
    ['Miller_Finance', '5,000', '50,000', 'STABLE'],
    ['Spark_Electricity', '15,000,000', '50,000,000', 'STABLE'],
    ['Neon_Signs_Ltd', '12,000', '15,000', 'WARNING'],
    ['Thorne_Appraisals', '55,000', '100,000', 'STABLE'],
    ['Tech_Savvy_Repair', '3,500', '8,000', 'STABLE'],
    ['Pearl_City_Gym', '90,000', '50,000', 'WARNING'],
    ['Blue_Dolphin_Pub', '15,000', '20,000', 'STABLE'],
    ['Vane_Logistics_Sub', '400,000', '100,000', 'CRITICAL'],
  ];
  late List<List<String>> _filteredLogs;

  @override
  void initState() {
    super.initState();

    _filteredLogs = List.from(_insuranceData);
  }

void _runSqlQuery() {
    String query = _sqlController.text.toUpperCase().trim();

    setState(() {
      if (query.isEmpty || !query.contains("SELECT")) {
        _filteredLogs = List.from(_insuranceData);
      } else {
        _filteredLogs = _insuranceData.where((row) {
          bool matches = true;

          // STATUS filters
          if (query.contains("CRITICAL") && row[3] != "CRITICAL")
            matches = false;
          if (query.contains("STABLE") && row[3] != "STABLE") matches = false;
          if (query.contains("WARNING") && row[3] != "WARNING") matches = false;
          if (query.contains("LIQUIDATED") && row[3] != "LIQUIDATED")
            matches = false;
          if (query.contains("N/A") && row[3] != "N/A") matches = false;

          // COMPANY filters
          if (query.contains("GIOVANNI LTD") &&
              !row[0].toUpperCase().contains("GIOVANNI LTD"))
            matches = false;

          if (query.contains("VIORE CORP") &&
              !row[0].toUpperCase().contains("VIORE CORP"))
            matches = false;

          if (query.contains("ZENITH TELECOM") &&
              !row[0].toUpperCase().contains("ZENITH TELECOM"))
            matches = false;

          if (query.contains("DELA CRUZ IMPORTS") &&
              !row[0].toUpperCase().contains("DELA CRUZ IMPORTS"))
            matches = false;

          // Optional: numeric filtering (basic contains)
          if (query.contains("5000000") && !row[2].contains("5,000,000")) {
            matches = false;
          }

          return matches;
        }).toList();
      }

      isTableVisible = true;
    });
  }
  // Updated to match the 5 columns in the Intelligence table

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
                child: Image.asset('assets/insurance_loc.png', fit: BoxFit.fill),
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
                top: constraints.maxHeight * 0.42,
                left: constraints.maxWidth * 0.39,
                child: _buildAsteriskIcon(55),
              ),
              Positioned(
                top: constraints.maxHeight * 0.45,
                left: constraints.maxWidth * 0.580,
                child: _buildOverlayIcon('assets/investigate.png', 40),
              ),

              // Popups
              if (isQueryVisible) _buildPopUpContainer(constraints),
              if (isQuestionVisible) _buildQuestionPopUp(constraints),
              if (isCorrectVisible) _buildCorrectPopUp(constraints),
              if (isWrongVisible)
                _buildWrongPopUp(constraints), // NEW POPUP TRIGGER
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
                    'assets/insurance_question.png',
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
                    "How much debt does Giovanni Ltd actually carrying?",
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
                    textCapitalization:
                        TextCapitalization.characters, // Forces Caps
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

                // 5. Submit Button
                Positioned(
                  bottom: popupHeight * 0.0,
                  left: 35,
                  right: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (_answerController.text.trim().replaceAll(',', '') ==
                            "4500000") {
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

  // NEW WRONG POPUP BUILDER
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
      fontSize: 14,
    );
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/insurance_table.png', fit: BoxFit.fill),
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
          left: constraints.maxWidth * 0.08,
          right: constraints.maxWidth * 0.01,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: const Text('company', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('debt_level', style: headerStyle),
              ),
              Expanded(
                flex: 5,
                child: const Text('insurance_payout_val', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('status', style: headerStyle),
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
                child: Text(cell, style: cellStyle, textAlign: TextAlign.center),
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
          child: Image.asset('assets/insurance_query.png', fit: BoxFit.fill),
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

  Widget _buildOverlayIcon(String asset, double width) {
    return FloatingBubble(
      child: GestureDetector(
        onTap: () => debugPrint("Tapped $asset"),
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
