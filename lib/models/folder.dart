class MyFolder implements Comparable<MyFolder> 
{
  final String path;
  final String name;
  bool selected;

  // Wheather File or Directory

  final String type;

  MyFolder
  (
    {this.path, this.name, this.type, this.selected: false}
  );

  @override
  int compareTo(other) 
  {
    return type.compareTo(other.type);
  }
}