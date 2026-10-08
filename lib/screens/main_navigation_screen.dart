import 'package:flutter/material.dart';

import '../models/cargo_vehicle.dart';
import 'cargo_booking_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _receipts = [
    {
      'resi': 'CF-001',
      'armada': 'Fuso',
      'tujuan': 'Bandung',
      'status': 'Berjalan',
    },
    {
      'resi': 'CF-002',
      'armada': 'Colt Diesel',
      'tujuan': 'Subang',
      'status': 'Selesai',
    },
  ];
  final List<bool> _expanded = [false, false, false];

  final List<String> _menuNames = [
    'Manifes Muatan',
    'Rekap Resi',
    'Informasi Depo',
  ];

  final List<IconData> _menuIcons = [
    Icons.local_shipping,
    Icons.receipt_long,
    Icons.warehouse,
  ];

  Future<void> _openBooking(CargoVehicle vehicle) async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => CargoBookingScreen(vehicle: vehicle),
      ),
    );

    if (result == null) return;

    setState(() {
      _receipts.insert(0, result);
      _selectedIndex = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resi ${result['resi']} berhasil diterbitkan.')),
    );
  }

  Widget _manifestPage() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Armada tersedia'),
              Tab(text: 'Syarat muatan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: cargoVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = cargoVehicles[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: SizedBox(
                          width: 90,
                          height: 70,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                vehicle.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.local_shipping, size: 40),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.teal,
                                  padding: const EdgeInsets.all(3),
                                  child: Text(
                                    vehicle.capacity,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        title: Text(vehicle.name),
                        subtitle: Text(
                          '${vehicle.description}\nRp ${vehicle.rate}',
                        ),
                        trailing: TextButton(
                          onPressed: () => _openBooking(vehicle),
                          child: const Text('Pilih Armada'),
                        ),
                      ),
                    );
                  },
                ),
                ListView(
                  children: [
                    ExpansionPanelList(
                      expansionCallback: (index, isExpanded) {
                        setState(() => _expanded[index] = !isExpanded);
                      },
                      children: [
                        _hazardPanel(
                          0,
                          'Bahan mudah terbakar',
                          'Jauhkan dari api dan beri label bahaya.',
                        ),
                        _hazardPanel(
                          1,
                          'Bahan kimia',
                          'Gunakan wadah tertutup dan tahan bocor.',
                        ),
                        _hazardPanel(
                          2,
                          'Baterai',
                          'Lindungi terminal baterai dari hubungan arus pendek.',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel _hazardPanel(int index, String title, String detail) {
    return ExpansionPanel(
      isExpanded: _expanded[index],
      headerBuilder: (context, isExpanded) => ListTile(title: Text(title)),
      body: Padding(padding: const EdgeInsets.all(16), child: Text(detail)),
    );
  }

  Widget _receiptPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No. resi')),
          DataColumn(label: Text('Armada')),
          DataColumn(label: Text('Tujuan')),
          DataColumn(label: Text('Status')),
        ],
        rows: _receipts.map((receipt) {
          return DataRow(
            cells: [
              DataCell(Text(receipt['resi']!)),
              DataCell(Text(receipt['armada']!)),
              DataCell(Text(receipt['tujuan']!)),
              DataCell(Text(receipt['status']!)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _depotPage() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Depo Utama Subang', style: TextStyle(fontSize: 20)),
          SizedBox(height: 12),
          Text('Alamat: Jl. Brigjen Katamso No. 37, Subang'),
          Text('Telepon: (0260) 417648'),
          SizedBox(height: 16),
          Text('Kode tracking API:'),
          SelectableText('CF-SUB-API-2026'),
          SizedBox(height: 12),
          Text('Identitas gudang:'),
          SelectableText('CargoFlow Hub Subang - SUB-04'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_manifestPage(), _receiptPage(), _depotPage()];

    return Scaffold(
      appBar: AppBar(title: Text(_menuNames[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'CargoFlow\nPetugas: Ihsan\nArmada: SUB-04',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            for (var index = 0; index < _menuNames.length; index++)
              ListTile(
                leading: Icon(_menuIcons[index]),
                title: Text(_menuNames[index]),
                onTap: () {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              ),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          for (var index = 0; index < _menuNames.length; index++)
            BottomNavigationBarItem(
              icon: Icon(_menuIcons[index]),
              label: _menuNames[index],
            ),
        ],
      ),
    );
  }
}
