class Member {
  String username;
  String first;
  String? last;
  String email;
  String picture = 'https://picsum.photos/id/111/256/256';

  Member({
    required this.username,
    required this.first,
    this.last,
    required this.email,
    required this.picture
  });
  factory Member.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'username': String username,
      'first': String first,
      'last': String last,
      'email': String email,
      'picture': String picture
      } => Member(username:username, first:first, last:last, email:email, picture:picture),
      _ => throw const FormatException('Errr ผิดฟอร์แมต')
    };
  }

}