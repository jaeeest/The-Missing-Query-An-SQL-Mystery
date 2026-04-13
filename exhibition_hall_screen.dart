import 'dart:async'; // REQUIRED FOR TIMER
import 'package:flutter/material.dart';

class ExhibitionHallScreen extends StatefulWidget {
  const ExhibitionHallScreen({super.key});

  @override
  State<ExhibitionHallScreen> createState() => _ExhibitionHallScreenState();
}

class _ExhibitionHallScreenState extends State<ExhibitionHallScreen> {
  bool isQueryVisible = false;
  bool isTableVisible = false;
  bool isQuestionVisible = false;
  bool isCorrectVisible = false;
  bool isWrongVisible = false;
  String? activeInvestigationText; // NEW STATE FOR TYPEWRITER

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  // THE FULL DATASET
  final List<List<String>> _allLogs = [
    [
      'N385',
      '0:05:00',
      '192.168.1.10',
      'Lobby_Cam_01',
      'HEARTBEAT',
      'SysCheck',
    ],
    ['N386', '0:12:00', '10.0.0.12', 'Staff_WiFi', 'LOGIN', 'Mobile_OS'],
    ['N387', '0:30:00', '208.70.1.12', 'Giovanni_Email', 'SYNC', 'Exchange'],
    [
      'N388',
      '1:00:00',
      '192.168.1.50',
      'Server_Room',
      'TEMP_CHECK',
      'IoT_Sensor',
    ],
    [
      'N389',
      '1:15:00',
      '172.16.5.10',
      'External_Gate',
      'SCAN_CARD',
      'RFID_Reader',
    ],
    ['N390', '1:20:00', '45.12.90.1', 'Web_Server', 'PING', 'Unknown'],
    ['N391', '1:45:00', '192.168.1.15', 'Main_Server', 'REINDEX', 'SQL_Admin'],
    ['N392', '1:55:00', '10.0.0.8', 'Staff_WiFi', 'DISCONNECT', 'Timeout'],
    ['N399', '2:00:00', '192.168.1.15', 'Main_Server', 'BACKUP', 'ADMIN_ROSSI'],
    [
      'N400a',
      '2:05:00',
      '192.168.1.20',
      'Hall_Monitor',
      'REBOOT',
      'System_Task',
    ],
    ['N400', '2:15:00', '10.0.0.5', 'Vault_Gate', 'FAILED_LOGIN', 'Unknown'],
    [
      'N400b',
      '2:20:00',
      '172.16.10.5',
      'Viore_Proxy',
      'VPN_CONNECT',
      'OpenVPN',
    ],
    ['N400c', '2:35:00', '10.0.0.15', 'Guest_WiFi', 'DOWNLOAD', 'Browser'],
    ['N400d', '2:45:00', '192.168.1.12', 'CCTV_Main', 'ROTATE_LOGS', 'CronJob'],
    [
      'N401',
      '2:50:00',
      '172.16.10.20',
      'Vault_Gate',
      'PORT_SCAN',
      'NullByte-v7',
    ],
    [
      'N402',
      '3:00:00',
      '172.16.10.20',
      'Vault_Lock',
      'OVERRIDE',
      'NullByte-v7',
    ],
    [
      'N403',
      '3:05:00',
      '172.16.10.20',
      'Pearl_Pedestal',
      'OPEN',
      'ADMIN_ROSSI',
    ],
    [
      'N403a',
      '3:10:00',
      '172.16.10.20',
      'Exit_Sensor',
      'TRIGGER',
      'Laser_Trip',
    ],
    [
      'N403b',
      '3:15:00',
      '192.168.1.15',
      'Main_Server',
      'SYNC_COMPLETE',
      'SQL_Admin',
    ],
    ['N403c', '3:30:00', '10.0.0.1', 'Router_Main', 'RESTART', 'Admin_Panel'],
    [
      'N403d',
      '3:45:00',
      '45.12.90.1',
      'Web_Server',
      'DDOS_ATTACK',
      'Botnet_01',
    ],
    ['N403e', '3:50:00', '192.168.1.1', 'Firewall', 'BLOCK_IP', 'Auto_Guard'],
    [
      'N403f',
      '4:00:00',
      '192.168.1.10',
      'Lobby_Cam_01',
      'HEARTBEAT',
      'SysCheck',
    ],
    [
      'N403g',
      '4:15:00',
      '172.16.5.15',
      'Service_Lift',
      'CALIBRATE',
      'Mech_App',
    ],
    ['N404', '4:30:00', '208.70.1.12', 'Giovanni_Email', 'LOGIN', 'Outlook'],
    ['N405', '4:45:00', '10.0.0.12', 'Staff_WiFi', 'LOGIN', 'Mobile_OS'],
  ];

