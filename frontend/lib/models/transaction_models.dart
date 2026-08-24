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

class MetaResumen {
  final String idMeta;
  final String nombreMeta;
  final double montoObjetivo;
  final double montoActual;
  final String? fechaLimite;
  final String estado;

  MetaResumen({
    required this.idMeta,
    required this.nombreMeta,
    required this.montoObjetivo,
    required this.montoActual,
    this.fechaLimite,
    required this.estado,
  });

  factory MetaResumen.fromJson(Map<String, dynamic> json) {
    return MetaResumen(
      idMeta: json['id_meta'] ?? '',
      nombreMeta: json['nombre_meta'] ?? '',
      montoObjetivo: (json['monto_objetivo'] ?? 0).toDouble(),
      montoActual: (json['monto_actual'] ?? 0).toDouble(),
      fechaLimite: json['fecha_limite'],
      estado: json['estado'] ?? '',
    );
  }
}

class DashboardResponse {
  final UsuarioResumen usuario;
  final AnalisisResumen analisis;
  final List<MetaResumen> metasActivas;

  DashboardResponse({
    required this.usuario,
    required this.analisis,
    required this.metasActivas,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      usuario: UsuarioResumen.fromJson(json['usuario'] ?? {}),
      analisis: AnalisisResumen.fromJson(json['analisis'] ?? {}),
      metasActivas: (json['metas_activas'] as List?)
              ?.map((e) => MetaResumen.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class UsuarioResumen {
  final String nombre;
  final String apellido;
  final String correo;

  UsuarioResumen({required this.nombre, required this.apellido, required this.correo});

  factory UsuarioResumen.fromJson(Map<String, dynamic> json) {
    return UsuarioResumen(
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}

class RecomendacionResumen {
  final String tipo;
  final String prioridad;
  final String mensaje;

  RecomendacionResumen({
    required this.tipo,
    required this.prioridad,
    required this.mensaje,
  });

  factory RecomendacionResumen.fromJson(Map<String, dynamic> json) {
    return RecomendacionResumen(
      tipo: json['tipo'] ?? '',
      prioridad: json['prioridad'] ?? '',
      mensaje: json['mensaje'] ?? '',
    );
  }
}

class AnalisisResumen {
  final double dineroDisponible;
  final double ingresoMensual;
  final double nivelEndeudamiento;
  final String perfilFinanciero;
  final List<TransaccionResumen> transaccionesDelMes;
  final List<RecomendacionResumen> recomendaciones;

  AnalisisResumen({
    required this.dineroDisponible,
    required this.ingresoMensual,
    required this.nivelEndeudamiento,
    required this.perfilFinanciero,
    required this.transaccionesDelMes,
    required this.recomendaciones,
  });

  factory AnalisisResumen.fromJson(Map<String, dynamic> json) {
    var transacciones = json['transacciones_del_mes'] as List? ?? [];
    var recs = json['recomendaciones'] as List? ?? [];
    return AnalisisResumen(
      dineroDisponible: (json['dinero_disponible'] ?? 0).toDouble(),
      ingresoMensual: (json['ingreso_mensual'] ?? 0).toDouble(),
      nivelEndeudamiento: (json['nivel_endeudamiento'] ?? 0).toDouble(),
      perfilFinanciero: json['perfil_financiero'] ?? '',
      transaccionesDelMes: transacciones.map((t) => TransaccionResumen.fromJson(t)).toList(),
      recomendaciones: recs.map((r) => RecomendacionResumen.fromJson(r)).toList(),
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
