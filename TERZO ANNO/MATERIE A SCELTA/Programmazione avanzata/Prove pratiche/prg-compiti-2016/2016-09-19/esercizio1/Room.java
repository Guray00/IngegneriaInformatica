public class Room {

  private int users;
  private String messages = "";
  private static int counter;
  private int number;

  public Room(){
    number = counter++;
    messages = "Room " + number + "\n";
  }

  public synchronized void enter() throws InterruptedException {
    users++;     
    while(users == 1)
      wait();
    if(users == 2)
      notify();
  }

  public synchronized void post(String m) throws AloneInRoomException {
    if(users == 1) 
      throw new AloneInRoomException();
    messages += m + "\n";
  }
  
  public synchronized void leave() {
    users--;
  }  

  public synchronized String toString() {
    return messages;
  }
}
