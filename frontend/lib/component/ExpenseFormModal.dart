import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/utils/WAColors.dart';
import 'package:wallet_flutter/services/api_service.dart';
import 'package:wallet_flutter/models/transaction_models.dart';

class ExpenseFormModal extends StatefulWidget {
  final VoidCallback? onSaved;
  const ExpenseFormModal({super.key, this.onSaved});

  @override
  State<ExpenseFormModal> createState() => _ExpenseFormModalState();
}

class _ExpenseFormModalState extends State<ExpenseFormModal> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  
  String selectedTipo = 'EGRESO'; // INGRESO o EGRESO
  bool isLoading = false;

  final List<String> categories = [
    'ALIMENTACION',
    'TRANSPORTE',
    'SALUD',
    'VIVIENDA',
    'EDUCACION',
    'OCIO',
    'SERVICIOS',
    'DEUDAS',
    'INGRESO',
    'AHORRO'
  ];

  final List<String> qualities = [
    'FIJO',
    'VARIABLE'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Registrar Operación", style: boldTextStyle(size: 18)),
              IconButton(onPressed: () => finish(context), icon: const Icon(Icons.close)),
            ],
          ),
          16.height,
          
          // Selector de Tipo de Flujo
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: "Ingreso",
                  color: selectedTipo == 'INGRESO' ? Colors.green : Colors.grey[200],
                  textStyle: boldTextStyle(color: selectedTipo == 'INGRESO' ? Colors.white : Colors.black),
                  onTap: () {
                    setState(() => selectedTipo = 'INGRESO');
                  },
                ),
              ),
              16.width,
              Expanded(
                child: AppButton(
                  text: "Egreso",
                  color: selectedTipo == 'EGRESO' ? Colors.red : Colors.grey[200],
                  textStyle: boldTextStyle(color: selectedTipo == 'EGRESO' ? Colors.white : Colors.black),
                  onTap: () {
                    setState(() => selectedTipo = 'EGRESO');
                  },
                ),
              ),
            ],
          ),
          16.height,

          AppTextField(
            controller: amountController,
            textFieldType: TextFieldType.NUMBER,
            decoration: waInputDecoration(hint: "Monto (\$)", prefixIcon: Icons.attach_money),
          ),
          16.height,
          AppTextField(
            controller: descController,
            textFieldType: TextFieldType.NAME,
            decoration: waInputDecoration(hint: "Descripción", prefixIcon: Icons.description),
          ),
          16.height,
          isLoading 
            ? const Center(child: CircularProgressIndicator(color: WAPrimaryColor))
            : AppButton(
                text: "Predecir y Registrar",
                color: WAPrimaryColor,
                textStyle: boldTextStyle(color: Colors.white),
                width: context.width(),
                onTap: _onPredecir,
              ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Future<void> _onPredecir() async {
    if (amountController.text.isEmpty || descController.text.isEmpty) {
      toast("Por favor ingresa monto y descripción");
      return;
    }
    
    double? monto = double.tryParse(amountController.text);
    if (monto == null) {
      toast("Monto inválido");
      return;
    }

    setState(() => isLoading = true);

    final response = await ApiService.predecirTransaccion(
      tipoFlujo: selectedTipo,
      monto: monto,
      descripcion: descController.text,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (response != null) {
      finish(context); // Cierra modal actual
      _showAIConfirmation(response);
    } else {
      toast("Error al predecir transacción");
    }
  }

  void _showAIConfirmation(ClasificarTransaccionResponse response) {
    String currentCategory = categories.contains(response.categoria) 
        ? response.categoria 
        : (selectedTipo == 'INGRESO' ? 'INGRESO' : 'ALIMENTACION');
        
    // Si es ingreso y la IA contestó algo loco o SALARIO, lo forzamos a INGRESO para que pase bien
    if (selectedTipo == 'INGRESO' && !categories.contains(currentCategory)) {
        currentCategory = 'INGRESO';
    }

    String currentQuality = response.cualidad;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (BuildContext ctx, StateSetter setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, color: WAPrimaryColor, size: 50),
                16.height,
                Text("Confirmación de IA", style: boldTextStyle(size: 18)),
                8.height,
                Text(
                  "Hemos clasificado tu operación como ${currentQuality} en la categoría ${currentCategory}.",
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(),
                ),
                16.height,
                
                // Edición de Categoría
                DropdownButtonFormField<String>(
                  value: currentCategory,
                  decoration: waInputDecoration(hint: "Categoría"),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => currentCategory = val);
                  },
                ),
                16.height,
                
                // Edición de Cualidad
                DropdownButtonFormField<String>(
                  value: qualities.contains(currentQuality) ? currentQuality : 'VARIABLE',
                  decoration: waInputDecoration(hint: "Cualidad"),
                  items: qualities.map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                  onChanged: (val) {
                    if (val != null) setModalState(() => currentQuality = val);
                  },
                ),
                
                24.height,
                Row(
                  children: [
                    AppButton(
                      text: "Cancelar",
                      color: Colors.grey[200],
                      textStyle: boldTextStyle(),
                      onTap: () => finish(ctx),
                    ).expand(),
                    16.width,
                    AppButton(
                      text: "Confirmar",
                      color: WAPrimaryColor,
                      textStyle: boldTextStyle(color: Colors.white),
                      onTap: () async {
                        // Llamar a guardar
                        bool success = await ApiService.guardarTransaccion(
                          tipoFlujo: response.tipoFlujo,
                          cualidadFlujo: currentQuality,
                          categoria: currentCategory,
                          monto: response.monto,
                          descripcion: response.descripcion,
                        );
                        
                        if (ctx.mounted) finish(ctx);
                        if (success) {
                          toast("Transacción guardada exitosamente");
                          if (widget.onSaved != null) {
                            widget.onSaved!();
                          }
                        } else {
                          toast("Error al guardar la transacción");
                        }
                      },
                    ).expand(),
                  ],
                ),
                SizedBox(height: MediaQuery.of(ctx).viewInsets.bottom),
              ],
            ),
          );
        });
      },
    );
  }

  InputDecoration waInputDecoration({String? hint, IconData? prefixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: WAPrimaryColor)),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      fillColor: WAPrimaryColor.withOpacity(0.04),
      hintText: hint,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: WAPrimaryColor) : null,
      filled: true,
    );
  }
}

