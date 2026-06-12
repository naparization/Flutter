import 'dart:convert';

import 'package:crypto/crypto.dart';

class Utils {
  static String gerarMd5(String texto) {
    final bytes = utf8.encode(texto); // converte para bytes
    final digest = md5.convert(bytes); // gera o hash
    return digest.toString();
  }
}
