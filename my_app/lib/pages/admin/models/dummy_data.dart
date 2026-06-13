class FoodDonation {
  final String id;
  final String foodName;
  final String donor;
  final String expired;
  final int quantity;
  final String status;

  FoodDonation({
    required this.id,
    required this.foodName,
    required this.donor,
    required this.expired,
    required this.quantity,
    required this.status,
  });
}

List<FoodDonation> dummyFoods = [
  FoodDonation(
    id: "1",
    foodName: "Roti Bakery",
    donor: "Bakery Sejahtera",
    expired: "2 Hari",
    quantity: 20,
    status: "pending",
  ),
  FoodDonation(
    id: "2",
    foodName: "Nasi Box",
    donor: "Hotel Mawar",
    expired: "1 Hari",
    quantity: 50,
    status: "published",
  ),
  FoodDonation(
    id: "3",
    foodName: "Sayuran",
    donor: "Pasar Modern",
    expired: "1 Hari",
    quantity: 30,
    status: "ternak",
  ),
];