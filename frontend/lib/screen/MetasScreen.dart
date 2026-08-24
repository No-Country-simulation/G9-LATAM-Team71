import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

import 'package:wallet_flutter/models/transaction_models.dart';
import 'package:wallet_flutter/services/api_service.dart';

class MetasScreen extends StatefulWidget {
  const MetasScreen({super.key});

  @override
  State<MetasScreen> createState() => _MetasScreenState();
}

class _MetasScreenState extends State<MetasScreen> {
  late Future<DashboardResponse?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _dashboardFuture = ApiService.getDashboardData();
  }

  void _mostrarDialogoAportar(String metaId, String nombreMeta) {
    final _montoController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Aportar a $nombreMeta"),
        content: TextField(
          controller: _montoController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: "Monto a aportar",
            prefixText: "\$",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => finish(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
            onPressed: () async {
              if (_montoController.text.isEmpty) return;
              double monto = double.tryParse(_montoController.text) ?? 0;
              if (monto <= 0) {
                toast("El monto debe ser mayor a cero");
                return;
              }
              finish(ctx);
              toast("Procesando aporte...");
              String? res = await ApiService.aportarAMeta(idMeta: metaId, monto: monto);
              
              if (res != null && !res.startsWith("Error")) {
                if (res.toLowerCase().contains("felicidades") || res.toLowerCase().contains("completado")) {
                  showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.orange, size: 32),
                          SizedBox(width: 8),
                          Text("¡Felicitaciones!"),
                        ],
                      ),
                      content: Text(res, style: const TextStyle(fontSize: 16)),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
                          onPressed: () => finish(c),
                          child: const Text("¡Genial!", style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                  );
                } else {
                  toast(res);
                }
                setState(() => _fetchData());
              } else {
                toast(res ?? "Error desconocido");
              }
            },
            child: const Text("Aportar", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _mostrarDialogoNuevaMeta() {
    final _nombreController = TextEditingController();
    final _montoController = TextEditingController();
    DateTime? _fechaLimite;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Nueva Meta"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: "Nombre de la Meta"),
                  ),
                  16.height,
                  TextField(
                    controller: _montoController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: "Monto Objetivo (\$)"),
                  ),
                  16.height,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_fechaLimite == null ? "Seleccionar Fecha Límite" : _fechaLimite!.toIso8601String().split('T').first),
                    trailing: const Icon(Icons.calendar_today, color: WAPrimaryColor),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          _fechaLimite = picked;
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => finish(ctx),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: WAPrimaryColor),
                onPressed: () async {
                  if (_nombreController.text.isEmpty || _montoController.text.isEmpty || _fechaLimite == null) {
                    toast("Por favor completa todos los campos");
                    return;
                  }
                  double monto = double.tryParse(_montoController.text) ?? 0;
                  if (monto <= 0) {
                    toast("Monto inválido");
                    return;
                  }
                  
                  finish(ctx);
                  toast("Creando meta...");
                  
                  // Backend expects exact ISO string sometimes, but usually just standard format
                  String fechaStr = "${_fechaLimite!.toIso8601String().split('.').first}Z";
                  
                  bool success = await ApiService.registrarMeta(
                    nombre: _nombreController.text,
                    montoObjetivo: monto,
                    fechaLimite: fechaStr,
                  );
                  
                  if (success) {
                    toast("Meta creada exitosamente");
                    setState(() => _fetchData());
                  } else {
                    toast("Error al crear la meta");
                  }
                },
                child: const Text("Crear", style: TextStyle(color: Colors.white)),
              )
            ],
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Metas Financieras",
      floatingActionButton: FloatingActionButton(
        backgroundColor: WAPrimaryColor,
        onPressed: _mostrarDialogoNuevaMeta,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<DashboardResponse?>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: WAPrimaryColor));
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Error al cargar las metas"),
                    8.height,
                    ElevatedButton(
                      onPressed: () => setState(() => _fetchData()),
                      child: const Text("Reintentar"),
                    )
                  ],
                ),
              );
            }

            final metas = snapshot.data!.metasActivas;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() => _fetchData());
                await _dashboardFuture;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tus Objetivos", style: boldTextStyle(size: 20)),
                    Text("Seguimiento de ahorro y metas", style: secondaryTextStyle()),
                    24.height,
                    
                    if (metas.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text("No tienes metas activas actualmente."),
                        ),
                      )
                    else
                      ...metas.map((m) {
                        double progress = 0;
                        if (m.montoObjetivo > 0) {
                          progress = m.montoActual / m.montoObjetivo;
                        }
                        
                        String detail = "Ahorrado: \$${m.montoActual.toStringAsFixed(2)}";
                        String description = m.fechaLimite != null 
                          ? "Meta para el ${m.fechaLimite?.split('T').first}" 
                          : "Meta activa.";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildMetaItem(
                            m.idMeta,
                            m.nombreMeta,
                            "Objetivo: \$${m.montoObjetivo.toStringAsFixed(2)}",
                            progress,
                            detail,
                            description,
                          ),
                        );
                      }).toList(),
                      
                    80.height, // Espacio para el floating action button
                  ],
                ),
              ),
            );
          }
        ),
    );
  }

  Widget _buildMetaItem(String idMeta, String title, String subtitle, double progress, String detail, String description) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title, style: boldTextStyle()),
        subtitle: Text(subtitle, style: secondaryTextStyle()),
        leading: CircleAvatar(
          backgroundColor: WAPrimaryColor.withOpacity(0.1),
          child: const Icon(Icons.flag, color: WAPrimaryColor),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: WAPrimaryColor.withOpacity(0.1),
                  color: WAPrimaryColor,
                  minHeight: 8,
                ).cornerRadiusWithClipRRect(4),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detail, style: boldTextStyle(size: 14)),
                    Text("${(progress * 100).toInt()}%", style: boldTextStyle(color: WAPrimaryColor)),
                  ],
                ),
                16.height,
                Text(description, style: secondaryTextStyle()),
                16.height,
                AppButton(
                  text: "Añadir Fondos",
                  color: WAPrimaryColor,
                  textStyle: boldTextStyle(color: Colors.white),
                  width: context.width(),
                  onTap: () {
                    _mostrarDialogoAportar(idMeta, title);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
