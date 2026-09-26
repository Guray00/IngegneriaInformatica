public class User extends Thread {

  private int i;
  private ChatServer c;

  public User(int i, ChatServer c) {
    this.i = i;
    this.c = c;
  }

  public void run() { 
    Room r = null;
    try {
      r = c.connect();
      r.enter();
      for(int j=0; j<10; j++)
        r.post("Client " + i + ": message "+ j);
      System.out.println(r.toString());	
      r.leave();
    } catch (InterruptedException ie) {
      System.err.println("I have been interrupted...");
    } catch (AloneInRoomException a) {
      System.out.println("I'm talking to myself...");
      r.leave();
    }
  }
}
