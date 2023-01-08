import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter/services.dart' show rootBundle;

class GetRSAkey extends StatefulWidget {
  const GetRSAkey({super.key});

  @override
  State<GetRSAkey> createState() => _GetRSAkeyState();
}

class _GetRSAkeyState extends State<GetRSAkey> {
  @override
  void initState() {
    super.initState();
  }

  getKey() async {
    // String credentials =
    //     "9a3672d55a13d66a29d561ca8dbb640f9ce4a367a4675c6164fc50908fe2fad8101dbfb31f7fbffaf5064d7c5900c6600017b43fdbfdcd645d4b98912239d85ad93941dc2c701de1e998aba54913eff007b9c786329a2d4d92f2a3bb78ce74460bd679ec266cce07af5c1150836df154f0c30a0c4a82d2982878b37217c54ad456a3b8b58316bae5c33a8cc08e48fc9f4ee7d2fb2511144ea5f4507539bb9ea0385717de5d56adeaa3b0b9564397cd02f8a7ac02148118a567e3d44f4aaa526dd46f0d0e41234549f6bd30aea01c2a8c2e5a4aa8dcfda8bd504ed81a1653afe954e0121baaa69b922c8c261787f2b443a13d45770dd105505786f16b61740cff";
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    // String encoded =
    //     stringToBase64.encode(credentials); // dXNlcm5hbWU6cGFzc3dvcmQ=
    // String decoded = stringToBase64.decode(encoded);
    // print(encoded);
    // print(decoded);
    final publicPem = await rootBundle.loadString('assets/keys/public.pem');
    final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;

    final privKeyPem = await rootBundle.loadString('assets/keys/private.pem');
    final privKey = RSAKeyParser().parse(privKeyPem) as RSAPrivateKey;

    final plainText = '2018H1109';
    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

    final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(encrypted);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base64); //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: getKey(),
            builder: (context, snapshot) {
              return Text("asd");
            }),
      ),
    );
  }
}
