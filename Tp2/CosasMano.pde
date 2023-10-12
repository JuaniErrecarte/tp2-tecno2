static class CosasMano{
  static float getHandSize(Float[] topLeft, Float[] bottomRight){
    if(topLeft[0] == null || bottomRight[0] == null) return -10;
    float width = bottomRight[0] - topLeft[0];
    float height = bottomRight[1] - topLeft[1];
    println(width);
    
    return width;
  }
}
