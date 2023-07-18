package com.example.traveljournal;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class LoginController {
    @FXML
    public TextField user;

    @FXML
    public TextField pass;

    private String currUN;
    private String currPass;


    public void loginAction (ActionEvent event) throws SQLException {
            DataBaseConnector connection = new DataBaseConnector();
            Connection connectDB = connection.getConnection();
            String connectQuery = "SELECT IsUser FROM ACCOUNT WHERE Username = '" + user.getText() + "' AND UserPassword = '" + pass.getText() + "';";

            currUN = user.getText();
            currPass = pass.getText();

            try {
                Statement statement = connectDB.createStatement();
                ResultSet queryOutput = statement.executeQuery((connectQuery));
                while (queryOutput.next()) {
                    FXMLLoader fxmlLoader = null;
                    if (queryOutput.getString(1).equals("1")) {
                        fxmlLoader = new FXMLLoader((TJApp.class.getResource("Home.fxml")));
                    } else if (queryOutput.getString(1).equals("0")) {
                        fxmlLoader = new FXMLLoader((TJApp.class.getResource("Admin_Flags_Home_Page.fxml")));
                    }
                    Scene scene = new Scene(fxmlLoader.load());
                    //Stage stage = getCurrentStage(event);
                    Stage stage = (Stage) ((Node) (event.getSource())).getScene().getWindow();
                    stage.setScene(scene);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            connectDB.close();

        }
    }














