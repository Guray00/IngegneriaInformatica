// Cliente.java

import javafx.beans.property.*;

public class Cliente {
    private final SimpleStringProperty email;
    private final SimpleIntegerProperty deposito;
 
    public Cliente(String e, int d) {
      email = new SimpleStringProperty(e);
      deposito = new SimpleIntegerProperty(d);
    }
 
    public String getEmail() { return email.get(); }
    public int getDeposito() { return deposito.get(); }
}