public class ChatServer {

  private Room current;
  
  public synchronized Room connect() {
    if(current == null) {
      current = new Room();
      return current;
    } else {
      Room temp = current;
      current = null;
      return temp;
    } 
  }
}
