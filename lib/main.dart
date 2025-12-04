import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VantaBuddyPage(),
    );
  }
}

class VantaBuddyPage extends StatefulWidget {
  const VantaBuddyPage({super.key});

  @override
  State<VantaBuddyPage> createState() => _VantaBuddyPageState();
}

class _VantaBuddyPageState extends State<VantaBuddyPage> {
  StateMachineController? _stateMachineController;
  SMITrigger? _jumpingTrigger;
  SMITrigger? _floatingTrigger;
  SMITrigger? _floating2Trigger;
  SMITrigger? _turnRightTrigger;
  SMITrigger? _turnLeftTrigger;
  SMITrigger? _turnDownTrigger;
  SMITrigger? _turnUpTrigger;

  SMIBool? _updownBool;
  SMIBool? _rightleftBool;

  SMINumber? _fromUpToBottomNumber;
  SMINumber? _fromLeftToRightNumber;
  
  String _availableInputs = 'Loading...';

  void _onRiveInit(Artboard artboard) {
    try {
      final controller = StateMachineController.fromArtboard(artboard, 'vantabuddy');
      if (controller == null) {
        _availableInputs = 'No state machine "vantabuddy" found.';
        debugPrint(_availableInputs);
        setState(() {});
        return;
      }
      _stateMachineController = controller;
      artboard.addController(controller);

      // List all available inputs
      final inputsList = <String>[];
      try {
        for (final input in controller.inputs) {
          inputsList.add('${input.name} (${input.runtimeType})');
          debugPrint('Input found: name=${input.name}, type=${input.runtimeType}');
        }
      } catch (e) {
        debugPrint('Error listing inputs: $e');
      }
      _availableInputs = inputsList.isEmpty ? 'No inputs found.' : inputsList.join(', ');
      debugPrint('Available inputs: $_availableInputs');

      // Assign triggers by iterating the controller.inputs (safer across runtimes)
      for (final input in controller.inputs) {
        try {
          debugPrint('checking input: ${input.name} (${input.runtimeType})');
          if (input.name == 'jumping' && input is SMITrigger) {
            _jumpingTrigger = input as SMITrigger;
            debugPrint('assigned _jumpingTrigger');
          }
          if (input.name == 'floating' && input is SMITrigger) {
            _floatingTrigger = input as SMITrigger;
            debugPrint('assigned _floatingTrigger');
          }
          if (input.name == 'floating2' && input is SMITrigger) {
            _floating2Trigger = input as SMITrigger;
            debugPrint('assigned _floating2Trigger');
          }
          // other triggers
          if (input.name == 'turnright' && input is SMITrigger) {
            _turnRightTrigger = input;
            debugPrint('assigned _turnRightTrigger');
          }
          if (input.name == 'turnleft' && input is SMITrigger) {
            _turnLeftTrigger = input;
            debugPrint('assigned _turnLeftTrigger');
          }
          if (input.name == 'turndown' && input is SMITrigger) {
            _turnDownTrigger = input;
            debugPrint('assigned _turnDownTrigger');
          }
          if (input.name == 'turnup' && input is SMITrigger) {
            _turnUpTrigger = input;
            debugPrint('assigned _turnUpTrigger');
          }

          // bools
          if (input.name == 'updown' && input is SMIBool) {
            _updownBool = input;
            debugPrint('assigned _updownBool (value=${_updownBool!.value})');
          }
          if (input.name == 'rightleft' && input is SMIBool) {
            _rightleftBool = input;
            debugPrint('assigned _rightleftBool (value=${_rightleftBool!.value})');
          }

          // numbers
          if (input.name == 'fromuptobottom' && input is SMINumber) {
            _fromUpToBottomNumber = input;
            debugPrint('assigned _fromUpToBottomNumber (value=${_fromUpToBottomNumber!.value})');
          }
          if (input.name == 'fromlefttoright' && input is SMINumber) {
            _fromLeftToRightNumber = input;
            debugPrint('assigned _fromLeftToRightNumber (value=${_fromLeftToRightNumber!.value})');
          }
        } catch (e) {
          debugPrint('Error processing input ${input.name}: $e');
        }
      }

      debugPrint('State machine initialized.');
      setState(() {});
    } catch (e, st) {
      debugPrint('Exception in _onRiveInit: $e\n$st');
      _availableInputs = 'Exception: $e';
      setState(() {});
    }
  }

