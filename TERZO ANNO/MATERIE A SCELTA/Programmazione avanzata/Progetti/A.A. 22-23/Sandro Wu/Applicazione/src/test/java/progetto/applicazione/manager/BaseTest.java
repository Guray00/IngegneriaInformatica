// /*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt
// to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit
// this template
// */
// package progetto.applicazione.manager;

// import javafx.scene.Scene;
// import javafx.scene.control.Button;
// import javafx.scene.layout.StackPane;
// import javafx.stage.Stage;

// import org.junit.jupiter.api.Test;
// import org.junit.jupiter.api.extension.ExtendWith;
// import org.testfx.api.FxRobot;
// import org.testfx.framework.junit5.ApplicationExtension;
// import org.testfx.framework.junit5.Start;

// import static org.testfx.api.FxAssert.verifyThat;
// import static org.testfx.matcher.control.LabeledMatchers.hasText;

// @ExtendWith(ApplicationExtension.class)
// public class BaseTest {

// @Start
// void onStart(Stage stage) {
// Button button = new Button("click me!");
// button.setOnAction(actionEvent -> button.setText("clicked!"));
// stage.setScene(new Scene(new StackPane(button), 100, 100));
// stage.show();
// }

// @Test
// void should_contain_button() {
// // expect:
// // verifyThat(".button", hasText("click me!"));
// }

// @Test
// void should_click_on_button(FxRobot robot) {
// // when:
// // robot.clickOn(".button");

// // then:
// // verifyThat(".button", hasText("clicked!"));
// }

// }