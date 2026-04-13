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

  String? activeInvestigationText;

  final TextEditingController _sqlController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final ScrollController _sqlScrollController = ScrollController();

  final List<String> _headers = const [
    'manifest_id',
    'company_owner',
    'vehicle_id',
    'driver_name',
    'scheduled_time',
    'location_tag',
  ];

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

  late List<Map<String, String>> _allSecurityMaps;
  late List<Map<String, String>> _filteredSecurityMaps;
  late List<String> _visibleHeaders;

  @override
  void initState() {
    super.initState();

    _allSecurityMaps = _securityLogData.map((row) {
      return {
        'manifest_id': row[0],
        'company_owner': row[1],
        'vehicle_id': row[2],
        'driver_name': row[3],
        'scheduled_time': row[4],
        'location_tag': row[5],
      };
    }).toList();

    _filteredSecurityMaps = List.from(_allSecurityMaps);
    _visibleHeaders = List.from(_headers);

    _sqlController.addListener(() {
      if (mounted) setState(() {});
    });

    _answerController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sqlController.dispose();
    _answerController.dispose();
    _sqlScrollController.dispose();
    super.dispose();
  }

  String _normalizeAnswer(String value) {
    return value.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  bool _isBackAlleyCorrectAnswer(String input) {
    final normalized = _normalizeAnswer(input);
    const acceptedAnswers = {'SILAS VANE', 'SILAS'};
    return acceptedAnswers.contains(normalized);
  }

  void _runSqlQuery() {
    final rawQuery = _sqlController.text.trim();

    if (rawQuery.isEmpty) {
      setState(() {
        _filteredSecurityMaps = List.from(_allSecurityMaps);
        _visibleHeaders = List.from(_headers);
        isTableVisible = true;
      });
      return;
    }

    try {
      final result = _executeSimpleSql(rawQuery);

      setState(() {
        _filteredSecurityMaps = result.rows;
        _visibleHeaders = result.columns;
        isTableVisible = true;
      });
    } catch (_) {
      setState(() {
        _filteredSecurityMaps = [];
        _visibleHeaders = List.from(_headers);
        isTableVisible = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or unsupported query format.')),
      );
    }
  }

  _QueryResult _executeSimpleSql(String rawQuery) {
    final query = rawQuery.trim();
    final upper = query.toUpperCase();

    if (!upper.startsWith('SELECT ')) {
      throw Exception('Only SELECT queries are supported.');
    }

    final fromMatch = RegExp(
      r'\bFROM\b',
      caseSensitive: false,
    ).firstMatch(query);
    if (fromMatch == null) {
      throw Exception('Missing FROM clause.');
    }

    final selectPart = query.substring(6, fromMatch.start).trim();
    final afterFrom = query.substring(fromMatch.end).trim();

    final whereMatch = RegExp(
      r'\bWHERE\b',
      caseSensitive: false,
    ).firstMatch(afterFrom);
    final orderByMatch = RegExp(
      r'\bORDER\s+BY\b',
      caseSensitive: false,
    ).firstMatch(afterFrom);
    final limitMatch = RegExp(
      r'\bLIMIT\b',
      caseSensitive: false,
    ).firstMatch(afterFrom);

    int cutIndex = afterFrom.length;
    for (final match in [whereMatch, orderByMatch, limitMatch]) {
      if (match != null && match.start < cutIndex) {
        cutIndex = match.start;
      }
    }

    final tableName = afterFrom.substring(0, cutIndex).trim().toLowerCase();
    if (tableName != 'security_log_data') {
      throw Exception('Unknown table.');
    }

    List<String> selectedColumns;
    if (selectPart == '*') {
      selectedColumns = List.from(_headers);
    } else {
      selectedColumns = selectPart
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .toList();

      for (final col in selectedColumns) {
        if (!_headers.contains(col)) {
          throw Exception('Unknown column: $col');
        }
      }
    }

    String? whereClause;
    String? orderByColumn;
    bool orderDescending = false;
    int? limit;

    if (whereMatch != null) {
      final start = whereMatch.end;
      int end = afterFrom.length;
      if (orderByMatch != null && orderByMatch.start > whereMatch.start) {
        end = orderByMatch.start;
      } else if (limitMatch != null && limitMatch.start > whereMatch.start) {
        end = limitMatch.start;
      }
      whereClause = afterFrom.substring(start, end).trim();
    }

    if (orderByMatch != null) {
      final start = orderByMatch.end;
      int end = afterFrom.length;
      if (limitMatch != null && limitMatch.start > orderByMatch.start) {
        end = limitMatch.start;
      }
      final orderClause = afterFrom.substring(start, end).trim();
      final parts = orderClause.split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        orderByColumn = parts.first.toLowerCase();
        if (!_headers.contains(orderByColumn)) {
          throw Exception('Unknown ORDER BY column.');
        }
        if (parts.length > 1) {
          orderDescending = parts[1].toUpperCase() == 'DESC';
        }
      }
    }

    if (limitMatch != null) {
      final limitText = afterFrom.substring(limitMatch.end).trim();
      limit = int.tryParse(limitText.split(RegExp(r'\s+')).first);
    }

    List<Map<String, String>> rows = List.from(_allSecurityMaps);

    if (whereClause != null && whereClause.isNotEmpty) {
      rows = rows
          .where((row) => _evaluateWhereClause(row, whereClause!))
          .toList();
    }

    if (orderByColumn != null) {
      rows.sort((a, b) {
        final av = a[orderByColumn] ?? '';
        final bv = b[orderByColumn] ?? '';

        if (orderByColumn == 'scheduled_time') {
          return orderDescending ? bv.compareTo(av) : av.compareTo(bv);
        }

        final au = av.toUpperCase();
        final bu = bv.toUpperCase();
        return orderDescending ? bu.compareTo(au) : au.compareTo(bu);
      });
    }

    if (limit != null && limit >= 0 && limit < rows.length) {
      rows = rows.take(limit).toList();
    }

    return _QueryResult(rows: rows, columns: selectedColumns);
  }

  bool _evaluateWhereClause(Map<String, String> row, String clause) {
    final orParts = clause.split(RegExp(r'\s+OR\s+', caseSensitive: false));

    for (final orPart in orParts) {
      final andParts = orPart.split(RegExp(r'\s+AND\s+', caseSensitive: false));
      bool andResult = true;

      for (final condition in andParts) {
        if (!_evaluateCondition(row, condition.trim())) {
          andResult = false;
          break;
        }
      }

      if (andResult) return true;
    }

    return false;
  }

  bool _evaluateCondition(Map<String, String> row, String condition) {
    final likeMatch = RegExp(
      r"^(\w+)\s+LIKE\s+'([^']*)'$",
      caseSensitive: false,
    ).firstMatch(condition);

    if (likeMatch != null) {
      final column = likeMatch.group(1)!.toLowerCase();
      final pattern = likeMatch.group(2)!;
      final value = row[column] ?? '';
      if (!_headers.contains(column)) return false;

      final regexPattern = '^${RegExp.escape(pattern).replaceAll('%', '.*')}\$';
      return RegExp(regexPattern, caseSensitive: false).hasMatch(value);
    }

    final eqMatch = RegExp(
      r"^(\w+)\s*(=|!=|<>)\s*'([^']*)'$",
      caseSensitive: false,
    ).firstMatch(condition);

    if (eqMatch != null) {
      final column = eqMatch.group(1)!.toLowerCase();
      final op = eqMatch.group(2)!;
      final expected = eqMatch.group(3)!;
      final actual = row[column] ?? '';
      if (!_headers.contains(column)) return false;

      switch (op) {
        case '=':
          return actual.toUpperCase() == expected.toUpperCase();
        case '!=':
        case '<>':
          return actual.toUpperCase() != expected.toUpperCase();
      }
    }

    final timeCompareMatch = RegExp(
      r"^(\w+)\s*(>=|<=|>|<)\s*'([^']*)'$",
      caseSensitive: false,
    ).firstMatch(condition);

    if (timeCompareMatch != null) {
      final column = timeCompareMatch.group(1)!.toLowerCase();
      final op = timeCompareMatch.group(2)!;
      final expected = timeCompareMatch.group(3)!;
      final actual = row[column] ?? '';
      if (!_headers.contains(column)) return false;

      final compare = actual.compareTo(expected);
      switch (op) {
        case '>':
          return compare > 0;
        case '<':
          return compare < 0;
        case '>=':
          return compare >= 0;
        case '<=':
          return compare <= 0;
      }
    }

    return false;
  }

  Widget _buildAsteriskIcon(double width) {
    return GlowingClue(
      child: FloatingBubble(
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
      ),
    );
  }

  Widget _buildAnswerKeyboardPreview() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (!isQuestionVisible || keyboardHeight == 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 20,
      right: 20,
      bottom: keyboardHeight + 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF7A4B28), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            _answerController.text.isEmpty
                ? 'TYPE ANSWER...'
                : _answerController.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _answerController.text.isEmpty
                  ? Colors.grey
                  : Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Luckiest Guy',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSqlKeyboardPreview() {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if (!isQueryVisible || keyboardHeight == 0 || isTableVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 20,
      right: 20,
      bottom: keyboardHeight + 10,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 140),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.97),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF7A4B28), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: RichText(
              text: _buildSqlHighlightedText(
                _sqlController.text.isEmpty
                    ? "ENTER SQL QUERY..."
                    : _sqlController.text,
                isHint: _sqlController.text.isEmpty,
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                  "A steel waste container.",
                ),
              ),

              if (activeInvestigationText != null)
                Center(
                  child: SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: InvestigationTypewriter(
                      key: ValueKey(activeInvestigationText),
                      text: activeInvestigationText!,
                      onFinished: () =>
                          setState(() => activeInvestigationText = null),
                    ),
                  ),
                ),

              if (isQueryVisible)
                AnimatedPopup(child: _buildPopUpContainer(constraints)),
              if (isQuestionVisible)
                AnimatedPopup(child: _buildQuestionPopUp(constraints)),
              if (isCorrectVisible)
                AnimatedPopup(child: _buildCorrectPopUp(constraints)),
              if (isWrongVisible)
                AnimatedPopup(child: _buildWrongPopUp(constraints)),

              _buildSqlKeyboardPreview(),
              _buildAnswerKeyboardPreview(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionPopUp(BoxConstraints constraints) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: SizedBox(
          width: constraints.maxWidth * 0.68,
          height: constraints.maxHeight * 0.65,
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
                top: constraints.maxHeight * 0.25,
                left: constraints.maxWidth * 0.08,
                right: constraints.maxWidth * 0.08,
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
                top: constraints.maxHeight * 0.44,
                left: constraints.maxWidth * 0.15,
                right: constraints.maxWidth * 0.10,
                child: Opacity(
                  opacity: 0.50,
                  child: TextField(
                    controller: _answerController,
                    autofocus: true,
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
              ),
              Positioned(
                bottom: 0,
                left: 35,
                right: 0,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (_isBackAlleyCorrectAnswer(_answerController.text)) {
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
                    child: Image.asset('assets/submit_button.png', height: 35),
                  ),
                ),
              ),
            ],
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
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: SizedBox(
          width: constraints.maxWidth * 0.68,
          height: constraints.maxHeight * 0.75,
          child: isTableVisible
              ? _buildTableView(constraints)
              : _buildQueryView(constraints),
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
            children: List.generate(_visibleHeaders.length, (index) {
              return Expanded(
                flex: _flexForHeader(_visibleHeaders[index]),
                child: Text(_visibleHeaders[index], style: headerStyle),
              );
            }),
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
              columnWidths: {
                for (int i = 0; i < _visibleHeaders.length; i++)
                  i: FlexColumnWidth(
                    _flexForHeader(_visibleHeaders[i]).toDouble(),
                  ),
              },
              children: _buildTableRowsList(),
            ),
          ),
        ),
      ],
    );
  }

  int _flexForHeader(String header) {
    switch (header) {
      case 'manifest_id':
        return 3;
      case 'company_owner':
        return 3;
      case 'vehicle_id':
        return 2;
      case 'driver_name':
        return 3;
      case 'scheduled_time':
        return 3;
      case 'location_tag':
        return 4;
      default:
        return 3;
    }
  }

  List<TableRow> _buildTableRowsList() {
    const cellStyle = TextStyle(
      fontFamily: 'Consolas',
      color: Colors.black,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    return List<TableRow>.generate(_filteredSecurityMaps.length, (index) {
      final row = _filteredSecurityMaps[index];

      return TableRow(
        decoration: BoxDecoration(
          color: index % 2 == 0
              ? const Color(0xFFFFF9C4).withOpacity(0.7)
              : const Color(0xFFF0E68C).withOpacity(0.5),
        ),
        children: _visibleHeaders.map((header) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              row[header] ?? '',
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
          child: Container(
            alignment: Alignment.topLeft,
            child: Scrollbar(
              controller: _sqlScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _sqlScrollController,
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight * 0.40,
                  ),
                  child: Stack(
                    children: [
                      RichText(
                        text: _buildSqlHighlightedText(
                          _sqlController.text.isEmpty
                              ? "ENTER SQL QUERY..."
                              : _sqlController.text,
                          isHint: _sqlController.text.isEmpty,
                        ),
                      ),
                      TextField(
                        controller: _sqlController,
                        autofocus: true,
                        maxLines: null,
                        minLines: 12,
                        scrollController: _sqlScrollController,
                        cursorColor: Colors.black,
                        style: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Consolas',
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
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
                onTap: () {
                  setState(() {
                    _filteredSecurityMaps = List.from(_allSecurityMaps);
                    _visibleHeaders = List.from(_headers);
                    isTableVisible = true;
                  });
                },
                child: Image.asset('assets/tables_button.png', height: 35),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _sqlController.clear();
                      });
                    },
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

  TextSpan _buildSqlHighlightedText(String text, {bool isHint = false}) {
    if (isHint) {
      return const TextSpan(
        text: "ENTER SQL QUERY...",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: 'Consolas',
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      );
    }

    final keywordStyle = const TextStyle(
      color: Color(0xFF7B1FA2),
      fontSize: 14,
      fontFamily: 'Consolas',
      fontWeight: FontWeight.bold,
      height: 1.5,
    );

    final columnStyle = const TextStyle(
      color: Color(0xFF1565C0),
      fontSize: 14,
      fontFamily: 'Consolas',
      fontWeight: FontWeight.bold,
      height: 1.5,
    );

    final stringStyle = const TextStyle(
      color: Color(0xFF2E7D32),
      fontSize: 14,
      fontFamily: 'Consolas',
      fontWeight: FontWeight.bold,
      height: 1.5,
    );

    final normalStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontFamily: 'Consolas',
      fontWeight: FontWeight.bold,
      height: 1.5,
    );

    final tokens = RegExp(r"('[^']*'|\w+|[=,*();<>!]+|\s+|.)")
        .allMatches(text)
        .map((m) {
          return m.group(0)!;
        })
        .toList();

    const keywords = {
      'SELECT',
      'FROM',
      'WHERE',
      'AND',
      'OR',
      'LIKE',
      'ORDER',
      'BY',
      'ASC',
      'DESC',
      'LIMIT',
    };

    final spans = <TextSpan>[];

    for (final token in tokens) {
      final upper = token.toUpperCase();

      if (token.startsWith("'") && token.endsWith("'")) {
        spans.add(TextSpan(text: token, style: stringStyle));
      } else if (keywords.contains(upper)) {
        spans.add(TextSpan(text: token, style: keywordStyle));
      } else if (_headers.contains(token.toLowerCase())) {
        spans.add(TextSpan(text: token, style: columnStyle));
      } else {
        spans.add(TextSpan(text: token, style: normalStyle));
      }
    }

    return TextSpan(children: spans);
  }

  Widget _buildOverlayIcon(String asset, double width, String description) {
    return GlowingClue(
      child: FloatingBubble(
        child: GestureDetector(
          onTap: () => setState(() => activeInvestigationText = description),
          child: Image.asset(asset, width: width, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _QueryResult {
  final List<Map<String, String>> rows;
  final List<String> columns;

  _QueryResult({required this.rows, required this.columns});
}

class InvestigationTypewriter extends StatefulWidget {
  final String text;
  final VoidCallback onFinished;

  const InvestigationTypewriter({
    super.key,
    required this.text,
    required this.onFinished,
  });

  @override
  State<InvestigationTypewriter> createState() =>
      _InvestigationTypewriterState();
}

class _InvestigationTypewriterState extends State<InvestigationTypewriter> {
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

class GlowingClue extends StatefulWidget {
  final Widget child;

  const GlowingClue({super.key, required this.child});

  @override
  State<GlowingClue> createState() => _GlowingClueState();
}

class _GlowingClueState extends State<GlowingClue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glow = Tween<double>(
      begin: 0.25,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  254,
                  255,
                  213,
                ).withOpacity(_glow.value * 0.40),
                blurRadius: 13 + (_glow.value * 5),
                spreadRadius: 1 + (_glow.value * 2),
              ),
              BoxShadow(
                color: const Color(0xFF6A008A).withOpacity(_glow.value * 0.15),
                blurRadius: 24 + (_glow.value * 10),
                spreadRadius: _glow.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class AnimatedPopup extends StatefulWidget {
  final Widget child;

  const AnimatedPopup({super.key, required this.child});

  @override
  State<AnimatedPopup> createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<AnimatedPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scale = Tween<double>(
      begin: 0.93,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}
