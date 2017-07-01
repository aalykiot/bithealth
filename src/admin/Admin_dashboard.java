package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import services.Database;
import services.Encryption;

@WebServlet(name="Admin_dashboard", urlPatterns={"/admin/dashboard"})
public class Admin_dashboard extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Admin_dashboard() {
        super();

    }
    
    

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//Insert Doctor into the Database
		
		if(request.getParameter("insertButton") != null ){
			String fName = request.getParameter("fName");
            String lName = request.getParameter("lName");
            String eml = request.getParameter("eml");
            String pass = request.getParameter("pass");
            String hashPass = Encryption.hash(pass);
            String amka = request.getParameter("amka");
            String speciality = request.getParameter("speciality");
            String dayFrom = request.getParameter("dayFrom");
            String dayTo = request.getParameter("dayTo");
            String hourFrom = request.getParameter("hourFrom");
            String hourTo = request.getParameter("hourTo"); 
            Connection conn = Database.getConnection();
            if( fName != null && lName != null && eml != null && pass != null && amka != null  && speciality != null && dayFrom != null  && dayTo != null && hourFrom != null && hourTo != null   ){
            	
            	if( !fName.isEmpty() && !lName.isEmpty() && !eml.isEmpty() && !pass.isEmpty() && !amka.isEmpty() && !speciality.isEmpty() && !dayFrom.isEmpty()  && !dayTo.isEmpty() && !hourFrom.isEmpty() && !hourTo.isEmpty()){
            		
            	
            	
            	
				
				if(conn != null){
					
					PreparedStatement ps = null;
					
					String query = null;
					
					try {
						
						
						
						query = "INSERT INTO doctors(first_name,last_name,email,password,amka,speciality,day_from,day_to,hour_from,hour_to) VALUES(?,?,?,?,?,?,?,?,?,?)";
						ps = conn.prepareStatement(query);
					    
	
						ps.setString(1, fName);
		 				ps.setString(2, lName);
		 				ps.setString(3, eml);
		 				ps.setString(4, hashPass);
		 				ps.setLong(5, Long.parseLong(amka));
		 				ps.setString(6, speciality);
		 				ps.setInt(7, Integer.parseInt(dayFrom));
		 				ps.setInt(8, Integer.parseInt(dayTo));
		 				ps.setInt(9, Integer.parseInt(hourFrom));
		 				ps.setInt(10, Integer.parseInt(hourTo));
					
		 				ps.executeUpdate();
						
						ps.close();
						
						
						Database.close(conn);
						
						
						response.sendRedirect("./dashboard?v=doctors");
						return;
						
						
						}catch (Exception e) {
							// show error
							System.out.println("Runtime-log: " + e.getMessage());
						}
			
				}
			
            }else{
            	Database.close(conn);
            	request.getRequestDispatcher("/JSP/Admin/dashboard.jsp").forward(request, response);
          	  	return;
            }
          
          }else{
        	  Database.close(conn);
        	  request.getRequestDispatcher("/JSP/Admin/dashboard.jsp").forward(request, response);
        	  return;
	      }
		
           
      }
		//Delete Doctor from the Database
		else if(request.getParameter("deleteButton") != null ){
			    String docId = request.getParameter("doctorID");
			    
			    Connection conn = Database.getConnection();
				
				if(conn != null){
					
					PreparedStatement ps = null;
					
					String query = null;
					
					try {
						
						query = "DELETE FROM notifications WHERE doctor_id = ?";
						ps = conn.prepareStatement(query);
						ps.setInt(1, Integer.parseInt(docId));
		 				ps.executeUpdate();
						
						ps.close();
						
						query = "DELETE FROM appointments WHERE doctor_id = ?";
						ps = conn.prepareStatement(query);
						ps.setInt(1, Integer.parseInt(docId));
		 				ps.executeUpdate();
						
						ps.close();
						
						query = "DELETE FROM doctors WHERE doctor_id = ?";
						ps = conn.prepareStatement(query);
						ps.setInt(1, Integer.parseInt(docId));
		 				ps.executeUpdate();
						
						ps.close();
						
						
						Database.close(conn); 
						
						
						response.sendRedirect("./dashboard?v=doctors");
						return;
						
						
						}catch (Exception e) {
							// show error
							System.out.println("Runtime-log: " + e.getMessage());
						}
			
				}
			
            }else{
            	
            	
            	request.getRequestDispatcher("/JSP/Admin/dashboard.jsp").forward(request, response);
          	  	return;
            }
		
		
		
	}
	
	

	


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
