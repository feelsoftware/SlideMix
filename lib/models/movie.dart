class Movie {
  final int id;
  final String title;
  final String thumb;
  final String video;

  Movie(this.id, this.title, this.thumb, this.video);

  @override
  String toString() {
    return "Movie{id: $id, title: $title, thumb: $thumb, video: $video}";
  }
}
