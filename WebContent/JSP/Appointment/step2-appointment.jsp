<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat,services.Database,java.time.DayOfWeek"
%> 
    
    
    <%
    
	// Tell browser not to cache this page
	
	response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires", 0);
    
	if(session.getAttribute("email") == null){
		
		response.sendRedirect("../");
		return;
		
	}else{
		
		if(session.getAttribute("type").toString().equals("user")){
		
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy - HH:mm");
		
		String email = session.getAttribute("email").toString();
		String searchQuery = request.getAttribute("requested_doctor").toString();
		String searchDay = request.getParameter("search_day");
		String searchMonth = request.getParameter("search_month");
		String searchYear = request.getParameter("search_year");
		String searchHour = request.getParameter("search_hour");
		
		if(searchQuery != null){
			searchQuery = searchQuery.trim(); // If requested_doctor isn't null trim extra white spaces
		}else{
			searchQuery = "";
		}
	
		Connection conn = Database.getConnection();
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		String query = null;
		
		String userId = null;
		String first_name = null;
		String last_name = null;
		
		if(conn != null){
			
			try{
			
			
				query = "SELECT user_id, first_name, last_name FROM users WHERE email = ? ";
				
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery(); // Execute query
				
				if(rs.next()){
					
					userId = Integer.toString(rs.getInt(1));
					first_name = rs.getString(2);
					last_name = rs.getString(3);
					
				}
				
				rs.close();
				ps.close();
			
			}catch(Exception e){
				
				System.out.println("Runtime-log: " + e.getMessage());				
			}
			
			
			
		}else{
			// Send user to an error page
		}
%>
    
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Book appointment</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/inner.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Lobster" rel="stylesheet">

        <!-- Special version of Bootstrap that only affects content wrapped in .bootstrap-iso -->
        <link rel="stylesheet" href="https://formden.com/static/cdn/bootstrap-iso.css" />

        <!--Font Awesome (added because you use icons in your prepend/append)-->
        <link rel="stylesheet" href="https://formden.com/static/cdn/font-awesome/4.4.0/css/font-awesome.min.css" />


    </head>
    <body>

		<nav class="navbar navbar-inverse navbar-fixed-top _navbar">
        <div class="container-fluid">
          <div class="container _container">

              <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                  <span class="sr-only">Toggle navigation</span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                  <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand _brand" href="../" style="color:#fff;">
                  <span class="glyphicon glyphicon-plus _nav-glyphicon"></span>BitHealth
                </a>
              </div>

              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

                <form class="navbar-form form-inline navbar-left" action="../search" method="GET">
                    <span class="glyphicon glyphicon-search _search-glyphicon" style="color:#fff;"></span>
                    <input type="text" class="form-control _search-input" autocomplete="off" name="search_query" placeholder="Search doctors...">
                </form>


                <ul class="nav navbar-nav navbar-right">
                  <li><a href="../user/dashboard">
                    <span class="glyphicon glyphicon-th-list"></span>
                  </a></li>
	
				<% 
				
					// Finding how many new notifications user has
					
					query = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND seen = false";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, Integer.parseInt(userId));
					
					rs = ps.executeQuery();
					
					int newNotifications = 0;
					
					if(rs.next()){
						
						newNotifications = rs.getInt(1);
						
					}
					
					rs.close();
					ps.close();
					
				
				%>	
					
                  <li><a href="../user/notifications">
                    <span class="glyphicon glyphicon-bell" id="newNotElement"></span>
                    <span class="badge _navbar-not"><%= Integer.toString(newNotifications) %></span>
                  </a></li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                      <span class="glyphicon glyphicon-user"></span>
                      <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                      <li class="dropdown-header">Signed in as <br/><strong><%= first_name + " " + last_name %></strong></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="../user/settings">Settings</a></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="../signout">Sign out</a></li>
                    </ul>
                  </li>
                </ul>

              </div><!-- /.navbar-collapse -->
            </div>
          </div><!-- /.container-fluid -->
        </nav>

        <div class="_empty-space"></div>


        <div class="container _container">
          <div class="row">

            <div class="col-sm-4">

              <div class="list-group">
              <span class="list-group-item">

                <div class="media">
                  <div class="media-left">
                      <span style="font-size: 30px;" class="glyphicon glyphicon-user"></span>
                  </div>
                  <div class="media-body">
                    <h4 class="media-heading"><strong>Step 1</strong></h4>
                    Choose your doctor
                  </div>
                </div>

              </span>
              <span class="list-group-item active">
                <div class="media">
                  <div class="media-left">
                      <span style="font-size: 30px;" class="glyphicon glyphicon-calendar"></span>
                  </div>
                  <div class="media-body">
                    <h4 class="media-heading"><strong>Step 2</strong></h4>
                    Choose date
                  </div>
                </div>
              </span>
            </div>

            </div>

            <div class="col-sm-8">

              <center>
              
              <%
              	int doctorId = Integer.parseInt(request.getParameter("requested_doctor"));
                           	
				int dayFrom = 0;
				int dayTo = 0;
				int hourFrom= 0;
				int hourTo = 0;
				
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
				
				DayOfWeek dayFromWeek = DayOfWeek.of(dayFrom);
				DayOfWeek dayToWeek = DayOfWeek.of(dayTo);
              
              %>
              
              <div class="panel panel-default">
				<div class="panel-body">
				Doctors available appointments:  <b><%= dayFromWeek %></b> - <b><%= dayToWeek %></b> | <b><%= hourFrom %>:00</b> - <b><%= hourTo %>:00</b>
				</div>
			   </div>

              <form class="form-inline well" action="./new" method="POST">

                  <select class="form-control" name="search_day" >
                    <option selected value='-1'>--Select Day--</option>
                    <option value='1'>1</option>
                    <option value='2'>2</option>
                    <option value='3'>3</option>
                    <option value='4'>4</option>
                    <option value='5'>5</option>
                    <option value='6'>6</option>
                    <option value='7'>7</option>
                    <option value='8'>8</option>
                    <option value='9'>9</option>
                    <option value='10'>10</option>
                    <option value='11'>11</option>
                    <option value='12'>12</option>
                    <option value='13'>13</option>
                    <option value='14'>14</option>
                    <option value='15'>15</option>
                    <option value='16'>16</option>
                    <option value='17'>17</option>
                    <option value='18'>18</option>
                    <option value='19'>19</option>
                    <option value='20'>20</option>
                    <option value='21'>21</option>
                    <option value='22'>22</option>
                    <option value='23'>23</option>
                    <option value='24'>24</option>
                    <option value='25'>25</option>
                    <option value='26'>26</option>
                    <option value='27'>27</option>
                    <option value='28'>28</option>
                    <option value='29'>29</option>
                    <option value='30'>30</option>
                  </select>

                  <select class="form-control" name="search_month">
                    <option selected value='-1'>--Select Month--</option>
                    <option value='1'>Janaury</option>
                    <option value='2'>February</option>
                    <option value='3'>March</option>
                    <option value='4'>April</option>
                    <option value='5'>May</option>
                    <option value='6'>June</option>
                    <option value='7'>July</option>
                    <option value='8'>August</option>
                    <option value='9'>September</option>
                    <option value='10'>October</option>
                    <option value='11'>November</option>
                    <option value='12'>December</option>
                  </select>

                  <select class="form-control" name="search_year">
                    <option selected value='-1'>--Select Year--</option>
                    <option value='2017'>2017</option>
                  </select>

                  <select class="form-control" name="search_hour">
                    <option selected value='-1'>--Select Hour--</option>
                    <option value='9'>9:00 - 10:00</option>
                    <option value='10'>10:00 - 11:00</option>
                    <option value='11'>11:00 - 12:00</option>
                    <option value='12'>12:00 - 13:00</option>
                    <option value='13'>13:00 - 14:00</option>
                    <option value='14'>14:00 - 15:00</option>
                    <option value='15'>15:00 - 16:00</option>
                    <option value='16'>16:00 - 17:00</option>
                    <option value='17'>17:00 - 18:00</option>
                    <option value='18'>18:00 - 19:00</option>
                  </select>

                  <div style="height: 10px;"></div>
                <button type="submit" class="btn btn-success" name="submit">Book appointment</button>
                 <input type="hidden" name="requested_doctor" value= <%=searchQuery%>>
              </form>
            </center>


		<%
		
		if(request.getAttribute("error") != null ){
			
			%>
			
			<div class="alert alert-danger"><%= request.getAttribute("error") %></div>
			
			<%
		}

		try{
			query = "SELECT CONCAT(first_name, ' ', last_name) AS full_name from doctors WHERE doctor_id = ?";
			
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, Integer.parseInt(searchQuery) );
			
			rs = ps.executeQuery();
	
			String doctorName = null;
			
			if(rs.next()){
				
				doctorName = rs.getString(1);
			}
			else{
				
				request.getRequestDispatcher("/JSP/Appointment/step1-appointment.jsp").forward(request, response);
			}
			
			query = "SELECT COUNT(*) FROM appointments WHERE doctor_id = ? AND status = 'pending'";
			
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, doctorId);
			
			rs = ps.executeQuery();
			
			int counter = 0;
			
			if(rs.next()){
				counter += Integer.parseInt(rs.getString("count"));
			}
			
			rs.close();
			ps.close();
			
			query = "SELECT scheduled_date FROM appointments WHERE doctor_id = ? AND status = 'pending' ORDER BY scheduled_date";
			
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, Integer.parseInt(searchQuery) );
			
			rs = ps.executeQuery();

			
		if(counter != 0){
		%>
	              <div class="panel panel-default">

                <div class="panel-heading"><strong>Dr. <%= doctorName %>  </strong> booked dates</div>
                <table class="table">
                  
		<%	}		
			
			while(rs.next()){
				
				Date scheduled_date = rs.getTimestamp(1);

	
		%>
				<tr>
                    <td>
                      <%= dateFormat.format(scheduled_date) %>  
                      <span style="float:right;padding: 5px;" class="label label-danger">Booked</span>
                    </td>
				</tr>

        <% } %>
        
        <% if(counter != 0){ %>
        	                  
                </table>
              </div>
              
        <% } %>      

            </div>

        </div>
        	<%
        		
        		rs.close();
        		ps.close();
        		
        		
        		}catch(Exception e){
        			
        			System.out.println("Runtime-log: " + e.getMessage());
        		}
        
        %>   
        


        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <% if(newNotifications > 0){ %>
        
        	<script src="${pageContext.request.contextPath}/RESOURCES/js/bell-icon-flickering.js"></script>
        
        <% } %>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<%
	Database.close(conn);
	}
	else{
		response.sendRedirect("../");
		return;
	}
}
%>
