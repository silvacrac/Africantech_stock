import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../nucleo/componentes/botao_padrao.dart';
import '../modelos/material.dart';

class ModalQrMaterial extends StatelessWidget {
  final MaterialModel material;

  const ModalQrMaterial({super.key, required this.material});

  Future<void> _imprimirEtiqueta() async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, 
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text("AFRICAN STOCK", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: material.sku,
                  width: 120,
                  height: 120,
                ),
                pw.SizedBox(height: 5),
                pw.Text(material.nome, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text("SKU: ${material.sku}", style: pw.TextStyle(fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4, 
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2)),
          ),
          const Text("Etiqueta do Material", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          QrImageView(
            data: material.sku,
            version: QrVersions.auto,
            size: 220.0,
            foregroundColor: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 16),
          Text(material.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("SKU: ${material.sku}", style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          const SizedBox(height: 32),
          BotaoPadrao(
            texto: "IMPRIMIR ETIQUETA",
            icone: Icons.print_rounded,
            onPressed: _imprimirEtiqueta,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}