import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/component/AppScaffold.dart';
import 'package:wallet_flutter/component/ExpenseFormModal.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Dashboard",
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hola, André!", style: boldTextStyle(size: 20)),
                Text("Bienvenido de nuevo", style: secondaryTextStyle()),
                16.height,
                
                // Tarjeta de Saldo
                Container(
                  width: context.width(),
                  padding: const EdgeInsets.all(24),
                  decoration: boxDecorationRoundedWithShadow(16, backgroundColor: WAPrimaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dinero disponible:", style: primaryTextStyle(color: Colors.white70)),
                      8.height,
                      Text("\$27,000.00", style: boldTextStyle(color: Colors.white, size: 30)),
                      24.height,
                    ],
                  ),
                ),
                
                24.height,
                Text("Operaciones Rápidas", style: boldTextStyle()),
                16.height,
                
                // Grid de operaciones (simulado)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(Icons.swap_horiz, "Transfer"),
                    _buildQuickAction(Icons.confirmation_number, "Vouchers"),
                    _buildQuickAction(Icons.account_balance_wallet, "Top Up"),
                    _buildQuickAction(Icons.receipt_long, "Bill Pay"),
                  ],
                ),
                
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transacciones Recientes", style: boldTextStyle()),
                    Text("Ver todo", style: secondaryTextStyle(color: WAPrimaryColor)),
                  ],
                ),
                16.height,
                
                // Lista de transacciones (simulada)
                _buildTransactionItem("Envío de dinero", "Hoy 5:30 PM", "-\$20,000", Colors.red),
                _buildTransactionItem("Salario Unbox", "Hoy 6:30 PM", "+\$50,000", Colors.green),
                _buildTransactionItem("Envío de dinero", "Hoy 5:30 PM", "-\$20,000", Colors.red),
                _buildTransactionItem("Salario Unbox", "Hoy 6:30 PM", "+\$50,000", Colors.green),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: WAPrimaryColor,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (context) => const ExpenseFormModal(),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
          child: Icon(icon, color: WAPrimaryColor),
        ),
        8.height,
        Text(label, style: secondaryTextStyle(size: 12)),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String subtitle, String amount, Color amountColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: Colors.white),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF0F0F0),
            child: Icon(Icons.compare_arrows, color: WAPrimaryColor),
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle(size: 14)),
              Text(subtitle, style: secondaryTextStyle(size: 12)),
            ],
          ).expand(),
          Text(amount, style: boldTextStyle(color: amountColor)),
        ],
      ),
    );
  }
}
