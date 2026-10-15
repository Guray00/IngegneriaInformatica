public class Demo {
  public static void main(String[] args) {
    ChatServer cs = new ChatServer();
    for(int i=0; i<4; i++)
      new User(i, cs).start(); 
  }
} 
