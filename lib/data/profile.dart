import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  late String thumbnail;
  late String background;
  late String name;
  late String comment;

  Profile(this.thumbnail, this.background, this.name, this.comment);

  @override
  String toString() {
    return 'thumbnail: $thumbnail, background: $background,'
      'name: $name, comment: $comment';
  }

  factory Profile.getProfile(String thumbnail, String background, String name, String comment) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return Profile(thumbnail, background, name, comment);
  }
}

class ProfileHandler {
  final _firestore = FirebaseFirestore.instance;

  Future<Profile?> getProfile(String uid) async {
    final docRef = _firestore.collection('user').doc('profiles')
        .collection('data').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      String thumbnail = doc['thumbnail'];
      String background = doc['background'];
      String name = doc['name'];
      String comment = doc['comment'];
      return Profile.getProfile(thumbnail, background, name, comment);
    }
    else {
      return null;
    }
  }
}