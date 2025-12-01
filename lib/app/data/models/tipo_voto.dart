enum TipoVoto { UP, DOWN }

extension TipoVotoExt on TipoVoto {
  String toJson() => name;
  static TipoVoto? fromJson(dynamic v) {
    if (v == null) return null;
    final s = v.toString().toUpperCase();
    if (s == 'UP') return TipoVoto.UP;
    if (s == 'DOWN') return TipoVoto.DOWN;
    return null;
  }
}