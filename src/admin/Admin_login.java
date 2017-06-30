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

@WebServlet(name="Admin_login", urlPatterns={"/admin/login"})
public class Admin_login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Admin_login() {
        super();

    }


protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		if(request.getParameter("submit") != null){
			
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			if(!username.isEmpty() && !password.isEmpty()){
				
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
						
						query = "SELECT COUNT(*) FROM admins WHERE username = ? AND password = ?";
						
						ps = conn.prepareStatement(query);
						
						ps.setString(1, username);
						ps.setString(2, hashedPassword);
						
						rs = ps.executeQuery();
						
						if(rs.next()){
							counter = Integer.parseInt(rs.getString("count"));
						}
						
						rs.close();
						ps.close();
						
						if(counter == 1){
							
							Database.close(conn);
							
							// Admin found in admins table
							HttpSession authSession = request.getSession();
							authSession.setAttribute("usename", username);
							authSession.setAttribute("type", "admin");
							response.sendRedirect("./dashboard");
							return;
											
						}else{
							
							// Admin doesn't exist in database
							
							Database.close(conn);
							
							request.setAttribute("error", "Admin doesn't exists!");
							request.getRequestDispatcher("/JSP/Admin/login.jsp").forward(request, response);
							return;
							
						}				
						
					}catch(Exception e){
						response.getWriter().println(e.getMessage());
					}
					
				}else{
				
					request.setAttribute("error", "Error connecting to database!");
					request.getRequestDispatcher("/JSP/Admin/login.jsp").forward(request, response);
					return;
					
				}
				
			}else{
				
				request.setAttribute("error", "Some fields are empty!");
				request.getRequestDispatcher("/JSP/Admin/login.jsp").forward(request, response);
				return;
				
			}
			
		}else{
		
			request.getRequestDispatcher("/JSP/Admin/login.jsp").forward(request, response);
			return;
			
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
