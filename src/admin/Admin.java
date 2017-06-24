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
public class Admin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Admin() {
        super();

    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.getRequestDispatcher("/JSP/Admin/admin.jsp").forward(request, response);
		
		
		if(request.getParameter("b1") != null ){
			String fName = request.getParameter("firstName");
            String lName = request.getParameter("lastName");
            String eml = request.getParameter("email");
            String pass = request.getParameter("password");
            String amka = request.getParameter("amka");
            String speciality = request.getParameter("speciality");
            String dayFrom=request.getParameter("dayFrom");
            String dayTo=request.getParameter("dayTo");
            String hourFrom=request.getParameter("hourFrom");
            String hourTo=request.getParameter("hourTo"); 
            
            if(!fName.isEmpty() && !lName.isEmpty() && !eml.isEmpty() && !pass.isEmpty() && !amka.isEmpty() && !speciality.isEmpty() && !dayFrom.isEmpty()  && !dayTo.isEmpty() && !hourFrom.isEmpty() && !hourTo.isEmpty()  ){
            	
            	Connection conn = Database.getConnection();
				
				if(conn != null){
					
					PreparedStatement ps = null;
					ResultSet rs = null;
					String query = null;
					
					try {
						
						// Check users table
						
						query = "INSERT INTO doctors VALUES(null,?,?,?,?,?,?,?,?,?,?,null,null)";
						ps = conn.prepareStatement(query);
						rs = ps.executeQuery();
						
						
						
						if(rs.next()){
							ps.setString(2, fName);
			 				ps.setString(3, lName);
			 				ps.setString(4, eml);
			 				ps.setString(5, pass);
			 				ps.setString(6, amka);
			 				ps.setString(7, speciality);
			 				ps.setString(8, dayFrom);
			 				ps.setString(9, dayTo);
			 				ps.setString(10, hourFrom);
			 				ps.setString(11, hourTo);
						}
						
						rs.close();
						ps.close();
						
						Database.close();
						
						
						
						request.setAttribute("ua_success", "You have successfully added a new doctor");
						request.getRequestDispatcher("/JSP/Admin/admin.jsp").forward(request, response);
						return;
						
						
						}catch (Exception e) {
							// show error
							response.getWriter().println(e.getMessage());
            }
			
		}else{
			request.setAttribute("ua_error", "Some fields were empty!");
			request.getRequestDispatcher("/JSP/Admin/admin.jsp").forward(request, response);
			return;
		}
		
		request.getRequestDispatcher("/JSP/Admin/admin.jsp").forward(request, response);
		return;
            }
		}
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
