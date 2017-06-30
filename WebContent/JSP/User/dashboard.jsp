<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
    
<%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat,services.Database"
%>    

<%

	// Tell browser not to cache this page
	
	response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires", 0);

	if(session.getAttribute("email") == null || !session.getAttribute("type").toString().equals("user")){
		
		response.sendRedirect("../");
		return;
		
	}else{
		
		
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy - HH:mm");
		
		String email = session.getAttribute("email").toString();
		
		// Retrieve from database users data
		
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
				
				request.setAttribute("error", e.getMessage());
				
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
        <title>Dashboard</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/inner.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Lobster" rel="stylesheet">

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
                  <li class="active"><a href="./dashboard">
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
					
                  <li><a href="./notifications">
                    <span class="glyphicon glyphicon-bell"></span>
                    <span class="badge _navbar-not"><%= Integer.toString(newNotifications) %></span>
                  </a></li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                      <span class="glyphicon glyphicon-user"></span>
                      <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                      <li class="dropdown-header">Signed in as <br/><strong><%= first_name + " " + last_name %></strong></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="./settings">Settings</a></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="../signout">Sign out</a></li>
                    </ul>
                  </li>
                </ul>

              </div><!-- /.navbar-collapse -->
            </div>
          </div><!-- /.container-fluid -->
        </nav>
        
       	<%
       		// Update appointments
       		
       		query = "UPDATE appointments SET status = 'completed' WHERE scheduled_date <= NOW() AND status = 'pending' AND user_id = ?";
       		ps = conn.prepareStatement(query);
       		
       		ps.setInt(1, Integer.parseInt(userId));
       		ps.executeUpdate();
       		ps.close();
       	
       	%>

        <div class="_empty-space"></div>


        <div class="container _container">
          <div class="row">
            <div class="col-sm-4">
              <div class="list-group">
                <a href="#" class="list-group-item disabled">
                  Appointments
                  <button type="button" onclick="location.href = '../appointment/new';" class="btn btn-sm btn-success _book-app-button">
                    <i class="glyphicon glyphicon-plus"></i><strong> Book new appointment</strong>
                  </button>
                </a>
                
                <% 
                
                	int allApp = 0;
                	int pendingApp = 0;
                	int completedApp = 0;
                	int canceledApp = 0;
                	
                	// Pending appointments
                	
					query = "SELECT COUNT(*) FROM appointments WHERE user_id = ? AND status = 'pending'";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, Integer.parseInt(userId));
					
					rs = ps.executeQuery();
					
					if(rs.next()){
						
						pendingApp = Integer.parseInt(rs.getString(1));
						
					}
					
					rs.close();
					ps.close();
					
					// Completed appointments
					
					query = "SELECT COUNT(*) FROM appointments WHERE user_id = ? AND status = 'completed'";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, Integer.parseInt(userId));
					
					rs = ps.executeQuery();
					
					if(rs.next()){
						
						completedApp = Integer.parseInt(rs.getString(1));
						
					}
					
					rs.close();
					ps.close();
					
					// Canceled appointments
					
					query = "SELECT COUNT(*) FROM appointments WHERE user_id = ? AND status = 'canceled'";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, Integer.parseInt(userId));
					
					rs = ps.executeQuery();
					
					if(rs.next()){
						
						canceledApp = Integer.parseInt(rs.getString(1));
						
					}
					
					rs.close();
					ps.close();
					
					allApp = pendingApp + completedApp + canceledApp;
                
                
                %> 
                
                <a href="./dashboard" class="list-group-item">All <span class="badge"><%= allApp %></span></a>
                <a href="./dashboard?v=pending" class="list-group-item">Pending <span class="badge"><%= pendingApp %></span></a>
                <a href="./dashboard?v=completed" class="list-group-item">Completed <span class="badge"><%= completedApp %></span></a>
                <a href="./dashboard?v=canceled" class="list-group-item">Canceled <span class="badge"><%= canceledApp %></span></a>
              </div>
            </div>
            <div class="col-sm-8">
	
			<% 
				
			
				String view = request.getParameter("v");
			
				String count_query = null;
				int appCount = 0; // Number of appointments found
			
				if(view == null || (!view.equals("pending") && !view.equals("completed") && !view.equals("canceled"))){
					
					count_query = "SELECT COUNT(*) FROM appointments AS a WHERE a.user_id = ?";
					
					query = "SELECT CONCAT(d.first_name, ' ', d.last_name) AS full_name, a.appointment_id, a.booked_date, a.scheduled_date, a.status, a.review FROM appointments AS a JOIN doctors AS d ON d.doctor_id = a.doctor_id WHERE a.user_id = ? ORDER BY a.scheduled_date DESC";
					
				}else if(view.equals("pending")){
					
					count_query = "SELECT COUNT(*) FROM appointments AS a WHERE a.user_id = ? AND a.status = 'pending'";
					
					query = "SELECT CONCAT(d.first_name, ' ', d.last_name) AS full_name, a.appointment_id, a.booked_date, a.scheduled_date, a.status, a.review FROM appointments AS a JOIN doctors AS d ON d.doctor_id = a.doctor_id WHERE a.user_id = ? AND a.status='pending' ORDER BY a.scheduled_date DESC";
					
				}else if(view.equals("completed")){
					
					count_query = "SELECT COUNT(*) FROM appointments AS a WHERE a.user_id = ? AND a.status = 'completed'";
					
					query = "SELECT CONCAT(d.first_name, ' ', d.last_name) AS full_name, a.appointment_id, a.booked_date, a.scheduled_date, a.status, a.review FROM appointments AS a JOIN doctors AS d ON d.doctor_id = a.doctor_id WHERE a.user_id = ? AND a.status='completed' ORDER BY a.scheduled_date DESC";
					
				}else if(view.equals("canceled")){
					
					count_query = "SELECT COUNT(*) FROM appointments AS a WHERE a.user_id = ? AND a.status = 'canceled'";
					
					query = "SELECT CONCAT(d.first_name, ' ', d.last_name) AS full_name, a.appointment_id, a.booked_date, a.scheduled_date, a.status, a.review FROM appointments AS a JOIN doctors AS d ON d.doctor_id = a.doctor_id WHERE a.user_id = ? AND a.status='canceled' ORDER BY a.scheduled_date DESC";
					
				}
				
				// Retrive number of appointments from database
				
				ps = conn.prepareStatement(count_query);
				
				ps.setInt(1, Integer.parseInt(userId));
				
				rs = ps.executeQuery();
				
				if(rs.next()){
					
					appCount = Integer.parseInt(rs.getString(1));
					
				}
				
				rs.close();
				ps.close();
				
				if(appCount == 0){
				
				%>
				
				
				<div style="text-align: center;position: relative; top: 30px;">
				<span style="color: #bbb; font-size: 100px;" class="glyphicon glyphicon-eye-close"></span><br />
				<span style="font-weight: bold;color: #bbb; font-size: 40px;">No appointments found</span>
				</div>
				
				
				<%
				
				}
				
				// Retrive appointments from database
				
				
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, Integer.parseInt(userId));
				
				rs = ps.executeQuery();
				
				
				
				while(rs.next()){
					
					String status = null;
					String doctorsName = null;
					int appId = 0;
					Date scheduledDate = null;	
					Date bookedDate = null;
					Boolean isReviewed = null;
					
					doctorsName = rs.getString(1);
					appId = rs.getInt(2);
					bookedDate = rs.getTimestamp(3);
					scheduledDate = rs.getTimestamp(4);
					status = rs.getString(5);
					isReviewed = rs.getBoolean(6);
					
					Date now = new Date();
					
					int barProgress = (int)(100*(((double)(now.getTime() - bookedDate.getTime()) / (double)(scheduledDate.getTime() - bookedDate.getTime())))); // Calculate progressbar percentage
					
			
			%>
			
			<% if(status.equals("pending")){ %>
			
				<div class="panel panel-info">
	                <div class="panel-heading">
	                  <h3 class="panel-title">Pending</h3>
	                  <div class="progress _progress-bar">
	                    <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" style="width: <%= barProgress %>%">
	                    </div>
	                  </div>
	                </div>
	                
	                <div class="panel-body">
	                  <strong>Doctor's Name: </strong><a href=""><%= doctorsName %></a><br/>
	                  <strong>Date: </strong> <%= dateFormat.format(scheduledDate) %>
	                     
		          	<div class="btn-group _panel-btn-group" role="group">
		          		<form action="../appointment/cancel" method="POST">
			          		<input type="hidden" name="appointment_id" value="<%= appId %>"/>
		                    <button type="submit" name="cancel_submit" class="btn btn-danger btn-sm"><b>Cancel</b></button>
	                    </form>
	            	</div>
				
			<% }else if(status.equals("completed")){ %>
			
				
				 <div class="panel panel-success">
	                <div class="panel-heading">
	                  <h3 class="panel-title">Completed</h3>
	                </div>
	                
	                <div class="panel-body">
	                  <strong>Doctor's Name: </strong><a href=""><%= doctorsName %></a><br/>
	                  <strong>Date: </strong> <%= dateFormat.format(scheduledDate) %>
	                
	                
		        <%
		        	
		        	if(isReviewed){
		        		
		        %> 
		        
			        	<div class="btn-group _panel-btn-group" role="group">
		                    <button type="button" class="btn btn-default disabled">
		                      <strong>submitted <span class="glyphicon glyphicon-ok"></span></strong>
		                    </button>
	                  	</div>
		        
		        <% }else{ %>
		        	<form action="../appointment/review" class="_panel-btn-group" method="POST">
		        		<input type="hidden" name="appointment_id" value="<%= appId %>"/>
		        		<div class="btn-group" role="group">
		                    <button type="button" class="btn btn-default disabled">
		                      <strong>experience</strong>
		                    </button>
		                    <button type="submit" name="good_review" class="btn btn-default">
		                      <span class="glyphicon glyphicon-thumbs-up"></span>
		                      Good
		                    </button>
		                    <button type="submit" name="bad_review" class="btn btn-default">
		                      <span class="glyphicon glyphicon-thumbs-down"></span>
		                      Bad
		                    </button>
		                  </div>
		        	</form>
		        <% } %>       
	                
	        <% }else{ %>
	        
		        <div class="panel panel-danger">
	                <div class="panel-heading">
	                  <h3 class="panel-title">Canceled</h3>
	                </div>
	                
	            <div class="panel-body">
	                  <strong>Doctor's Name: </strong><a href=""><%= doctorsName %></a><br/>
	                  <strong>Date: </strong> <%= dateFormat.format(scheduledDate) %>    
	        
	        <% } %>     
	        
	       		</div>
              </div>
			
			<%
			
			
				} // End of while loop
				
				rs.close();
				ps.close();
			
			%>	

            </div>
          </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<% 
		Database.close(conn);	

	} 
	
%>








