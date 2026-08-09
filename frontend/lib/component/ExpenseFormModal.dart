import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class ExpenseFormModal extends StatefulWidget {
  const ExpenseFormModal({super.key});

  @override
  State<ExpenseFormModal> createState() => _ExpenseFormModalState();
}

class _ExpenseFormModalState extends State<ExpenseFormModal> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedCategory = 'ALIMENTACION';

  List<String> categories = [
    'ALIMENTACION',
    'TRANSPORTE',
    'SALUD',
    'VIVIENDA',
    'EDUCACION',
    'OCIO',
    'SERVICIOS',
    'DEUDAS'
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
              Text("Registrar Gasto", style: boldTextStyle(size: 18)),
              IconButton(onPressed: () => finish(context), icon: const Icon(Icons.close)),
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
          AppButton(
            text: "Registrar gasto",
            color: WAPrimaryColor,
            textStyle: boldTextStyle(color: Colors.white),
            width: context.width(),
            onTap: () {
              // Simulación de confirmación de IA
              _showAIConfirmation();
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  void _showAIConfirmation() {
    finish(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: WAPrimaryColor, size: 50),
              16.height,
              Text("Confirmación de transacción", style: boldTextStyle(size: 18)),
              8.height,
              Text(
                "Hemos clasificado tu gasto como VARIABLE en la categoría OCIO. ¿Es correcto?",
                textAlign: TextAlign.center,
                style: secondaryTextStyle(),
              ),
              24.height,
              Row(
                children: [
                  AppButton(
                    text: "Editar",
                    color: Colors.grey[200],
                    textStyle: boldTextStyle(),
                    onTap: () => finish(context),
                  ).expand(),
                  16.width,
                  AppButton(
                    text: "Confirmar",
                    color: WAPrimaryColor,
                    textStyle: boldTextStyle(color: Colors.white),
                    onTap: () {
                      finish(context);
                      toast("Transacción guardada exitosamente");
                    },
                  ).expand(),
                ],
              ),
            ],
          ),
        );
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
