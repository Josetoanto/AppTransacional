import 'package:apptransaccional/features/hilos/domain/entities/hilo.dart';

class HiloModel {
  const HiloModel({
    required this.id,
    required this.usuarioId,
    required this.contenidoTexto,
    required this.fechaCreacion,
  });

  final String id;
  final String usuarioId;
  final String contenidoTexto;
  final DateTime fechaCreacion;

  factory HiloModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue =
        json['fechaCreacion'] ?? json['createdAt'] ?? DateTime.now().toIso8601String();

    return HiloModel(
      id: json['id']?.toString() ?? '',
      usuarioId: json['usuarioId']?.toString() ?? json['userId']?.toString() ?? '',
      contenidoTexto: (json['contenidoTexto'] ?? json['body'] ?? '').toString(),
      fechaCreacion: DateTime.tryParse(createdAtValue.toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': usuarioId,
      'body': contenidoTexto,
      'createdAt': fechaCreacion.toIso8601String(),
    };
  }

  Hilo toEntity() {
    return Hilo(
      id: id,
      usuarioId: usuarioId,
      contenidoTexto: contenidoTexto,
      fechaCreacion: fechaCreacion,
    );
  }

  factory HiloModel.fromEntity(Hilo hilo) {
    return HiloModel(
      id: hilo.id,
      usuarioId: hilo.usuarioId,
      contenidoTexto: hilo.contenidoTexto,
      fechaCreacion: hilo.fechaCreacion,
    );
  }
}
