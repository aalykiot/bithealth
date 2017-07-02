package other;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name="Signout", urlPatterns={"/signout"})

public class Signout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
    public Signout() {
        super();

    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession authSession = request.getSession(false);
		
		if(authSession != null){
			
				if(authSession.getAttribute("email") == null && authSession.getAttribute("username") == null){
					
					// Hmmmm that would be weird but we will handle it
					response.sendRedirect("./");
					return;
					
				}
				
				if(authSession.getAttribute("email") != null && authSession.getAttribute("username") != null){
					
					// User is logged in as patient/doctor and admin
					if(authSession.getAttribute("username") != null){
						
						// Remove attribute, do not invalidate the session
						authSession.removeAttribute("username");
						response.sendRedirect("./admin/login");
						return;
						
					}else{
						
						// Remove attribute not invalidate the session
						authSession.removeAttribute("email");
						response.sendRedirect("./");
						return;
						
					}
					
				}else{
					
					if(authSession.getAttribute("username") != null){
						
						// Invalidate admin session
						authSession.invalidate();
						response.sendRedirect("./admin/login");
						return;
						
					}else{
						
						// Invalidate user or doctor session
						authSession.invalidate();
						response.sendRedirect("./");
						return;
						
					}
					
				}
				
			
		}else{
			
			// Visitor has no authSession send him to welcome page
			response.sendRedirect("./");
			return;
			
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}