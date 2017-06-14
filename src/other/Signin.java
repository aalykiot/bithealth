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

@WebServlet(name="Signin", urlPatterns={"/signin"})
public class Signin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Signin() {
        super();

    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		if(request.getParameter("submit") != null){
			
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			
			if(!email.isEmpty() && !password.isEmpty()){
				
				// Start signin proccess
				
				Connection conn = Database.getConnection();
				
				if(conn != null){
					
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
					
					int counter = 0;
					
					try{
						
						// Hashing the password
						
						String hashedPassword = Encryption.hash(password);
						
						// Checking users table
						
						query = "SELECT COUNT(*) FROM users WHERE email = ? AND password = ?";
						
						ps = conn.prepareStatement(query);
						
						ps.setString(1, email);
						ps.setString(2, hashedPassword);
						
						rs = ps.executeQuery();
						
						if(rs.next()){
							counter = Integer.parseInt(rs.getString("count"));
						}
						
						if(counter == 1){
							
							// User found in users table
							HttpSession authSession = request.getSession();
							authSession.setAttribute("email", email);
							authSession.setAttribute("type", "user");
							response.sendRedirect("./user/dashboard");
							
						}else{
							
							// Search doctors table
							
							query = "SELECT COUNT(*) FROM doctors WHERE email = ? AND password = ?";
							
							ps = conn.prepareStatement(query);
							
							ps.setString(1, email);
							ps.setString(2, hashedPassword);
							
							rs = ps.executeQuery();
							
							if(rs.next()){
								counter = Integer.parseInt(rs.getString("count"));
							}
							
							if(counter == 1){
								
								// User found in doctors table
								HttpSession authSession = request.getSession();
								authSession.setAttribute("email", email);
								authSession.setAttribute("type", "doctor");
								response.sendRedirect("./doctor/dashboard");
								
							}else{
								
								// User doesn't exist in database
								
								request.setAttribute("error", "User or Doctor doesn't exists!");
								request.getRequestDispatcher("/JSP/Other/signin.jsp").forward(request, response);
								
							}
							
						}
						
						
						
					}catch(Exception e){
						response.getWriter().println(e.getMessage());
					}
					
				}else{
				
					request.setAttribute("error", "Error connecting to database!");
					request.getRequestDispatcher("/JSP/Other/signin.jsp").forward(request, response);
					
				}
				
			}else{
				
				request.setAttribute("error", "Some fields are empty!");
				request.getRequestDispatcher("/JSP/Other/signin.jsp").forward(request, response);
				
			}
			
		}else{
		
			request.getRequestDispatcher("/JSP/Other/signin.jsp").forward(request, response);
			
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
