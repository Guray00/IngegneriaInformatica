// ConsultazioneDepositiClienti.java

import javafx.application.*;
import javafx.event.ActionEvent;
import javafx.scene.*;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.*;
 
public class ConsultazioneDepositiClienti extends Application {
    int depositoMinimo = 0;
    
    private TabellaVisualeDepositiClienti tabellaDepositi;       
    private TextField campoDepositoMinimo;
    
    public void start(Stage stage) {     
       tabellaDepositi = new TabellaVisualeDepositiClienti();
       tabellaDepositi.aggiornaListaClienti(DataBaseDepositiClienti.caricaClientiConDepositoMinimo(0));    
      
       final Label etichettaDepositoMinimo = new Label("Deposito minimo:");
       campoDepositoMinimo = new TextField("0");
       final Button pulsanteSelezione = new Button("Seleziona");      
       final VBox vbox = new VBox(); 
       vbox.getChildren().addAll(tabellaDepositi, etichettaDepositoMinimo, campoDepositoMinimo, pulsanteSelezione);      
       
       pulsanteSelezione.setOnAction((ActionEvent ev) -> { 
           depositoMinimo = Integer.parseInt(campoDepositoMinimo.getText());
           tabellaDepositi.aggiornaListaClienti(DataBaseDepositiClienti.caricaClientiConDepositoMinimo(depositoMinimo));
       });
       
       Scene scene = new Scene(new Group(vbox));         
       stage.setTitle("Depositi Bancari");          
       stage.setScene(scene);                          
       stage.show();
    }
} 
