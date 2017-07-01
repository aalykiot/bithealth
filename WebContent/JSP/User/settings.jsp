<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,services.Database"
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
		
		
		String email = session.getAttribute("email").toString();
		
		// Retrieve from database users data
		
		Connection conn = Database.getConnection();
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		String query = null;
		
		String userId = null;
		String first_name = null;
		String last_name = null;
		long amka = 0;
		
		if(conn != null){
			
			try{
			
			
				query = "SELECT user_id, first_name, last_name, amka FROM users WHERE email = ? ";
				
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery(); // Execute query
				
				if(rs.next()){
					
					userId = Integer.toString(rs.getInt(1));
					first_name = rs.getString(2);
					last_name = rs.getString(3);
					amka = rs.getLong(4);
					
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
<%= request.getAttribute("error") %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Settings</title>
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
                  <li class="active dropdown">
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
                  <span class="glyphicon glyphicon-cog"></span>
                  Settings
                </a></li>
              </ul>
            </div>
          </div>

          <div class="_empty-space-not"></div>
          
          <div class="row">
            <div class="col-sm-3">
              <ul class="nav nav-pills nav-stacked">
                <li role="presentation" class="active"><a href="#">Details & Privacy</a></li>
              </ul>
            </div>
            
            <div class="col-sm-5">
            
            
              <form style = "border-right: 1px solid #D8D8D8;padding-right: 30px;" action="./settings" method="POST">
                <div class="form-group">
                  <label for="exampleInputEmail1">First Name</label>
                  <input type="text" name="first_name" autocomplete="off" class="form-control _settings-input" value="<%= first_name %>">
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">Last Name</label>
                  <input type="text" name="last_name" autocomplete="off" class="form-control _settings-input" value="<%= last_name %>">
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">Email</label>
                  <input type="email" name="email" autocomplete="off" class="form-control _settings-input" value="<%= email %>">
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">AMKA</label>
                  <input type="email" class="form-control _settings-input" value="<%= amka %>" readonly>
                </div>
                <button type="submit" name="update_settings" class="btn btn-md btn-success">Update settings</button>
              </form>
              
              <% 
              
              	// if success show success message
              
              	if(request.getAttribute("ua_success") != null){
              
              %>
              	<div class="alert alert-success" id="success-alert"><%= request.getAttribute("ua_success") %></div>
              
              <% } %>
              
              <% 
              
          		 // if error show error message
              
              	if(request.getAttribute("ua_error") != null){
              
              %>
              	<div class="alert alert-danger"><%= request.getAttribute("ua_error") %></div>
              
              <% } %>
              
            </div>
            
            

            <div class="col-sm-4">

              <form action="./settings" method="POST">
                <div class="form-group">
                  <label for="exampleInputEmail1">Old Password</label>
                  <input type="password" name="old_password" class="form-control _settings-input">
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">New Password</label>
                  <input type="password" name="new_password" class="form-control _settings-input">
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">Retype new password</label>
                  <input type="password" name="new_password_again" class="form-control _settings-input">
                </div>
                <button type="submit" name="update_password" class="btn btn-md btn-success">Update password</button>
              </form>
              
			  	<% 
              	
              		// if success show success message
              
              		if(request.getAttribute("up_success") != null){
              
              	%>
              		<div class="alert alert-success" id="success-alert"><%= request.getAttribute("up_success") %></div>
              
              	<% } %>
              
              	<% 
              
          		 	// if error show error message
              
              		if(request.getAttribute("up_error") != null){
              
              	%>
              		
              		<div class="alert alert-danger"><%= request.getAttribute("up_error") %></div>
              
              	<% } %>
				
            </div>

          </div>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
        
        <script>
        
        $("#success-alert").fadeTo(1500, 500).slideUp(500, function(){
            $("#success-alert").slideUp(500);
        });
        
        </script>
        
    </body>
</html>
<%
	
	Database.close(conn);

	}

%>