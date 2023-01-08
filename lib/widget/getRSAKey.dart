import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pointycastle/asymmetric/api.dart';

class GetRSAkey extends StatefulWidget {
  const GetRSAkey({super.key});

  @override
  State<GetRSAkey> createState() => _GetRSAkeyState();
}

class _GetRSAkeyState extends State<GetRSAkey> {
  JavascriptRuntime runtime = getJavascriptRuntime();
  int counter = 0;
  dynamic path = rootBundle.loadString("assets/jscode/bloc.js");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color c = Theme.of(context).primaryColor;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tutorial Spot - JS / Flutter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                counter.toString(),
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final result = await additionFn(runtime, counter, 1);

                    setState(() {
                      counter = result as int;
                    });
                  },
                  child: Text("Add")),
              ElevatedButton(
                  onPressed: () async {
                    final result = await substractionFn(runtime, counter, 1);

                    setState(() {
                      counter = result as int;
                    });
                  },
                  child: Text("Sub")),
              ElevatedButton(
                  onPressed: () async {
                    final result = await multiplicationFn(runtime, counter, 2);

                    setState(() {
                      counter = result as int;
                    });
                  },
                  child: Text("Mul")),
              ElevatedButton(
                  onPressed: () async {
                    final result = await divisionFn(runtime, counter, 3);

                    setState(() {
                      counter = result as int;
                    });
                  },
                  child: Text("Div")),
            ],
          ),
        ));
  }

  dynamic additionFn(JavascriptRuntime runtime, int v1, int v2) async {
    final jsFile = await path;

    JsEvalResult jsEvalResult =
        runtime.evaluate("""${jsFile}addition($v1, $v2)""");

    return int.parse(jsEvalResult.stringResult);
  }

  dynamic substractionFn(JavascriptRuntime runtime, int v1, int v2) async {
    final jsFile = await path;

    JsEvalResult jsEvalResult =
        runtime.evaluate("""${jsFile}subtraction($v1, $v2)""");

    return int.parse(jsEvalResult.stringResult);
  }

  dynamic multiplicationFn(JavascriptRuntime runtime, int v1, int v2) async {
    final jsFile = await path;

    JsEvalResult jsEvalResult =
        runtime.evaluate("""${jsFile}multiplication($v1, $v2)""");
    print(jsEvalResult);
    return int.parse(jsEvalResult.stringResult);
  }

  dynamic divisionFn(JavascriptRuntime runtime, int v1, int v2) async {
    final jsFile = await path;

    JsEvalResult jsEvalResult =
        runtime.evaluate("""${jsFile}division($v1, $v2)""");

    return int.parse(jsEvalResult.stringResult);
  }
}

// addFromjs(
//     JavascriptRuntime jsRutime, int fisrstNumber, int secondNumber) async {
//   String blocJS = await rootBundle.loadString("assets/jscode/bloc.js");
  
// }
