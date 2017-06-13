package services;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name="Signout", urlPatterns={"/Signout"})

public class Signout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
    public Signout() {
        super();

    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession authSession = request.getSession(false);
		
		if(authSession.getAttribute("email") != null){
			// Invalidate session
			authSession.invalidate();
			response.sendRedirect("./Welcome");
			return;
			
		}else{
			// Visitor has no authSession send him to welcome page
			response.sendRedirect("./Welcome");
		}
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		doGet(request, response);
	}

}
