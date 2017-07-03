package doctor;

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

@WebServlet(name="Doctor_settings", urlPatterns={"/doctor/settings"})
public class Doctor_settings extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public Doctor_settings() {
        super();

    }
	
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if(request.getParameter("update_settings") != null){
			
			HttpSession authSession = request.getSession(false);
			
			if(authSession.getAttribute("email") == null || !authSession.getAttribute("type").toString().equals("doctor")){
				
				response.sendRedirect("../");
				return;
				
			}else{
			
				String firstName = request.getParameter("first_name");
				String lastName = request.getParameter("last_name");
				String email = request.getParameter("email");
	            String dayFrom = request.getParameter("dayFrom");
	            String dayTo = request.getParameter("dayTo");
	            String hourFrom = request.getParameter("hourFrom");
	            String hourTo = request.getParameter("hourTo");
				
				if(!firstName.isEmpty() && !lastName.isEmpty() && !email.isEmpty()){
					
					// Create connection to database
					
					Connection conn = Database.getConnection();
					
					if(conn != null){
						
						PreparedStatement ps = null;
						ResultSet rs = null;
						String query = null;
						
						try {
							
							// Check doctors table
							
							query = "SELECT COUNT(*) FROM doctors WHERE email = ? ";
							
							ps = conn.prepareStatement(query);
							
							ps.setString(1, email);
							
							rs = ps.executeQuery();
							
							int counter = 0;
							
							if(rs.next()){
								counter += Integer.parseInt(rs.getString("count"));
							}
							
							rs.close();
							ps.close();
							
							
							// Check users table
							
							query = "SELECT COUNT(*) FROM users WHERE email = ? ";
							
							ps = conn.prepareStatement(query);
							
							ps.setString(1, email);
							
							rs = ps.executeQuery();
							
							if(rs.next()){
								counter += Integer.parseInt(rs.getString("count"));
							}
							
							rs.close();
							ps.close();
							
							
							if(counter == 0 || email.equals(authSession.getAttribute("email"))){
								
								if(Integer.parseInt(dayFrom) < Integer.parseInt(dayTo) && Integer.parseInt(hourFrom) < Integer.parseInt(hourTo)){

									// Update doctors database
									
									query = "UPDATE doctors SET first_name = ?, last_name = ?, email = ?, day_from = ?, day_to = ?, hour_from = ?, hour_to = ?  WHERE email = ?";
	
									ps = conn.prepareStatement(query);
									
									ps.setString(1, firstName);
									ps.setString(2, lastName);
									ps.setString(3, email);							
									ps.setInt(4, Integer.parseInt(dayFrom));
									ps.setInt(5, Integer.parseInt(dayTo));
									ps.setInt(6, Integer.parseInt(hourFrom));
									ps.setInt(7, Integer.parseInt(hourTo));							
									ps.setString(8, authSession.getAttribute("email").toString());
									
									ps.executeUpdate();
									
									Database.close(conn);
									
									authSession.setAttribute("email", email); // change session for the new email
									
									request.setAttribute("ua_success", "Your account has been successfully updated");
									request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
									return;
								}
								else{
									
									Database.close(conn);
									
									request.setAttribute("ua_error", "Doctor availability is not correct");
									request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
									return;
									
								}
								
							}else{
								
								Database.close(conn);
								
								request.setAttribute("ua_error", "Email already exists!");
								request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
								return;
								
							}
							
							
							
						} catch (Exception e) {
							// show error
							System.out.println("Runtime-log: " + e.getMessage());
						}
						
					}else{
						
						request.setAttribute("ua_error", "Error connecting to database!");
						request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
						return;
						
					}
					
				}else{
					
					request.setAttribute("ua_error", "Some fields were empty!");
					request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
					return;
					
				}
				
				
			}
			
		}
		
		
		// Update password function
		
		if(request.getParameter("update_password") != null){
			
			HttpSession authSession = request.getSession(false);
			
			if(authSession.getAttribute("email") == null || !authSession.getAttribute("type").toString().equals("doctor")){
				
				response.sendRedirect("../");
				return;
				
			}else{
				
				String oldPassword = request.getParameter("old_password");
				String newPassword = request.getParameter("new_password");
				String newPasswordAgain = request.getParameter("new_password_again");
				
				
				if(!oldPassword.isEmpty() && !newPassword.isEmpty() && !newPasswordAgain.isEmpty()){
					
					if(newPassword.equals(newPasswordAgain)){
						
						Connection conn = Database.getConnection();
						
						if(conn != null){
						
							try{
								
								PreparedStatement ps = null;
								ResultSet rs = null;
								String query = null;
								
								query = "SELECT COUNT(*) FROM doctors WHERE email = ? AND password = ?";
								
								ps = conn.prepareStatement(query);
								
								ps.setString(1, authSession.getAttribute("email").toString());
								ps.setString(2, Encryption.hash(oldPassword)); // Hashing password
								
								rs = ps.executeQuery();
								
								int counter = 0;
								
								if(rs.next()){
									counter = Integer.parseInt(rs.getString(1));
								}
								
								rs.close();
								ps.close();
								
								if(counter > 0){
									
									// Update new password
									
									String newHashedPassword = Encryption.hash(newPassword);
									
									// Update users database
									
									query = "UPDATE doctors SET password = ? WHERE email = ?";

									ps = conn.prepareStatement(query);
									
									ps.setString(1, newHashedPassword);
									ps.setString(2, authSession.getAttribute("email").toString());
									
									ps.executeUpdate();
									
									Database.close(conn);
									
									
									request.setAttribute("up_success", "Your password has been successfully updated");
									request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
									return;
									
									
								}else{
									
									Database.close(conn);
									request.setAttribute("up_error", "Old password is incorrect!");
									request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
									return;
									
								}
								
							}catch(Exception e){
								// show error
								System.out.println("Runtime-log: " + e.getMessage());
							}
						
						}else{
							
							request.setAttribute("up_error", "Error connecting to database!");
							request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
							return;
							
						}
						
					}else{
						
						request.setAttribute("up_error", "Passwords don't match!");
						request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
						return;
						
					}
					
				}else{
					
					request.setAttribute("up_error", "Some fields are empty!");
					request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
					return;
					
				}
				
			}
			
		}
		
		
		
		
		request.getRequestDispatcher("/JSP/Doctor/settings.jsp").forward(request, response);
		return;
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}


