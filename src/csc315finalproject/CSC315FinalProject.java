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
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;

/**
 *
 * @author Sean
 */
public class CSC315FinalProject {
    private String schemaFile;
    private String dataFile;
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        // Make sure we have the correct number of command line arguments. 
        if (args.length < 2) {
            String message = "Incorrect number of arguments. Expecting 3, got " + args.length;
            System.err.println(message);
            System.exit(-1);
        }
        
        // Run the program
        CSC315FinalProject program = new CSC315FinalProject(args[0], args[1]);
        program.run();
    }
    
    public CSC315FinalProject(String schemaFile, String dataFile)
    {
        this.schemaFile = schemaFile;
        this.dataFile = dataFile;
    }
    
    public void run() throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        createDatabase();
        
        printFlights();
        System.out.print("\n\n");
        
        printFlightsFromDallasToLosAngelesOnNewYearsEve();
        System.out.print("\n\n");
    }
    
    /////////////////////////////
    // QUERIES 
    /////////////////////////////
    private void printFlights() throws SQLException, ClassNotFoundException {
        // Create our SQL query
        String sql = 
                  "SELECT fl.FlightNumber, depart.Name AS DepartureAirport, arrival.Name AS ArrivalAirport "
                + "FROM Flight fl "
                + "INNER JOIN Airport depart ON (fl.DepartureAirportCode = depart.InternationalCode) "
                + "INNER JOIN Airport arrival ON (fl.ArrivalAirportCode = arrival.InternationalCode) "
                + "ORDER BY fl.Date, fl.DepartureTime;";
        
        // Execute our SQL query
        Connection conn = getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet results = stmt.executeQuery();
        
        // Display results
        System.out.println("Flights departing KDFW");
        System.out.println("----------------------");
        while (results.next()) {
            String flightNumber = results.getString("FlightNumber");
            String departAirport = results.getString("DepartureAirport");
            String arrivalAirport = results.getString("ArrivalAirport");
            System.out.format("%s\t%s\t\t%s\n", flightNumber, departAirport, arrivalAirport);
        }
        
        // Cleanup resources
        results.close();
        stmt.close();
        conn.close();
    }
    
    private void printFlightsFromDallasToLosAngelesOnNewYearsEve() throws SQLException, ClassNotFoundException {
        // Create our SQL Query
        String sql = 
                  "SELECT FlightNumber, DepartureTime, ArrivalTime FROM Flight "
                + "WHERE DepartureAirportCode = 'KDFW' AND ArrivalAirportCode = 'KLAX' AND Date = '12/31/2006' "
                + "ORDER BY DepartureTime";
        
        // Execute our SQL query
        Connection conn = getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet results = stmt.executeQuery();
        
        // Display results
        System.out.println("Flights from KDFW to KLAX Departing On 12/31/2006");
        System.out.println("-------------------------------------------------");
        while (results.next()) {
            String flightNumber = results.getString("FlightNumber");
            Time departureTime = results.getTime("DepartureTime");
            Time arrivalTime = results.getTime("ArrivalTime");
            System.out.format("%s\t%s\t%s\n", flightNumber, departureTime, arrivalTime);
        }
       
    }
    
    private void createDatabase() throws FileNotFoundException, IOException, SQLException, ClassNotFoundException {
        executeSqlFile(schemaFile);
        executeSqlFile(dataFile);
    }
    
    private void executeSqlFile(String filename) throws FileNotFoundException,
            IOException, SQLException, ClassNotFoundException
    {
        // Read the file in
        StringBuilder buffer = new StringBuilder();
        FileInputStream stream = new FileInputStream(filename);
        BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
            buffer.append("\n");
        }
            
        // Execute the SQL
        String sql = buffer.toString();
        Connection conn = getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.execute();
        conn.close();
    }
    
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load the JDBC driver for SQL Server
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // Connect to the database. We'll just use Windows Security
        final String url = "jdbc:sqlserver://SEAN-LAPTOP;databaseName=FinalProject;instanceName=SQLEXPRESS";
        return DriverManager.getConnection(url, "finalproject", "finalproject");
    }
}