class ClasificarTransaccionResponse {
  final String tipoFlujo;
  final double monto;
  final String descripcion;
  final String categoria;
  final String cualidad;

  ClasificarTransaccionResponse({
    required this.tipoFlujo,
    required this.monto,
    required this.descripcion,
    required this.categoria,
    required this.cualidad,
  });

  factory ClasificarTransaccionResponse.fromJson(Map<String, dynamic> json) {
    var prediccion = json['prediccion'] ?? {};
    return ClasificarTransaccionResponse(
      tipoFlujo: json['tipoFlujo'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      descripcion: json['descripcion'] ?? '',
      categoria: prediccion['categoria'] ?? 'OTRO',
      cualidad: prediccion['cualidad'] ?? 'VARIABLE',
    );
  }
}
