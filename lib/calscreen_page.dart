import 'package:flutter/material.dart';
import 'package:practice_cal/button_values.dart';

class CalscreenPage extends StatefulWidget {
  const CalscreenPage({super.key});

  @override
  State<CalscreenPage> createState() => _CalscreenPageState();
}

class _CalscreenPageState extends State<CalscreenPage> {
  // number1=this is the first digit off number//
  String number1 = '';
  // operand=this is the operator(+,-,/,*) item//
  String operand = '';
  // number2=this is the last digit off number//
  String number2 = '';
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            // output '0'/result//
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '$number1$operand$number2'.isEmpty
                          ? '0'
                          : '$number1$operand$number2',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),

              // All buttton Section 0-9 && operand//
              Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: value == Btn.calculate
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.height / 9,
                        child: buildButton(value),
                      ),
                    )
                    .toList(),
              )
            ],
          )),
    );
  }

// design button section//
  Widget buildButton(value) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Material(
        color: [Btn.del, Btn.clr].contains(value)
            ? const Color.fromARGB(255, 247, 108, 231)
            : [Btn.per, Btn.multiply, Btn.divide, Btn.subtract, Btn.add]
                    .contains(value)
                ? const Color.fromARGB(255, 0, 255, 217)
                : Color.fromARGB(255, 97, 179, 220),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: value == Btn.subtract ? 35 : 24,
                  fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }

  // this is the ontap button function //
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }
// this is the clear function
    if (value == Btn.clr) {
      clear();
      return;
    }
// //////////
// this is the percentage
    if (value == Btn.per) {
      percentage();
      return;
    }
// /////////
    if (value == Btn.calculate) {
      calculate();
      return;
    }
// this is the ontap button//
    ontap(value);
  }

// this is the calculate function //
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          setState(() {
            number1 = 'Error';
            operand = '';
            number2 = '';
          });
          return;
        }
        break;
      default:
        return;
    }

    // Update the result to number1
    setState(() {
      number1 = result.toString();
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

// this is percent% section//

  void percentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = '${(number / 100)}';
      operand = '';
      number2 = '';
    });
  }

// this is the clear section //
  void clear() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

// create delete button function//
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  void ontap(String value) {
    // number1  operand  number2//
//     10       +        20//
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {}
      operand = value;
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        value = '0.';
      }
      number2 += value;
    }
    setState(() {});
  }
}
