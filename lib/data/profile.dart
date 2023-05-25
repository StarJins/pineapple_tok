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
}