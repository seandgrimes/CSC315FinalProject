/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package csc315finalproject;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author Sean
 */
public class CSC315FinalProject {
    private String inputFile;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        CSC315FinalProject program = new CSC315FinalProject(args[0]);
        program.run();
    }
    
    public CSC315FinalProject(String inputFile)
    {
        this.inputFile = inputFile;
    }
    
    public void run() throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        createDatabase();
    }
    
    private void createDatabase() throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        // Read the file in
        StringBuilder buffer = new StringBuilder();
        FileInputStream stream = new FileInputStream(inputFile);
        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }
            
        // Create the tables
        String sql = buffer.toString();
        Connection conn = getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.execute();
    }
    
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load the JDBC driver for SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // Connect to the database. We'll just use Windows Security
        final String url = "jdbc:sqlserver://SEAN-LAPTOP;databaseName=FinalProject;instanceName=SQLEXPRESS";
        return DriverManager.getConnection(url, "finalproject", "finalproject");
    }
}