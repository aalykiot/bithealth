package appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Locale;
import java.sql.Date;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import services.Database;

@WebServlet(name="Appointment_new", urlPatterns={"/appointment/new"})
public class Appointment_new extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Appointment_new() {
        super();
        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession authSession = request.getSession();
		
		String email = "cbennettl@gmail.com";
		authSession.setAttribute("email", email);
		authSession.setAttribute("type", "user");
		
		request.setAttribute("requested_doctor", request.getParameter("requested_doctor"));
		
		String day = request.getParameter("search_day");
		String month = request.getParameter("search_month");
		String year = request.getParameter("search_year");
		String hour = request.getParameter("search_hour");
		
		if(request.getParameter("requested_doctor") == null){
				
				request.getRequestDispatcher("/JSP/Appointment/step1-appointment.jsp").forward(request, response);		
				return;
		}
		else if(request.getParameter("submit") != null){
		
			if(!day.equals("-1") && !month.equals("-1") && !year.equals("-1") && !hour.equals("-1") ){
				
				Connection conn = Database.getConnection();
								
				if(conn != null){
					
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
					try {
						
						int userId = 0;
						int doctorId = Integer.parseInt(request.getParameter("requested_doctor"));
						String status ="pending";
						String scheduledDate = year + '-' + month + '-' + day + ' ' + hour + ":00:00";
						Timestamp schedule = Timestamp.valueOf(scheduledDate);
						
						query = "SELECT user_id FROM users WHERE email = ? ";
						
						ps = conn.prepareStatement(query);
						ps.setString(1, email);
						
						rs = ps.executeQuery(); // Execute query
						
						if(rs.next()){
							
							userId = rs.getInt(1);
							
						}
						
						rs.close();
						ps.close();
						
						query = "SELECT COUNT(*) FROM appointments WHERE scheduled_date = ? AND status = 'pending'";
						
						ps = conn.prepareStatement(query);
						
						ps.setTimestamp(1, schedule);
						
						rs = ps.executeQuery();
						
						int counter = 0;
						
						if(rs.next()){
							counter += Integer.parseInt(rs.getString("count"));
						}
						
						rs.close();
						ps.close();
						
						if(counter == 0){
							query = "INSERT INTO appointments(user_id,doctor_id,booked_date,scheduled_date,status) VALUES ( ?, ?, now(), ?, ?) ";
							
							ps = conn.prepareStatement(query);
							
							ps.setInt(1, userId);
							ps.setInt(2, doctorId);
							ps.setTimestamp(3, schedule);
							ps.setString(4, status);
							
							ps.executeUpdate();
							ps.close();
						}
						else{
							
							request.setAttribute("error", "Entries already booked");
						}
						Database.close();
						
					} catch (Exception e) {
						// show error
						request.setAttribute("error", "Error connecting to database!");
					}
				}else{
					
					request.setAttribute("error", "Error connecting to database!");
					request.getRequestDispatcher("/JSP/User/settings.jsp").forward(request, response);
					return;
					
				}
					
				
				request.getRequestDispatcher("/JSP/Appointment/step2-appointment.jsp").forward(request, response);
				return;
			}
			else{
				request.setAttribute("error", "Some fields are incorrect");
				
				request.getRequestDispatcher("/JSP/Appointment/step2-appointment.jsp").forward(request, response);
				return;
			}
		}
		else{		
			
			request.getRequestDispatcher("/JSP/Appointment/step2-appointment.jsp").forward(request, response);	
			return;
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
