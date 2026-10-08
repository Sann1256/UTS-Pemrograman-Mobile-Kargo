import 'package:flutter/material.dart';

import '../models/cargo_vehicle.dart';

class CargoBookingScreen extends StatefulWidget {
  const CargoBookingScreen({super.key, required this.vehicle});

  final CargoVehicle vehicle;

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  String _cargoType = 'General Cargo';
  final List<String> _protections = [];
  DateTime? _pickupDate;
  TimeOfDay? _pickupTime;
  double _tonnage = 4;
  bool _reefer = false;
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  int get _totalCost {
    return widget.vehicle.rate +
        (_tonnage * 35000).round() +
        (_protections.length * 50000) +
        (_reefer ? 250000 : 0);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _pickupDate = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _pickupTime = time);
  }

  void _showCost() {
    if (_destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi tujuan pengiriman terlebih dahulu.')),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rincian Biaya Surat Jalan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('Armada ${widget.vehicle.name}: Rp ${widget.vehicle.rate}'),
              Text('Biaya tonase: Rp ${(_tonnage * 35000).round()}'),
              Text('Biaya proteksi: Rp ${_protections.length * 50000}'),
              if (_reefer) const Text('Reefer container: Rp 250000'),
              const Divider(),
              Text('Total: Rp $_totalCost'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final approved = await showDialog<bool>(
                    context: sheetContext,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Terbitkan surat jalan?'),
                      content: const Text('Pastikan data booking sudah benar.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Ya, terbitkan'),
                        ),
                      ],
                    ),
                  );

                  if (approved == true) {
                    Navigator.pop(sheetContext);
                    Navigator.pop(context, {
                      'resi': 'CF-${DateTime.now().millisecondsSinceEpoch}',
                      'armada': widget.vehicle.name,
                      'tujuan': _destinationController.text,
                      'status': 'Menunggu penjemputan',
                    });
                  }
                },
                child: const Text('Konfirmasi penerbitan'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Kargo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(widget.vehicle.name),
            subtitle: Text('Kapasitas ${widget.vehicle.capacity}'),
          ),
          const Text('Kategori Muatan'),
          for (final type in [
            'General Cargo',
            'Makanan Beku / Perishable',
            'Alat Berat',
          ])
            RadioListTile<String>(
              title: Text(type),
              value: type,
              groupValue: _cargoType,
              onChanged: (value) => setState(() => _cargoType = value!),
            ),
          const Text('Proteksi Pengiriman'),
          for (final option in [
            'Asuransi barang rusak',
            'Jasa forklift muat',
            'Pengawalan prioritas',
          ])
            CheckboxListTile(
              title: Text(option),
              value: _protections.contains(option),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _protections.add(option);
                  } else {
                    _protections.remove(option);
                  }
                });
              },
            ),
          const Text('Jadwal Penjemputan'),
          Row(
            children: [
              TextButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  _pickupDate == null
                      ? 'Pilih tanggal'
                      : '${_pickupDate!.day}/${_pickupDate!.month}/${_pickupDate!.year}',
                ),
              ),
              TextButton.icon(
                onPressed: _selectTime,
                icon: const Icon(Icons.access_time),
                label: Text(_pickupTime?.format(context) ?? 'Pilih jam'),
              ),
            ],
          ),
          Text('Tonase: ${_tonnage.toStringAsFixed(1)} ton'),
          Slider(
            value: _tonnage,
            min: 0.5,
            max: 20,
            divisions: 39,
            onChanged: (value) => setState(() => _tonnage = value),
          ),
          SwitchListTile(
            title: const Text('Reefer container'),
            value: _reefer,
            onChanged: (value) => setState(() => _reefer = value),
          ),
          TextField(
            key: const ValueKey('destinationField'),
            controller: _destinationController,
            decoration: const InputDecoration(
              labelText: 'Tujuan pengiriman',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _showCost,
            child: const Text('Hitung biaya logistik'),
          ),
        ],
      ),
    );
  }
}
