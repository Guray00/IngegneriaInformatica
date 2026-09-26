public class Image {

  public byte[][] pixel;

  public Image(int r, int c) {
    pixel = new byte[r][c];
  }

  public int getRows() {
    return pixel.length;
  }

  public int getColumns() {
    return pixel[0].length;
  }
}
