public class MedianImageProcessor extends ImageProcessor {

  public MedianImageProcessor(String f) {
    super(f);
  }

  protected void processRow(Image i, int j) {
    int c = i.getColumns();
    for(int x=1; x<c-1; x++)
      i.pixel[j][x] = median(i.pixel[j][x-1],
                             i.pixel[j][x],
                             i.pixel[j][x+1]);
  }

  byte median(byte a, byte b, byte c) {
    if(a>b)
      if(b>c) return b;
      else return c;
    else
      if(a>c) return a;
      else return c;
  }
}
