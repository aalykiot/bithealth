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

@WebServlet(name="Appointment_review", urlPatterns={"/appointment/review"})
public class Appointment_review extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Appointment_review() {
        super();
        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession authSession = request.getSession();
		
		request.getSession(false);
		int appointmentId = (int) authSession.getAttribute("appointment_id");
		
		if(authSession.getAttribute("good_review") != null){
			
			Connection conn = Database.getConnection();
			
			if(authSession.getAttribute("good_review") != null ){
				
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
				try{
					
					query = "SELECT doctor_id FROM appointments WHERE appointment_id= ? ";
					
					ps = conn.prepareStatement(query);
					ps.setInt(1, appointmentId);
					
					rs = ps.executeQuery(); // Execute query

					int doctorId = 0;
					
					if(rs.next()){
						
						doctorId = rs.getInt(1);
						
					}
					
					rs.close();
					ps.close();
					

					query = "UPDATE appointments SET review = 'true' WHERE appointment_id = ?";

					ps = conn.prepareStatement(query);
					
					ps.setInt(1, appointmentId);
					
					ps.executeUpdate();
					
					ps.close();
					
					
					query = "UPDATE doctors SET good_review = good_review + 1 WHERE doctor_id = ?";

					ps = conn.prepareStatement(query);
					
					ps.setInt(1, doctorId);
					
					ps.executeUpdate();
					
					ps.close();
					
					Database.close(conn);
									
				} catch (Exception e) {
					// show error
					System.out.println(e.getMessage());
				}
			}	

		}
		else if(authSession.getAttribute("bad_review") != null ){
			
			Connection conn = Database.getConnection();
			
			if(conn != null){
				
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
				try{
					
					query = "SELECT doctor_id FROM appointments WHERE appointments_id= ? ";
					
					ps = conn.prepareStatement(query);
					ps.setInt(1, appointmentId);
					
					rs = ps.executeQuery(); // Execute query

					int doctorId = 0;
					
					if(rs.next()){
						
						doctorId = rs.getInt(1);
						
					}
					
					rs.close();
					ps.close();
					

					query = "UPDATE appointments SET review = 'true' WHERE appointment_id = ?";

					ps = conn.prepareStatement(query);
					
					ps.setInt(1, appointmentId);
					
					ps.executeUpdate();
					
					ps.close();
					
					
					query = "UPDATE doctors SET bad_review = bad_review + 1 WHERE doctor_id = ?";

					ps = conn.prepareStatement(query);
					
					ps.setInt(1, doctorId);
					
					ps.executeUpdate();
					
					ps.close();
					
					Database.close(conn);
									
				} catch (Exception e) {
					// show error
					System.out.println(e.getMessage());
				}
			}
			
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
