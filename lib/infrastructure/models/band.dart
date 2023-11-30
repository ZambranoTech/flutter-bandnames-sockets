import 'dart:convert';

class Band {

  String id;
  String name;
  int votes;
  Band({
    required this.id,
    required this.name,
    this.votes = 0,
  });

  Band copyWith({
    String? id,
    String? name,
    int? votes,
  }) {
    return Band(
      id: id ?? this.id,
      name: name ?? this.name,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'votes': votes,
    };
  }

  factory Band.fromMap(Map<String, dynamic> map) {
    return Band(
      id: map['id'] ?? 'no-id',
      name: map['name'] ?? 'no-name',
      votes: map['votes'] ?? 'no-votes',
    );
  }

  String toJson() => json.encode(toMap());

  factory Band.fromJson(String source) => Band.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Band(id: $id, name: $name, votes: $votes)';

  @override
  bool operator ==(covariant Band other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.votes == votes;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ votes.hashCode;
}
