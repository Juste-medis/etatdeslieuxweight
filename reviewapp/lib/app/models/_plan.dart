class Plan {
  final String? id;
  String name;
  final String? icon;
  String description;
  final List<String> features;
  final List<Price> prices;
  final String status;
  DateTime createdAt;
  DateTime updatedAt;

  int actualquantity = 0;
  double computedprice = 0.0;
  String selectedPriceId = "";

  Plan({
    this.id,
    this.name = '',
    this.icon,
    this.description = '',
    this.features = const [],
    this.status = 'active',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.prices = const [],
  })  : createdAt = createdAt ?? DateTime(1970, 1, 1),
        updatedAt = updatedAt ?? DateTime(1970, 1, 1);

  Plan copyWith({
    String? id,
    String? name,
    String? icon,
    String? description,
    List<String>? features,
    List<Price>? prices,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      features: features ?? this.features,
      prices: prices ?? this.prices,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Future<String> updatePlanQuantity(int quantity) async {
    actualquantity = quantity;
    Map<String, double> accuracy = {};
    int minInf = 0;
    int maxSup = 999999999;

    for (var price in prices) {
      if (!price.isInterval && price.qty == quantity) {
        computedprice = price.price * quantity;
        selectedPriceId = price.id ?? "";
        return price.id ?? "";
      }

      if (price.isInterval) {
        if ((quantity >= price.inf! && quantity <= price.sup!)) {
          accuracy[price.id ?? ""] = (price.sup! - price.inf!).toDouble();
        }
        if (price.inf! < minInf) {
          minInf = price.inf ?? 0;
          selectedPriceId = price.id ?? "";
        }
        if (price.sup != null && price.sup! > maxSup) {
          maxSup = price.sup ?? double.infinity.toInt();
          selectedPriceId = price.id ?? "";
        }
      }
    }
    if (quantity < minInf || quantity > maxSup) {
      computedprice =
          prices.firstWhere((p) => p.id == selectedPriceId).price * quantity;

      return selectedPriceId;
    }

    List<Price> cprices =
        prices.where((p) => accuracy.keys.contains(p.id)).toList();
    cprices.sort((a, b) => accuracy[a.id]!.compareTo(accuracy[b.id]!));

    if (cprices.isNotEmpty) {
      Price priceOption = cprices.first;
      selectedPriceId = priceOption.id ?? "";
      computedprice = priceOption.price * quantity;
    } else {
      computedprice = 0.0;
    }

    return selectedPriceId;
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id'],
      name: json['name'],
      icon: json['icon'],
      description: json['description'],
      features: List<String>.from(json['features']),
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      prices: (json['prices'] as List<dynamic>?)
              ?.map((price) => Price.fromJson(price as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'features': features.map((feature) => feature).toList(),
      'status': status,
      'prices': prices.map((price) => price.toJson()).toList(),
    };
  }
}

class Price {
  final String? id;
  final String? name;
  final String? description;
  final int? inf;
  final int? sup;
  final int? qty;
  final double price;
  final String currency;
  final bool isInterval;
  final String status;
  Price({
    this.id,
    this.name,
    this.description,
    this.qty,
    this.inf,
    this.sup,
    required this.price,
    this.currency = 'EUR',
    this.isInterval = false,
    this.status = 'active',
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      qty: json['qty'] != null ? json['qty'] as int : null,
      inf: json['inf'],
      sup: json['sup'],
      price: json['price'].toDouble(),
      currency: json['currency'] ?? 'EUR',
      isInterval: json['isInterval'] ?? false,
      status: json['status'] ?? 'active',
    );
  }

  Price copyWith({
    String? id,
    String? name,
    String? description,
    int? inf,
    int? sup,
    double? price,
    String? currency,
    bool? isInterval,
    int? qty,
    String? status,
  }) {
    return Price(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      inf: inf ?? this.inf,
      sup: sup ?? this.sup,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isInterval: isInterval ?? this.isInterval,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'inf': inf,
      'sup': sup,
      'price': price,
      'currency': currency,
      'isInterval': isInterval,
      'status': status,
      'qty': qty,
    };
  }
}
