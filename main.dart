import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const KaryaTrackApp());
}

class KaryaTrackApp extends StatelessWidget {
  const KaryaTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaryaTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate Dark Background
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF59E0B), // Amber Accent
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Gang State
  String selectedGang = 'Verma Mistry Gang';
  int mistryCount = 2;
  int helperCount = 4;

  // Rate Cards
  double mistryDailyRate = 800.0;
  double helperDailyRate = 500.0;

  // Work & Measurement State
  String selectedWorkType = 'Brickwork';
  String selectedUnit = 'Sq.Ft (Square Feet)';
  double workQuantity = 400.0;
  double ratePerUnit = 18.0;

  // All Civil Engineering Measurement Units
  final List<String> measurementUnits = [
    'Sq.Ft (Square Feet)',
    'Sq.M (Square Meter)',
    'Brass (100 Sq.Ft / Cu.Ft)',
    'Cu.Ft (Cubic Feet)',
    'Cu.M (Cubic Meter)',
    'R.Ft (Running Feet)',
    'Bags (Cement)',
    'Tonne (Steel/Bar)',
    'Nos / Pieces',
  ];

  final List<String> workTypes = [
    'Brickwork',
    'Plastering',
    'RCC Concrete Work',
    'Slab Shuttering',
    'Tiles / Flooring',
    'Rebar / Steel Bending',
    'Painting & Putty',
    'Excavation / Earthwork',
  ];

  // Voice State
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceText = "Tap mic to record site notes in Hindi/English...";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  double get totalLaborCost => (mistryCount * mistryDailyRate) + (helperCount * helperDailyRate);
  double get totalWorkValue => workQuantity * ratePerUnit;
  double get netDailyMargin => totalWorkValue - totalLaborCost;

  void _listenVoice() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _voiceText = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E293B),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.engineering, color: Colors.black, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'KaryaTrack',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 0.8, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Color(0xFFF59E0B)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF1E293B),
                  content: Text('📸 Photo Stamped! Date: $currentDate | GPS: 23.25° N, 77.41° E',
                      style: const TextStyle(color: Color(0xFFF59E0B))),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. LOCATION & TIMESTAMP HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_sharp, color: Color(0xFFF59E0B), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Site: Project Phase-1 | $currentDate',
                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. GANG ATTENDANCE & HEADCOUNT TWEAK
            const Text("GANG ATTENDANCE & TWEAK",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFFF59E0B))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: selectedGang,
                    decoration: InputDecoration(
                      labelText: 'Select Sub-contractor Gang',
                      labelStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    items: ['Verma Mistry Gang', 'Ramesh Tile Team', 'Sharma Shuttering Team', 'Gupta Painting Gang']
                        .map((gang) => DropdownMenuItem(value: gang, child: Text(gang, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (val) => setState(() => selectedGang = val!),
                  ),
                  const SizedBox(height: 16),

                  // Mistry Counter
                  _buildCounterRow("Mistry", mistryCount, mistryDailyRate, (val) => setState(() => mistryCount = val)),
                  const Divider(color: Colors.white10, height: 24),
                  // Helper Counter
                  _buildCounterRow("Helper", helperCount, helperDailyRate, (val) => setState(() => helperCount = val)),

                  const Divider(color: Colors.white10, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Today's Labor Dues:", style: TextStyle(color: Colors.white70)),
                      Text("₹${totalLaborCost.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444), fontSize: 18)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. WORK DONE & CIVIL MEASUREMENT LOG
            const Text("WORK & MEASUREMENT LOG",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Color(0xFFF59E0B))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  // Work Type Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: selectedWorkType,
                    decoration: InputDecoration(
                      labelText: 'Work Type',
                      labelStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    items: workTypes
                        .map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (val) => setState(() => selectedWorkType = val!),
                  ),
                  const SizedBox(height: 12),

                  // Measurement Unit Dropdown
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1E293B),
                    value: selectedUnit,
                    decoration: InputDecoration(
                      labelText: 'Measurement Unit',
                      labelStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    items: measurementUnits
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit, style: const TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (val) => setState(() => selectedUnit = val!),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: '$workQuantity',
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Work Quantity',
                            labelStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                          onChanged: (val) => setState(() => workQuantity = double.tryParse(val) ?? 0.0),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: '$ratePerUnit',
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Rate (₹ / Unit)',
                            labelStyle: const TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: const Color(0xFF0F172A),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                          onChanged: (val) => setState(() => ratePerUnit = double.tryParse(val) ?? 0.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Work Output Value:", style: TextStyle(color: Colors.white70)),
                      Text("₹${totalWorkValue.toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 18)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. VOICE NOTE INPUT CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isListening ? const Color(0xFFF59E0B) : Colors.white10),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _listenVoice,
                    child: CircleAvatar(
                      backgroundColor: _isListening ? const Color(0xFFF59E0B) : const Color(0xFF0F172A),
                      child: Icon(_isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? Colors.black : const Color(0xFFF59E0B)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_voiceText, style: TextStyle(color: Colors.white.withOpacity(0.7), fontStyle: FontStyle.italic, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. MARGIN / PROFIT SUMMARY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: netDailyMargin >= 0
                      ? [const Color(0xFF064E3B), const Color(0xFF022C22)]
                      : [const Color(0xFF7F1D1D), const Color(0xFF450A0A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: netDailyMargin >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444), width: 1.5),
              ),
              child: Column(
                children: [
                  const Text("DAILY NET MARGIN SUMMARY",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Output Value Generated:", style: TextStyle(color: Colors.white)),
                      Text("₹${totalWorkValue.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Labor Cost Spent:", style: TextStyle(color: Colors.white)),
                      Text("- ₹${totalLaborCost.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Net Site Profit / Margin:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text("₹${netDailyMargin.toStringAsFixed(0)}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: netDailyMargin >= 0 ? const Color(0xFF34D399) : const Color(0xFFF87171))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SAVE / SHARE BUTTON
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFF10B981),
                      content: Text('✅ Report Saved & Shared to Contractor WhatsApp!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.black),
                    SizedBox(width: 8),
                    Text('SAVE & GENERATE WHATSAPP PDF',
                        style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Counter Widget Builder
  Widget _buildCounterRow(String label, int count, double rate, Function(int) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            Text('₹${rate.toStringAsFixed(0)} / day', style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () { if (count > 0) onChange(count - 1); },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.remove, color: Color(0xFFEF4444), size: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            InkWell(
              onTap: () => onChange(count + 1),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add, color: Color(0xFF10B981), size: 20),
              ),
            ),
          ],
        )
      ],
    );``
  }
}