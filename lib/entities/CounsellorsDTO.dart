class CounsellorsDTO {
  final String name;
  final double rating;
  final bool isOnline;
  final String expertise;
  final String imgUrl;
  final String? id;

  CounsellorsDTO(
      {required this.name,
      required this.rating,
      required this.isOnline,
      required this.expertise,
      required this.imgUrl,
      this.id,});

    
}