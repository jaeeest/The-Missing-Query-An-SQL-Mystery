import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'exhibition_hall_screen.dart';
import 'viore_hq_screen.dart';
import 'back_alley_screen.dart';
import 'pearl_district.dart';
import 'the_loupe_screen.dart';
import 'police_station_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const CaseSelectionApp());
}

class CaseSelectionApp extends StatelessWidget {
  const CaseSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Luckiest Guy'),
      // --- NAMED ROUTES DEFINED HERE ---
      initialRoute: '/',
      routes: {
        '/': (context) => const CaseSelectionScreen(),
        '/exhibition_hall': (context) => const ExhibitionHallScreen(),
        '/viore_hq': (context) => const VioreHqScreen(),
        '/back_alley': (context) => const BackAlleyScreen(),
        '/insurance': (context) => const PearlDistrictScreen(),
        '/the_loupe': (context) => const LoupeScreen(),
        '/police_station': (context) => const PoliceStationScreen(),
      },
    );
  }
}

// --- ANIMATION WIDGET: FLOATING MOVEMENT ---
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
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.offset * _controller.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// --- TYPEWRITER WIDGET ---
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration speed;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.center,
    this.speed = const Duration(milliseconds: 30),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _displayedText = "";
    int index = 0;

    _timer = Timer.periodic(widget.speed, (timer) {
      if (index < widget.text.length) {
        setState(() {
          _displayedText += widget.text[index];
          index++;
        });
      } else {
        _timer?.cancel();
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
    return Text(
      _displayedText,
      textAlign: widget.textAlign,
      style: widget.style,
    );
  }
}

// --- SCREEN 1: CASE SELECTION ---
class CaseSelectionScreen extends StatelessWidget {
  const CaseSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF330066), Color(0xFF6A008A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => debugPrint("Back pressed"),
                      child: Image.asset('assets/back_button.png', height: 40),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Image.asset(
                        'assets/select_case.png',
                        height: 62,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Standard push since this screen isn't in our global 'routes' map yet
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CaseDescriptionScreen(),
                            ),
                          );
                        },
                        child: const CaseFolder(
                          caseTitle: "CASE FILE 01:\nTHE PEARL ROBBERY",
                          isLocked: false,
                        ),
                      ),
                      const CaseFolder(
                        caseTitle: "CASE FILE 02:\n???",
                        isLocked: true,
                      ),
                      const CaseFolder(
                        caseTitle: "CASE FILE 03:\n???",
                        isLocked: true,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 2: CASE DESCRIPTION & INVESTIGATION MAP ---
class CaseDescriptionScreen extends StatefulWidget {
  const CaseDescriptionScreen({super.key});

  @override
  State<CaseDescriptionScreen> createState() => _CaseDescriptionScreenState();
}

class _CaseDescriptionScreenState extends State<CaseDescriptionScreen> {
  int _currentPage = 0;
  bool _isBoardVisible = false;
  bool _isProfileVisible = false;
  bool _isMapVisible = false;
  int _profilePageNumber = 1;

  final List<String> _descriptions = [
    "The moonlight reflects off the marble floors of the Giovanni Grand Gallery. Tomorrow, the \"Orient Seas\" collection is supposed to save a 100-year-old dynasty from the brink of bankruptcy...",
    "As the lead digital investigator, you've been hired to solve the crime. Your job is to trace the digital footprints, cross-reference the suspects, and recover the Pearl.",
  ];

  void _handleNext() {
    setState(() {
      if (_currentPage < _descriptions.length - 1) {
        _currentPage++;
      } else if (!_isBoardVisible) {
        _isBoardVisible = true;
      } else if (!_isProfileVisible) {
        _isProfileVisible = true;
        _profilePageNumber = 1;
      } else if (_profilePageNumber < 3) {
        _profilePageNumber++;
      } else {
        _isMapVisible = true;
        _isProfileVisible = false;
      }
    });
  }

  void _handleBack() {
    setState(() {
      if (_isMapVisible) {
        _isMapVisible = false;
        _isProfileVisible = true;
        _profilePageNumber = 3;
      } else if (_isProfileVisible) {
        if (_profilePageNumber > 1) {
          _profilePageNumber--;
        } else {
          _isProfileVisible = false;
          _isBoardVisible = true;
        }
      } else if (_isBoardVisible) {
        _isBoardVisible = false;
      } else if (_currentPage > 0) {
        _currentPage--;
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF330066), Color(0xFF6A008A)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 1. FULL SCREEN MAP
                if (_isMapVisible) ...[
                  Positioned.fill(
                    child: Image.asset('assets/map1.png', fit: BoxFit.fill),
                  ),

                  // INTERACTIVE LABEL BUBBLES
                  Positioned(
                    top: constraints.maxHeight * 0.21,
                    left: constraints.maxWidth * 0.21,
                    child: _buildMapLabel(
                      'assets/exhibition_hall.png',
                      120,
                      context,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.30,
                    left: constraints.maxWidth * 0.48,
                    child: _buildMapLabel('assets/viore_hq.png', 115, context),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.20,
                    left: constraints.maxWidth * 0.65,
                    child: _buildMapLabel(
                      'assets/back_alley.png',
                      100,
                      context,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.60,
                    left: constraints.maxWidth * 0.18,
                    child: _buildMapLabel('assets/municipal.png', 115, context),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.80,
                    left: constraints.maxWidth * 0.39,
                    child: _buildMapLabel('assets/the_loupe.png', 95, context),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.46,
                    left: constraints.maxWidth * 0.69,
                    child: _buildMapLabel('assets/insurance.png', 115, context),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.75,
                    left: constraints.maxWidth * 0.74,
                    child: _buildMapLabel(
                      'assets/police_station.png',
                      110,
                      context,
                    ),
                  ),
                ],

                // 2. UI HEADER LAYER
                SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 20,
                        right: 20,
                        child: SizedBox(
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 0,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: _handleBack,
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
                                  ],
                                ),
                              ),
                              if (!_isMapVisible)
                                Image.asset('assets/pearl.png', height: 50),
                              if (_isMapVisible)
                                Positioned(
                                  right: 10,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/notebook.png',
                                        height: 50,
                                      ),
                                      const SizedBox(width: 10),
                                      _buildHUDItem('assets/lives.png', 'FULL'),
                                      const SizedBox(width: 10),
                                      _buildHUDItem(
                                        'assets/points.png',
                                        '1000 POINTS',
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      if (_isProfileVisible && !_isMapVisible)
                        _buildProfileView(screenWidth, screenHeight)
                      else if (!_isProfileVisible && !_isMapVisible)
                        _buildDescriptionView(screenWidth, screenHeight),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

Widget _buildMapLabel(String asset, double width, BuildContext context) {
    return FloatingBubble(
      child: GestureDetector(
        onTap: () {
          if (asset.contains('exhibition_hall')) {
            Navigator.pushNamed(context, '/exhibition_hall');
          } else if (asset.contains('viore_hq')) {
            Navigator.pushNamed(context, '/viore_hq');
          } else if (asset.contains('back_alley')) {
            Navigator.pushNamed(context, '/back_alley');
          } else if (asset.contains('insurance')) {
            Navigator.pushNamed(context, '/insurance');
          } else if (asset.contains('the_loupe')) {
            Navigator.pushNamed(context, '/the_loupe');
          } else if (asset.contains('police_station')) {
            Navigator.pushNamed(context, '/police_station');
          } else {
            debugPrint("Location tapped: $asset");
          }
        },
        child: Image.asset(
          asset,
          width: width,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  Widget _buildHUDItem(String asset, String label) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(asset, height: 50),
        Positioned(
          right: 25,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4A2C15),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileView(double width, double height) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: width * 0.90,
        height: height * 0.75,
        margin: const EdgeInsets.only(top: 50),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/character_profile$_profilePageNumber.png',
              fit: BoxFit.contain,
            ),
            Positioned(
              right: 75,
              bottom: 2,
              child: InkWell(
                onTap: _handleNext,
                child: Image.asset('assets/next_button.png', height: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionView(double width, double height) {
    return Center(
      child: Container(
        width: width * 0.80,
        height: height * 0.75,
        margin: const EdgeInsets.only(top: 80, bottom: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset('assets/orangebg.png', fit: BoxFit.fill),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.90,
                heightFactor: 0.82,
                child: Image.asset(
                  'assets/rectangle_text.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.72,
                heightFactor: 0.70,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isBoardVisible)
                      Positioned(
                        top: height * 0.06,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            const Text(
                              "CASE DESCRIPTION:",
                              style: TextStyle(
                                color: Color(0xFF4A2C15),
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            TypewriterText(
                              key: ValueKey(_currentPage),
                              text: _descriptions[_currentPage],
                              style: const TextStyle(
                                fontFamily: 'Londrina Solid',
                                color: Color(0xFFB71C1C),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Positioned.fill(
                        child: Image.asset(
                          'assets/case_board.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    Positioned(
                      right: -10,
                      bottom: 0,
                      child: InkWell(
                        onTap: _handleNext,
                        child: Image.asset(
                          'assets/next_button.png',
                          height: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaseFolder extends StatelessWidget {
  final String caseTitle;
  final bool isLocked;
  const CaseFolder({
    super.key,
    required this.caseTitle,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/folder.png',
                  fit: BoxFit.contain,
                  color: isLocked ? Colors.black.withOpacity(0.45) : null,
                  colorBlendMode: isLocked ? BlendMode.srcOver : null,
                ),
                if (isLocked)
                  FractionallySizedBox(
                    heightFactor: 0.68,
                    child: Image.asset('assets/question.png'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF7A4B28), width: 3.5),
            ),
            child: Text(
              caseTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF4A2C15), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
