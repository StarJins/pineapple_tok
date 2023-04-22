class Profile {
  late String picturePath;
  late String name;

  Profile(this.picturePath, this.name);

  @override
  String toString() {
    return 'path: $picturePath, name: $name';
  }
}