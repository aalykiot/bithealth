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

	if(session.getAttribute("email") == null || !session.getAttribute("type").toString().equals("doctor")){
		
		response.sendRedirect("../");
		return;
		
	}else{
		
		
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy - HH:mm");
		
		String email = session.getAttribute("email").toString();
		
		// Retrieve from database doctors data
		
		Connection conn = Database.getConnection();
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		String query = null;
		
		String doctorId = null;
		String first_name = null;
		String last_name = null;
		
		if(conn != null){
			
			try{
			
			
				query = "SELECT doctor_id, first_name, last_name FROM doctors WHERE email = ? ";
				
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery(); // Execute query
				
				if(rs.next()){
					
					doctorId = Integer.toString(rs.getInt(1));
					first_name = rs.getString(2);
					last_name = rs.getString(3);
					
				}
				
				rs.close();
				ps.close();
			
			}catch(Exception e){
				
				request.setAttribute("error", e.getMessage());
				
			}
			
			
			
		}else{
			// Send doctor to an error page
		}
	
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="${pageContext.request.contextPath}/RESOURCES/img/favicon.ico" type="image/x-icon">
        <title>Notifications</title>
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
                  <li><a href="./dashboard">
                    <span class="glyphicon glyphicon-th-list"></span>
                  </a></li>
	
				<% 
				
					// Finding how many new notifications user has
					
					query = "SELECT COUNT(*) FROM notifications WHERE doctor_id = ? AND d_seen = false";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, Integer.parseInt(doctorId));
					
					rs = ps.executeQuery();
					
					int newNotifications = 0;
					
					if(rs.next()){
						
						newNotifications = rs.getInt(1);
						
					}
					
					rs.close();
					ps.close();
					
				
				%>	
					
                  <li class="active"><a href="./notifications">
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

        <div class="_empty-space"></div>


        <div class="container _container">
          <div class="row">
            <div class="col-sm-12">
              <ul class="nav nav-tabs">
                <li role="presentation" class="active"><a href="#">
                  <span class="glyphicon glyphicon-bell"></span>
                  Notifications
                </a></li>
              </ul>
            </div>
          </div>

          <div class="_empty-space-not"></div>

          <div class="row">
            <div class="col-sm-3">
              <ul class="nav nav-pills nav-stacked">
              
              <% 
              	
           		// Finding how many notifications user has
				
				query = "SELECT COUNT(*) FROM notifications WHERE doctor_id = ?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, Integer.parseInt(doctorId));
				
				rs = ps.executeQuery();
				
				int allNotifications = 0;
				
				if(rs.next()){
					
					allNotifications = rs.getInt(1);
					
				}
				
				rs.close();
				ps.close();
              
              %>
              	
              	<% if(request.getParameter("v") == null || !request.getParameter("v").equals("all")){ %>
              		
					<li role="presentation" class="active"><a href="./notifications">Unseen <span style="float: right;" class="badge"><%= newNotifications %></span></a></li>
                	<li role="presentation"><a href="./notifications?v=all">All notifications <span style="float: right;" class="badge"><%= allNotifications %></span></a></li>
					
              	<% }else{ %>
              	
              		<li role="presentation"><a href="./notifications">Unseen <span style="float: right;" class="badge"><%= newNotifications %></span></a></li>
                	<li role="presentation" class="active"><a href="./notifications?v=all">All notifications <span style="float: right;" class="badge"><%= allNotifications %></span></a></li>
              		
              	<% } %>
              	
              </ul>
            </div>
            <div class="col-sm-9">
            
            <% if(request.getParameter("v") == null || !request.getParameter("v").equals("all")){ %>
            	
            	<% if(newNotifications == 0){ %>
            		
            		<div class="well">
            			<center>
                			<span style="font-size: 50px;" class="glyphicon glyphicon-bell"></span>
                			<h3><strong>No new notifications.</strong></h3>
              			</center>
              		</div>
            		
            	<% }else{ %>
            		
            		<div class="well">
            		<div style="position:relative;top: 10px;">
            		
            		<% 
            		query = "SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name, a.scheduled_date, n.d_seen FROM notifications AS n JOIN users AS u ON u.user_id = n.user_id JOIN appointments AS a ON a.appointment_id = n.appointment_id WHERE n.doctor_id = ? AND n.d_seen = false ORDER BY n.notification_id DESC";
            		
            		ps = conn.prepareStatement(query);
            		ps.setInt(1, Integer.parseInt(doctorId));
            		
            		rs = ps.executeQuery();
            		
            		while(rs.next()){
            			
            			String usersName = null;
            			Date scheduledDate = null;
            			boolean seen = false;
            			
            			usersName = rs.getString(1);
            			scheduledDate = rs.getTimestamp(2);
            			seen = rs.getBoolean(3);
            			
            		%>
            		
            		    <div class="media _media-not">
		                  <div class="media-left">
		                      <span style="color: #428bca;" class="glyphicon glyphicon-asterisk"></span>
		                  </div>
		                  <div class="media-body">
		                    <p class="media-heading"> Patient <strong><a href="#"><%= usersName %></a></strong> canceled your appointment on <i><b><%= dateFormat.format(scheduledDate) %></b></i></p>
		                  </div>
		                </div>
            	
            		<% 	}
            			rs.close();
            			ps.close();
            		%>
            		</div>
            		</div>
            	
            	<% } %>
            
            <% }else{%>
            
            	<% if(allNotifications == 0){ %>
            		
            		<div class="well">
            			<center>
                			<span style="font-size: 50px;" class="glyphicon glyphicon-bell"></span>
                			<h3><strong>No notifications.</strong></h3>
              			</center>
              		</div>
            
            	<% }else{ %>
            		
            		<div class="well">
            		<div style="position:relative;top: 10px;">
            		
            		<% 
            		query ="SELECT CONCAT(u.first_name, ' ', u.last_name) AS full_name, a.scheduled_date, n.d_seen FROM notifications AS n JOIN users AS u ON u.user_id = n.user_id JOIN appointments AS a ON a.appointment_id = n.appointment_id WHERE n.doctor_id = ? ORDER BY n.notification_id DESC";
            		
            		ps = conn.prepareStatement(query);
            		ps.setInt(1, Integer.parseInt(doctorId));
            		
            		rs = ps.executeQuery();
            		
            		while(rs.next()){
            			
            			String usersName = null;
            			Date scheduledDate = null;
            			boolean seen = false;
            			
            			usersName= rs.getString(1);
            			scheduledDate = rs.getTimestamp(2);
            			seen = rs.getBoolean(3);
            			
            		%>
            		
            		    <div class="media _media-not">
		                  <div class="media-left">
		                  	<% if(seen){ %>
		                  		<span class="glyphicon glyphicon-asterisk"></span>
		                  	<% }else{ %>
		                  		<span style="color: #428bca;" class="glyphicon glyphicon-asterisk"></span>
		                  	<% } %>
		                  </div>
		                  <div class="media-body">
		                    <p class="media-heading"> Patient <strong><a href="#"><%= usersName %></a></strong> canceled your appointment on <i><b><%= dateFormat.format(scheduledDate) %></b></i></p>
		                  </div>
		                </div>
            	
            		<% }
            		rs.close();
            		ps.close();
            		
            		%>
            		</div>
            		</div>
            	
            	<% } %>
            	
            
            <% } %>
            
            <%
            	
           		// Update notifications set seen to true
            		
           		query = "UPDATE notifications SET d_seen = true WHERE doctor_id = ? AND d_seen = false";
	           	ps = conn.prepareStatement(query);
	        	ps.setInt(1, Integer.parseInt(doctorId));
	        		
	        	ps.executeUpdate();
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
	
	} %>