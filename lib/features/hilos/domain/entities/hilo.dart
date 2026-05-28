class Hilo {
  const Hilo({
    required this.id,
    required this.usuarioId,
    required this.contenidoTexto,
    required this.fechaCreacion,
  });

  final String id;
  final String usuarioId;
  final String contenidoTexto;
  final DateTime fechaCreacion;

  Hilo copyWith({
    String? id,
    String? usuarioId,
    String? contenidoTexto,
    DateTime? fechaCreacion,
  }) {
    return Hilo(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      contenidoTexto: contenidoTexto ?? this.contenidoTexto,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
