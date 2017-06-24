package services;

import java.sql.Connection;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Database {
	
	private static Connection conn = null;
	
	public static Connection getConnection(){
		
		try{
			InitialContext cxt = new InitialContext();

			DataSource ds = (DataSource) cxt.lookup( "java:/comp/env/jdbc/bithealth" );
			
			Connection conn = ds.getConnection();
			
			return conn;

		}catch(Exception e){
			
			System.out.println(e.getMessage());
			
			return null;
		}
		
	}
	
	public static void close(Connection extConn){
		
		try{
			
			extConn.close();
			
		}catch(Exception e){
			
			System.out.println("Connection to database is null and can not be closed!");
			
		}
		
	}
	
}