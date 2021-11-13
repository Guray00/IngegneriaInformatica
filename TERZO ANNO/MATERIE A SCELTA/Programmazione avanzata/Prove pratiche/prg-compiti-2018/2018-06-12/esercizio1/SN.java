import java.util.*;
import java.io.*;

public class SN {

  /* This file contains the list of authorized users */
  private String file;
  /* Set of active users' sessions (logged on users) */
  private List<Session> as;
  /* Maps users' names with lists of freinds */
  private Map<String, List<String>> fr;
  /* Maps users' names with pending messages*/
  private Map<String, List<String>> pp;

  public SN(String file) throws IOException {
    this.file = file;
    as = new ArrayList<Session>();
    fr = new HashMap<String, List<String>>();
    pp = new HashMap<String, List<String>>();
  }

  /* Returns true if the specified user is in the list of authorized ones */
  private boolean check (String name) throws FileNotFoundException, IOException {
    BufferedReader r = new BufferedReader(new FileReader(file));
    String l;
    while((l = r.readLine()) != null) {
      if(l.equals(name))
        return true;
    }
    return false;
  }

  /* Returns a Session object in case of successful login
     Authenticated users invoke methods on the Session object to interact with SN */
  public Session login(String name) throws LoginFailedException, FileNotFoundException, IOException {
    if(check(name)) {
      Session s = new Session(name);
      as.add(s);
      return s;
    } else
      throw new LoginFailedException("Unrecognized user");
  }

  /* New friendship.
     If the specified friend does not exist, false is returned.
  */
  private synchronized boolean friend(String name, String fn) {
    List<String> f=null;
    // Look for the specified friend in the list of active sessions
    for(Session s: as) {
      if (s.getName().equals(fn)){
        // List of friends of current user
        f = fr.get(name);
        // If there is no list, create an empty one
        if(f == null)
          fr.put(name, new ArrayList<String>());
        f = fr.get(name);
        // Add the specified friend to the list
        f.add(fn);
        return true;
      }
    }
    return false;
  }

  /* New post.
    The message is delivered to all friends. */
  private synchronized void post(String name, String m) {
    // List of friends
    List<String> friends = fr.get(name);
    // For each friend
    for(String i: friends){
      // List of messages delivered to friend i
      List<String> p = pp.get(i);
      // If there is no list, create an empty one
      if(p == null)
        pp.put(i, new ArrayList<String>());
      p = pp.get(i);
      // Add the message to the list
      p.add(m);
      // New messages are available, notify clients possibly blocked in a vew()
      notifyAll();
    }
  }

  /* View all messages delivered to the specified user.
     Messages are removed from SN */
  private synchronized String[] view(String name)  throws InterruptedException {
    // If there is no list of messages or if the list of messages is empty
    while(pp.get(name) == null || pp.get(name).size() == 0)
      wait();
    // List of delivered mesasges
    List<String> l =  pp.get(name);
    // Delete all messages
    pp.put(name, null);
    return l.toArray(new String[]{});
  }


  public class Session {

    /* User's name */
    private final String myname;

    Session(String n) {
      myname = n;
    }

    String getName() {
      return myname;
    }

    public boolean friend(String fn) {
      return SN.this.friend(myname, fn);
    }

    public void post(String m) {
      SN.this.post(myname, m);
    }

    public String[] view() throws InterruptedException {
      return SN.this.view(myname);
    }
  }

}
