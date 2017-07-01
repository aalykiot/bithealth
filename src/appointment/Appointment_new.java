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
		
	    HttpSession authSession = request.getSession(false);
		  
		request.setAttribute("requested_doctor", request.getParameter("requested_doctor"));

		if(authSession.getAttribute("email") != null){
			
			if(authSession.getAttribute("type").equals("user")){
					
				authSession.setAttribute("type", "user");
				
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
								String email = authSession.getAttribute("email").toString();
								String scheduledDate = year + '-' + month + '-' + day + ' ' + hour + ":00:00";
								Timestamp schedule = Timestamp.valueOf(scheduledDate);
								
								int dayFrom = 0;
								int dayTo = 0;
								int hourFrom= 0;
								int hourTo = 0;
								
								Calendar c = Calendar.getInstance();
								c.setTime(schedule);
								int dayOfWeek = c.get(Calendar.DAY_OF_WEEK) - 1;
								
								String now = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
								Timestamp thistime = Timestamp.valueOf(now);
								
								long millisecondNow = thistime.getTime();
								long millisecondThen = schedule.getTime();
								
								if(millisecondNow < millisecondThen){
									
									query = "SELECT day_from, day_to, hour_from, hour_to FROM doctors WHERE doctor_id = ? ";
									
									ps = conn.prepareStatement(query);
									ps.setInt(1, doctorId);
									
									rs = ps.executeQuery(); // Execute query
									
									if(rs.next()){
										
										dayFrom = rs.getInt(1);
										dayTo = rs.getInt(2);
										hourFrom = rs.getInt(3);
										hourTo = rs.getInt(4);
										
									}
			
									if(hourFrom <= Integer.parseInt(hour) && hourTo >= Integer.parseInt(hour) && dayFrom <= dayOfWeek && dayTo >= dayOfWeek){
										
										query = "SELECT user_id FROM users WHERE email = ? ";
										
										ps = conn.prepareStatement(query);
										ps.setString(1, email);
										
										rs = ps.executeQuery(); // Execute query
										
										if(rs.next()){
											userId = rs.getInt(1);									
										}
										
										rs.close();
										ps.close();
										
										query = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND scheduled_date = ? AND status = 'pending'";
										
										ps = conn.prepareStatement(query);
										
										ps.setInt(1, doctorId);
										ps.setTimestamp(2, schedule);
										
										rs = ps.executeQuery();
										
										int counterDoctor = 0;
										
										if(rs.next()){
											counterDoctor += Integer.parseInt(rs.getString("count"));
										}
										
										rs.close();
										ps.close();
										
										if(counterDoctor == 0){
											
											query = "SELECT COUNT(*) FROM appointments WHERE user_id = ? AND scheduled_date = ? AND status = 'pending'";
											
											ps = conn.prepareStatement(query);
											
											ps.setInt(1, userId);
											ps.setTimestamp(2, schedule);
											
											rs = ps.executeQuery();
											
											int counterUser = 0;
											
											if(rs.next()){
												counterUser += Integer.parseInt(rs.getString("count"));
											}
											
											rs.close();
											ps.close();
											
											if(counterUser == 0){
											
												query = "INSERT INTO appointments(user_id,doctor_id,booked_date,scheduled_date,status) VALUES ( ?, ?, now(), ?, ?) ";
												
												ps = conn.prepareStatement(query);
												
												ps.setInt(1, userId);
												ps.setInt(2, doctorId);
												ps.setTimestamp(3, schedule);
												ps.setString(4, status);
												
												ps.executeUpdate();
												ps.close();
												
												Database.close(conn);
												
												response.sendRedirect("../user/dashboard");
												return;
											}
											else{
												request.setAttribute("error", "You have another appointment at this time");
											}
											
										}
										else{
											
											request.setAttribute("error", "Entries already booked");
										}
									}
									else{
										
										request.setAttribute("error", "The doctor is not available at this time");
									}
								}
								else{
									
									request.setAttribute("error", "The date is not possible");
								}
								
								
							} catch (Exception e) {

								request.setAttribute("error", "Error connecting to database!");
								System.out.println("Runtime-log: " + e.getMessage());
							}
							
						}else{
							
							request.setAttribute("error", "Error connecting to database!");
						}
							
					}
					else{
						
						request.setAttribute("error", "Some fields are incorrect");					
					}
					
				}
		
				request.getRequestDispatcher("/JSP/Appointment/step2-appointment.jsp").forward(request, response);
				return;
			}
		}
		response.sendRedirect("../");
		return;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
