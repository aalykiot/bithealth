package services;

import java.sql.Connection;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Database {
	
	static public Connection getConnection(){
		
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
	
}