import 'package:flutter/material.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:crypto_keys/crypto_keys.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
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
  var keyPair = new KeyPair(
      publicKey: RsaPublicKey(
          modulus: BigInt.parse(
              '9a3672d55a13d66a29d561ca8dbb640f9ce4a367a4675c6164fc50908fe2fad8101dbfb31f7fbffaf5064d7c5900c6600017b43fdbfdcd645d4b98912239d85ad93941dc2c701de1e998aba54913eff007b9c786329a2d4d92f2a3bb78ce74460bd679ec266cce07af5c1150836df154f0c30a0c4a82d2982878b37217c54ad456a3b8b58316bae5c33a8cc08e48fc9f4ee7d2fb2511144ea5f4507539bb9ea0385717de5d56adeaa3b0b9564397cd02f8a7ac02148118a567e3d44f4aaa526dd46f0d0e41234549f6bd30aea01c2a8c2e5a4aa8dcfda8bd504ed81a1653afe954e0121baaa69b922c8c261787f2b443a13d45770dd105505786f16b61740cff',
              radix: 16),
          exponent: BigInt.parse('0x10001')),
      privateKey: null);
  @override
  void initState() {
    super.initState();
    var encrypter =
        keyPair.publicKey?.createEncrypter(algorithms.encryption.aes.gcm);

    // Encrypt the content with an additional authentication data for integrity
    // protection
    var content = "2018H1109";
    var aad = "It is me";
    var v = encrypter?.encrypt(new Uint8List.fromList(content.codeUnits));

    print("Encrypting '$content'");
    print("Ciphertext: ${v?.data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tutorial Spot - JS / Flutter"),
        ),
        body: Center(
          child: Text("asd"),
        ));
  }
}

// addFromjs(
//     JavascriptRuntime jsRutime, int fisrstNumber, int secondNumber) async {
//   String blocJS = await rootBundle.loadString("assets/jscode/bloc.js");
  
// }
