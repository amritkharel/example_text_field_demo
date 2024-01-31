import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:extended_text_field/extended_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> messages = ["Hello", "World"];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Extended Text Field Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return CustomMessage(message: messages[index]);
              },
            ),
          ),
          Expanded(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ExtendedTextField(
              controller: _controller,
              specialTextSpanBuilder: MySpecialTextSpanBuilder(), // Implement this to handle GIF or special inputs
              decoration: InputDecoration(
                hintText: "Type a message",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final inputText = _controller.text;
                    // Check if the inputText contains a GIF reference
                    if (inputText.contains(GifText.flag)) {
                      // Handle GIF
                      final gifId = inputText.substring(inputText.indexOf(GifText.flag) + GifText.flag.length, inputText.indexOf(']'));
                      print("Sending GIF with ID: $gifId");
                      // Here you would send the GIF based on its ID
                    } else {
                      // Handle regular text
                      print("Sending message: $inputText");
                      // Here you would send the message as text
                    }
                  },
                ),
              ),
            ),
          ),),
        ],
      ),
    );
  }
}

class CustomMessage extends StatelessWidget {
  final String message;

  const CustomMessage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    double maxScreenWidth = MediaQuery.of(context).size.width;
    double maxScreenHeight = MediaQuery.of(context).size.width;

    return Container(
      width: maxScreenWidth * 0.9,
      height: maxScreenHeight * 0.1,
      color: Colors.grey,
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(10.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ExtendedTextFieldImplementation extends StatefulWidget {
  const ExtendedTextFieldImplementation({super.key});

  @override
  State<ExtendedTextFieldImplementation> createState() => _ExtendedTextFieldImplementationState();
}

class _ExtendedTextFieldImplementationState extends State<ExtendedTextFieldImplementation> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class GifText extends SpecialText {
  final TextStyle? textStyle;
  // Keep the base class signature for onTap
  final void Function(dynamic)? onTap;

  GifText(this.textStyle, {this.onTap, required int start}) : super(GifText.flag, ']', textStyle);

  static const String flag = '[GIF:';

  @override
  InlineSpan finishText() {
    final String key = getContent();

    GestureRecognizer? recognizer = onTap != null ? (TapGestureRecognizer()..onTap = () => onTap!(null)) : null;

    return SpecialTextSpan(
      text: '', // Placeholder text, you could customize it
      actualText: key,
      style: textStyle?.copyWith(color: Colors.transparent),
      recognizer: recognizer,
      children: <InlineSpan>[
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            // Simulated GIF representation
            padding: EdgeInsets.all(2),
            child: Text('[GIF]', style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ),
      ],
    );
  }
}

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, void Function(dynamic)? onTap, required int index}) {
    if (flag.startsWith(GifText.flag)) {
      return GifText(textStyle, onTap: onTap, start: index);
    }
    return null;
  }
}


