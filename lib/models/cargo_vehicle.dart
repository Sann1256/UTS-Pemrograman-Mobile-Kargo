class CargoVehicle {
  const CargoVehicle({
    required this.name,
    required this.capacity,
    required this.description,
    required this.imageUrl,
    required this.rate,
  });

  final String name;
  final String capacity;
  final String description;
  final String imageUrl;
  final int rate;
}

const cargoVehicles = [
  CargoVehicle(
    name: 'Colt Diesel',
    capacity: '2 ton',
    description: 'Lincah untuk distribusi dalam kota',
    imageUrl: 'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?auto=format&fit=crop&w=500&q=80',
    rate: 450000,
  ),
  CargoVehicle(
    name: 'Fuso',
    capacity: '8 ton',
    description: 'Pilihan andal untuk muatan menengah',
    imageUrl: 'https://images.unsplash.com/photo-1519003722824-194d4455a60c?auto=format&fit=crop&w=500&q=80',
    rate: 950000,
  ),
  CargoVehicle(
    name: 'Tronton',
    capacity: '20 ton',
    description: 'Kapasitas besar untuk rute antarkota',
    imageUrl: 'https://images.unsplash.com/photo-1586191582151-f73872dfd183?auto=format&fit=crop&w=500&q=80',
    rate: 1750000,
  ),
];
