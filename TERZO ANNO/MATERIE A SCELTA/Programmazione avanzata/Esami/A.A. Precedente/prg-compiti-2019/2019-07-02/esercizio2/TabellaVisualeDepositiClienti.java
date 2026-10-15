// TabellaVisualeDepositiClienti.java

import java.util.*;
import javafx.collections.*;
import javafx.scene.control.*;
import javafx.scene.control.cell.*;

public class TabellaVisualeDepositiClienti extends TableView<Cliente> {
    private final ObservableList<Cliente> listaOsservabileClienti; 
    
    public TabellaVisualeDepositiClienti() {
        setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);
        setMaxHeight(180);
        TableColumn colonnaEmail = new TableColumn("EMAIL"); 
        TableColumn colonnaDeposito = new TableColumn("DEPOSITO");
        colonnaEmail.setCellValueFactory(new PropertyValueFactory<>("email"));
        colonnaDeposito.setCellValueFactory(new PropertyValueFactory<>("deposito"));
        listaOsservabileClienti = FXCollections.observableArrayList(); 
        setItems(listaOsservabileClienti);
        getColumns().addAll(colonnaEmail, colonnaDeposito);
    } 
    
    public void aggiornaListaClienti(List<Cliente> clienti) {
        listaOsservabileClienti.clear();
        listaOsservabileClienti.addAll(clienti);    
    }
}
