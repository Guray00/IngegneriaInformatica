// DataBaseDepositiClienti.java

import java.sql.*;
import java.util.*;

public class DataBaseDepositiClienti {
 private static Connection connessioneADatabase; 
 private static PreparedStatement statementClientiConDepositoMinimo; 

 static {
    try { connessioneADatabase = DriverManager.getConnection("jdbc:mysql://localhost:3306/depositibancari", "root","");   
          statementClientiConDepositoMinimo = connessioneADatabase.prepareStatement("SELECT email, deposito FROM depositiclienti WHERE deposito > ?");
    } catch (SQLException e) {System.err.println(e.getMessage());} 
 }

 public static List<Cliente> caricaClientiConDepositoMinimo(int depositoMinimo) {
     List<Cliente> listaClienti = new ArrayList<>();
     try { statementClientiConDepositoMinimo.setInt(1,depositoMinimo);
           ResultSet rs = statementClientiConDepositoMinimo.executeQuery();
           while (rs.next())
              listaClienti.add(new Cliente(rs.getString("email"), rs.getInt("deposito")));
      } catch (SQLException e) {System.err.println(e.getMessage());} 
     return listaClienti;
    }
}
