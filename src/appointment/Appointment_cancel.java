package appointment;

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

@WebServlet(name="Appointment_cancel", urlPatterns={"/Appointment_cancel/new"})
public class Appointment_cancel extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Appointment_cancel() {
        super();
        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession authSession = request.getSession();
		
		request.getSession(false);
		String email = authSession.getAttribute("email").toString();
		
		if(authSession.getAttribute("email") != null ){
		
			int appointmentId = Integer.parseInt(request.getParameter("appointment_id"));
			int userId = 0;
			
			Connection conn = Database.getConnection();
			
			if(conn != null){
				
				if(request.getParameter("cancel_submit") != null){
					
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
					
					try{
						
						query = "SELECT user_id FROM users WHERE email = ? ";
						
						ps = conn.prepareStatement(query);
						ps.setString(1, email);
						
						rs = ps.executeQuery(); // Execute query
						
						if(rs.next()){
							
							userId = rs.getInt(1);
							
						}
						
						rs.close();
						ps.close();
						
						//Update pending status to canceled
						query = "UPDATE appointments SET status = 'canceled' WHERE appointment_id = ?";
				
						ps = conn.prepareStatement(query);
						
						ps.setInt(1, appointmentId);
						
						ps.executeUpdate();
						
						//Find doctor id
						query = "SELECT doctor_id FROM appointments WHERE appointment_id = ? ";
						
						ps = conn.prepareStatement(query);
						
						ps.setInt(1, appointmentId);
						
						rs = ps.executeQuery();
						
						int doctorId = 0;
						
						if(rs.next()){
							doctorId =  rs.getInt(1);
						}
						
						rs.close();
						ps.close();
						
						query = "INSERT INTO notifications(user_id,doctor_id,appointment_id) VALUES ( ?, ?, ?) ";
						
						ps = conn.prepareStatement(query);
						
						ps.setInt(1, userId);
						ps.setInt(2, doctorId);
						ps.setInt(3, appointmentId);
						
						//ps.executeUpdate();
						ps.close();
						
						Database.close(conn);
						
						response.sendRedirect("../user/dashboard");
						return;
					}
					catch(Exception e){
						//if there is an error
					}
				}
				else{
					
					response.sendRedirect("../");
					return;
				}
			}
		}
		else{
			
			response.sendRedirect("../");
			return;
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
