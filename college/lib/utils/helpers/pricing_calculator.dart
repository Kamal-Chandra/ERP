class PricingCalculator {
  // Calculate Price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    double shippingCost = getShippingCost(location);
    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }

  // Calculate shipping cost
  static String calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost.toStringAsFixed(2);
  }

  // Calculate tax
  static String calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  // Mocked functions for demonstration purposes
  static double getTaxRateForLocation(String location) {
    // Mocked implementation
    return 0.1; // 10% tax rate
  }

  static double getShippingCost(String location) {
    // Mocked implementation
    return 5.00; // Fixed shipping cost
  }

  /*
  // Sum all cart values and return total amount
  static double calculateCartTotal(CartModel cart) {
    return cart.items.map((e) => e.price ?? 0).fold(0, (previousPrice, currentPrice) => previousPrice + (currentPrice??0));
  }
  */
}