  void _showNotReady(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('State machine not ready yet')),
    );
  }

  void _handleJumpingPressed(BuildContext context) {
    debugPrint('jumping button pressed, _jumpingTrigger=$_jumpingTrigger');
    if (_jumpingTrigger != null) {
      debugPrint('firing jumping trigger');
      _jumpingTrigger!.fire();
      return;
    }
    _showNotReady(context);
  }

  void _handleFloatingPressed(BuildContext context) {
    debugPrint('floating button pressed, _floatingTrigger=$_floatingTrigger');
    if (_floatingTrigger != null) {
      debugPrint('firing floating trigger');
      _floatingTrigger!.fire();
      return;
    }
    _showNotReady(context);
  }

  void _handleFloating2Pressed(BuildContext context) {
    debugPrint('floating2 button pressed, _floating2Trigger=$_floating2Trigger');
    if (_floating2Trigger != null) {
      debugPrint('firing floating2 trigger');
      _floating2Trigger!.fire();
      return;
    }
    _showNotReady(context);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VantaBuddy')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RiveAnimation.asset(
                'assets/vantabuddy.riv',
                fit: BoxFit.contain,
                onInit: _onRiveInit,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Column(
              children: [
                // Primary triggers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleJumpingPressed(context),
                      child: const Text('Jumping'),
                    ),
                    ElevatedButton(
                      onPressed: () => _handleFloatingPressed(context),
                      child: const Text('Floating'),
                    ),
                    ElevatedButton(
                      onPressed: () => _handleFloating2Pressed(context),
                      child: const Text('Floating2'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Other triggers
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _turnLeftTrigger != null ? () { debugPrint('turnleft pressed'); _turnLeftTrigger!.fire(); } : null,
                      child: const Text('Turn Left'),
                    ),
                    ElevatedButton(
                      onPressed: _turnRightTrigger != null ? () { debugPrint('turnright pressed'); _turnRightTrigger!.fire(); } : null,
                      child: const Text('Turn Right'),
                    ),
                    ElevatedButton(
                      onPressed: _turnUpTrigger != null ? () { debugPrint('turnup pressed'); _turnUpTrigger!.fire(); } : null,
                      child: const Text('Turn Up'),
                    ),
                    ElevatedButton(
                      onPressed: _turnDownTrigger != null ? () { debugPrint('turndown pressed'); _turnDownTrigger!.fire(); } : null,
                      child: const Text('Turn Down'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bool toggles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updownBool != null ? () {
                        _updownBool!.value = !_updownBool!.value;
                        debugPrint('updown toggled -> ${_updownBool!.value}');
                        setState(() {});
                      } : null,
                      child: Text('UpDown: ${_updownBool?.value ?? 'n/a'}'),
                    ),
                    ElevatedButton(
                      onPressed: _rightleftBool != null ? () {
                        _rightleftBool!.value = !_rightleftBool!.value;
                        debugPrint('rightleft toggled -> ${_rightleftBool!.value}');
                        setState(() {});
                      } : null,
                      child: Text('RightLeft: ${_rightleftBool?.value ?? 'n/a'}'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Sliders for numeric inputs
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From Up To Bottom'),
                              Slider(
                                value: (_fromUpToBottomNumber?.value ?? 0.0).clamp(0.0, 100.0).toDouble(),
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                label: (_fromUpToBottomNumber?.value ?? 0.0).toStringAsFixed(0),
                                onChanged: _fromUpToBottomNumber != null ? (v) {
                                  _fromUpToBottomNumber!.value = v;
                                  setState(() {});
                                } : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 56,
                          child: Text(_fromUpToBottomNumber != null
                              ? _fromUpToBottomNumber!.value.toStringAsFixed(0)
                              : 'n/a',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('From Left To Right'),
                              Slider(
                                value: (_fromLeftToRightNumber?.value ?? 0.0).clamp(0.0, 100.0).toDouble(),
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                label: (_fromLeftToRightNumber?.value ?? 0.0).toStringAsFixed(0),
                                onChanged: _fromLeftToRightNumber != null ? (v) {
                                  _fromLeftToRightNumber!.value = v;
                                  setState(() {});
                                } : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 56,
                          child: Text(_fromLeftToRightNumber != null
                              ? _fromLeftToRightNumber!.value.toStringAsFixed(0)
                              : 'n/a',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                Text(
                  'Available: $_availableInputs',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
