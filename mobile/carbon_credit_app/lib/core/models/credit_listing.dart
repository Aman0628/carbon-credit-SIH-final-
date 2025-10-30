class CreditListing {
  final String id;
  final String projectName;
  final String description;
  final String projectType;
  final String location;
  final double pricePerCredit;
  final int availableCredits;
  final String certificationBody;
  final String certificationStandard;
  final DateTime vintageYear;
  final String sellerId;
  final String sellerName;
  final List<String> images;
  final Map<String, dynamic> projectDetails;
  final DateTime createdAt;
  final String status; // 'active', 'sold_out', 'suspended'

  const CreditListing({
    required this.id,
    required this.projectName,
    required this.description,
    required this.projectType,
    required this.location,
    required this.pricePerCredit,
    required this.availableCredits,
    required this.certificationBody,
    required this.certificationStandard,
    required this.vintageYear,
    required this.sellerId,
    required this.sellerName,
    required this.images,
    required this.projectDetails,
    required this.createdAt,
    required this.status,
  });

  factory CreditListing.fromJson(Map<String, dynamic> json) {
    return CreditListing(
      id: json['id'] as String,
      projectName: json['project_name'] as String,
      description: json['description'] as String,
      projectType: json['project_type'] as String,
      location: json['location'] as String,
      pricePerCredit: (json['price_per_credit'] as num).toDouble(),
      availableCredits: json['available_credits'] as int,
      certificationBody: json['certification_body'] as String,
      certificationStandard: json['certification_standard'] as String,
      vintageYear: DateTime.parse(json['vintage_year'] as String),
      sellerId: json['seller_id'] as String,
      sellerName: json['seller_name'] as String,
      images: List<String>.from(json['images'] as List),
      projectDetails: json['project_details'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_name': projectName,
      'description': description,
      'project_type': projectType,
      'location': location,
      'price_per_credit': pricePerCredit,
      'available_credits': availableCredits,
      'certification_body': certificationBody,
      'certification_standard': certificationStandard,
      'vintage_year': vintageYear.toIso8601String(),
      'seller_id': sellerId,
      'seller_name': sellerName,
      'images': images,
      'project_details': projectDetails,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }
}

class CartItem {
  final String listingId;
  final CreditListing listing;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.listingId,
    required this.listing,
    required this.quantity,
    required this.addedAt,
  });

  double get totalPrice => listing.pricePerCredit * quantity;

  CartItem copyWith({
    String? listingId,
    CreditListing? listing,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      listingId: listingId ?? this.listingId,
      listing: listing ?? this.listing,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