  late List<List<String>> _filteredLogs;

  @override
  void initState() {
    super.initState();
    _filteredLogs = List.from(_allLogs);
  }

  void _runSqlQuery() {
    String query = _sqlController.text.toUpperCase();
    setState(() {
      if (query.isEmpty || !query.contains("SELECT")) {
        _filteredLogs = List.from(_allLogs);
      } else {
        _filteredLogs = _allLogs.where((row) {
          bool matches = true;
          if (query.contains("PEARL_PEDESTAL") &&
              !row[3].toUpperCase().contains("PEARL_PEDESTAL")) {
            matches = false;
          }
          if (query.contains("OVERRIDE") &&
              !row[4].toUpperCase().contains("OVERRIDE")) {
            matches = false;
          }
          if (query.contains("NULLBYTE-V7") &&
              !row[5].toUpperCase().contains("NULLBYTE-V7")) {
            matches = false;
          }
          return matches;
        }).toList();
      }
      isTableVisible = true;
    });
  }

  final Map<int, TableColumnWidth> _columnWidths = const {
    0: FlexColumnWidth(2),
    1: FlexColumnWidth(3),
    2: FlexColumnWidth(4),
    3: FlexColumnWidth(4),
    4: FlexColumnWidth(3),
    5: FlexColumnWidth(3),
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
                  'assets/exhibition_hall_loc.png',
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
                left: constraints.maxWidth * 0.11,
                child: _buildAsteriskIcon(55),
              ),
              Positioned(
                top: constraints.maxHeight * 0.25,
                left: constraints.maxWidth * 0.10,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  50,
                  "A broken CCTV camera.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.44,
                left: constraints.maxWidth * 0.505,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  50,
                  "A reinforced glass pedestal that once held the Pearl of the Orient Sea.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.47,
                left: constraints.maxWidth * 0.583,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  45,
                  "A digital keypad that requires admin privileges to disarm.",
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.80,
                left: constraints.maxWidth * 0.71,
                child: _buildOverlayIcon(
                  'assets/investigate.png',
                  50,
                  "Dusty footprints leading to the glass pedestal.",
                ),
              ),

              // Typewriter Display Logic
              if (activeInvestigationText != null)
                Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: TypewriterText(
                      key: ValueKey(
                        activeInvestigationText,
                      ), // Restarts on click
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

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: SizedBox(
            width: constraints.maxWidth * 0.68,
            height: constraints.maxHeight * 0.65,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/viore_question.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: InkWell(
                    onTap: () => setState(() => isQuestionVisible = false),
                    child: Image.asset('assets/close_button.png', height: 25),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight * 0.25,
                  left: constraints.maxWidth * 0.08,
                  right: constraints.maxWidth * 0.08,
                  child: const Text(
                    "Who is the owner of the NullByte-v7 software?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight * 0.43,
                  left: constraints.maxWidth * 0.15,
                  right: constraints.maxWidth * 0.10,
                  child: TextField(
                    controller: _answerController,
                    textAlign: TextAlign.center,
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
                  bottom: constraints.maxHeight * 0.005,
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
                        height: 32,
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
          child: Image.asset('assets/network_logs.png', fit: BoxFit.fill),
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
                flex: 2,
                child: const Text('log_id', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('access_time', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: const Text('source_ip', style: headerStyle),
              ),
              Expanded(
                flex: 4,
                child: const Text('target', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('action', style: headerStyle),
              ),
              Expanded(
                flex: 3,
                child: const Text('tool_used', style: headerStyle),
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
          child: Image.asset('assets/giovanni_query.png', fit: BoxFit.fill),
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

  // UPDATED METHOD TO TRIGGER TYPEWRITER
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

// COPIED TYPEWRITER COMPONENT FROM POLICE STATION
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
