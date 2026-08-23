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

class DashboardResponse {
  final UsuarioResumen usuario;
  final AnalisisResumen analisis;
  final List<dynamic> metasActivas; // Puedes crear un modelo para MetaResumen luego

  DashboardResponse({
    required this.usuario,
    required this.analisis,
    required this.metasActivas,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      usuario: UsuarioResumen.fromJson(json['usuario'] ?? {}),
      analisis: AnalisisResumen.fromJson(json['analisis'] ?? {}),
      metasActivas: json['metasActivas'] ?? [],
    );
  }
}

class UsuarioResumen {
  final String nombre;
  final String correo;

  UsuarioResumen({required this.nombre, required this.correo});

  factory UsuarioResumen.fromJson(Map<String, dynamic> json) {
    return UsuarioResumen(
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}

class AnalisisResumen {
  final double dineroDisponible;
  final double ingresoMensual;
  final String perfilFinanciero;
  final List<TransaccionResumen> transaccionesDelMes;

  AnalisisResumen({
    required this.dineroDisponible,
    required this.ingresoMensual,
    required this.perfilFinanciero,
    required this.transaccionesDelMes,
  });

  factory AnalisisResumen.fromJson(Map<String, dynamic> json) {
    var transacciones = json['transacciones_del_mes'] as List? ?? [];
    return AnalisisResumen(
      dineroDisponible: (json['dinero_disponible'] ?? 0).toDouble(),
      ingresoMensual: (json['ingreso_mensual'] ?? 0).toDouble(),
      perfilFinanciero: json['perfil_financiero'] ?? '',
      transaccionesDelMes: transacciones.map((t) => TransaccionResumen.fromJson(t)).toList(),
    );
  }
}

class TransaccionResumen {
  final String descripcion;
  final double monto;
  final String tipoFlujo;
  final String categoria;
  final String fecha;

  TransaccionResumen({
    required this.descripcion,
    required this.monto,
    required this.tipoFlujo,
    required this.categoria,
    required this.fecha,
  });

  factory TransaccionResumen.fromJson(Map<String, dynamic> json) {
    return TransaccionResumen(
      descripcion: json['descripcion'] ?? '',
      monto: (json['monto'] ?? 0).toDouble(),
      tipoFlujo: json['tipo_flujo'] ?? '',
      categoria: json['categoria'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}
