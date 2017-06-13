package other;


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



@WebServlet(name="Welcome", urlPatterns={""})
public class Index extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public Index() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if(request.getParameter("submit") != null){
			
			// Signup proccess starts
			
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String amka = request.getParameter("amka");
			
			if(!firstName.isEmpty() && !lastName.isEmpty() && !email.isEmpty() && !password.isEmpty() && !amka.isEmpty()){
				
				if(amka.length() > 10){
					
					// Create connection to database
					
					Connection conn = Database.getConnection();
					
					if(conn != null){
						
						PreparedStatement ps = null;
						ResultSet rs = null;
						String query = null;
						
						try {
							
							// Check users table
							
							query = "SELECT COUNT(*) FROM users WHERE email = ? OR amka::varchar = ?";
							
							ps = conn.prepareStatement(query);
							
							ps.setString(1, email);
							ps.setString(2, amka); // let the jdbc driver convert it to bing int
							
							rs = ps.executeQuery();
							
							int counter = 0;
							
							if(rs.next()){
								counter += Integer.parseInt(rs.getString("count"));
							}
							
							
							// Check doctors table
							
							query = "SELECT COUNT(*) FROM doctors WHERE email = ? OR amka::varchar = ?";
							
							ps = conn.prepareStatement(query);
							
							ps.setString(1, email);
							ps.setString(2, amka); // let the jdbc driver convert it to bing int
							
							rs = ps.executeQuery();
							
							if(rs.next()){
								counter += Integer.parseInt(rs.getString("count"));
							}
							
							
							if(counter == 0){
								
								// Encrypt users password
								
								String hashedPassword = Encryption.hash(password);
								
								
								query = "INSERT INTO users (first_name, last_name, email, password, amka) VALUES ( ?, ?, ?, ?, ?)";
								
								ps = conn.prepareStatement(query);
								
								ps.setString(1, firstName);
								ps.setString(2, lastName);
								ps.setString(3, email);
								ps.setString(4, hashedPassword);
								ps.setLong(5, Long.parseLong(amka));
								
								ps.executeUpdate();
								
								// Create new user session
								
								HttpSession authSession = request.getSession();
								authSession.setAttribute("email", email);
								authSession.setAttribute("type", "user");
								
								// Redirect user to dashboard
								
								response.sendRedirect("./User/Dashboard");
								
								
							}else{
								
								request.setAttribute("error", "Email or AMKA already exists!");
								request.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
								
							}
							
							
							
						} catch (Exception e) {
							// show error
							response.getWriter().println(e.getMessage());
						}
						
					}else{
						
						request.setAttribute("error", "Error connecting to database!");
						request.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
						
					}
					
				}else{
					request.setAttribute("error", "Your AMKA is incorrect!");
					request.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
				}
				
				
			}else{
				
				request.setAttribute("error", "Some fields are empty!");
				request.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
				
			}
			
			
		}else{
			
			request.getRequestDispatcher("/JSP/index.jsp").forward(request, response);
			
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
