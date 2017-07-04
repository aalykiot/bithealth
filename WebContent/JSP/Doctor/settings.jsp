<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
   
<%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,services.Database,java.util.Calendar"
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
		
		
		String email = session.getAttribute("email").toString();
		
		// Retrieve from database users data
		
		Connection conn = Database.getConnection();
		
		PreparedStatement ps = null;
		ResultSet rs = null;
		String query = null;
		
		String doctorId = null;
		String first_name = null;
		String last_name = null;
		String speciality = null;
		long amka = 0;
		
		if(conn != null){
			
			try{
			
			
				query = "SELECT doctor_id, first_name, last_name, amka, speciality FROM doctors WHERE email = ? ";
				
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery(); // Execute query
				
				if(rs.next()){
					
					doctorId = Integer.toString(rs.getInt(1));
					first_name = rs.getString(2);
					last_name = rs.getString(3);
					amka = rs.getLong(4);
					speciality = rs.getString(5);
					
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
        <link rel="icon" href="${pageContext.request.contextPath}/RESOURCES/img/favicon.ico" type="image/x-icon">
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
                    <input type="text" class="form-control _search-input" name="search_query" placeholder="Search doctors...">
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
					
                  <li><a href="./notifications">
                    <span class="glyphicon glyphicon-bell" id="newNotElement"></span>
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
        
              <% 
              
              	// if success show success message
              
              	if(request.getAttribute("success") != null){
              
              %>
              	
            	<div class="alert alert-success _alert" id="alert-box">
	        		<div class="container _container">
	        			<%= request.getAttribute("success") %>
	        			<a href="#"><span class="glyphicon glyphicon-remove" id="alert-box-cancel" style="float: right;opacity: 0.3;color: #333;"></span></a>
	        		</div>
        		</div>
              
              <% } %>
              
              <% 
              
          		// if error show error message
              
              	if(request.getAttribute("error") != null){
              
              %>
              
            	<div class="alert alert-danger _alert" id="alert-box">
	        		<div class="container _container">
	        			<%= request.getAttribute("error") %>
	        			<a href="#"><span class="glyphicon glyphicon-remove" id="alert-box-cancel" style="float: right;opacity: 0.3;color: #333;"></span></a>
	        		</div>
        		</div>
              
              <% } %>

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
                  <input type="text" class="form-control _settings-input" value="<%= amka %>" readonly>
                </div>
                <div class="form-group">
                  <label for="exampleInputEmail1">Speciality</label>
                  <input type="email" class="form-control _settings-input" value="<%= speciality %>" readonly>
                </div>
                
                   <% 
                                      
                    String dayFrom = null;
                	String dayTo = null;
                	String hourFrom = null;
                	String hourTo = null;
                    try{
						query = "SELECT day_from, day_to, hour_from, hour_to FROM doctors WHERE doctor_id = ? ";
					
						ps = conn.prepareStatement(query);
						
						ps.setInt(1, Integer.parseInt(doctorId) );
						
						rs = ps.executeQuery();
						
						if(rs.next()){
						
						dayFrom = rs.getString(1);
						dayTo = rs.getString(2);
						hourFrom = rs.getString(3);
						hourTo = rs.getString(4);
				
						}
						
					}catch(Exception e){
	        			request.setAttribute("debug", e.getMessage());
	        		}
                    
                   
                    dayFrom = dayOfWeek(dayFrom);
                    dayTo = dayOfWeek(dayTo);

        			%>
        			
        			<%! 
					   public String dayOfWeek(String day) { 
					      
                        if(day.equals("1")){
                        	return "Monday";
                        }
                        else if(day.equals("2")){
                        	return "Tuesday";
                        }
                        else if(day.equals("3")){
                        	return "Wednesday";
   						}
                        else if(day.equals("4")){
                        	return "Thrusday";
                        }
                        else if(day.equals("5")){
                        	return "Friday";
                        }
                        return null;
                        
					   } 
					%>
        			
        			
                 <div class="form-group"> 
                 <label for="exampleInputEmail1">Available from</label> 
                 <select  class="form-control" name ="dayFrom">
                 
                    
                   <% 
                 	
        	     	String[] dayArray = {"Monday","Tuesday","Wednesday", "Thursday", "Friday"};
                 	
                 	for(int i=0; i < 5; i++){
                 	
                 	%>
                 	
                 	<% if(dayFrom == dayArray[i] ){ %>
                 		
                 	<option selected value=<%= i+1 %> > <%= dayArray[i] %></option>
                 	
                 	<% }else{ %>
                 		
                 	<option value=<%= i+1 %> > <%= dayArray[i] %></option>
                 		
                 	<% } %>
                 	
                 	<% } %>
                 	
                  </select> 
                </div> 
                <div class="form-group"> 
                  <label for="exampleInputEmail1">Available to</label> 
                  <select  class="form-control" name ="dayTo">
                  
                   <% 
                 	
                 	for(int i=0; i < 5; i++){
                 	
                 	%>
                 	
                 	<% if(dayTo == dayArray[i] ){ %>
                 		
                 	<option selected value=<%= i+1 %> > <%= dayArray[i] %></option>
                 	
                 	<% }else{ %>
                 		
                 	<option value=<%= i+1 %> > <%= dayArray[i] %></option>
                 		
                 	<% } %>
                 	
                 	<% } %>
                  </select> 
                </div> 
                <div class="form-group"> 
                  <label for="exampleInputEmail1">Available from</label> 
                  <select  class="form-control" name ="hourFrom">
                        	                 	
                    <option selected value='-1'>--Select Hour--</option> 
                    
                    <% 
        	     	String[] hourArray = {"9","10","11","12","13","14","15","16","17","18","19"};
                    
                 	for(int i=0; i < 11; i++){
                 	
                 	%>
                 	
                 	<% if(hourFrom.equals(hourArray[i]) ){ %>
                 		
                 	<option selected value=<%= i+9 %> > <%= hourArray[i] %>:00</option>
                 	
                 	<% }else{ %>
                 		
                 	<option value=<%= i+9 %> > <%= hourArray[i] %>:00</option>
                 		
                 	<% } %>
                 	
                 	<% } %>
                 	
                 
                  </select> 
                </div> 
                <div class="form-group"> 
                  <label for="exampleInputEmail1">Available to</label> 
                  <select  class="form-control" name ="hourTo">
                    <option selected value='-1'>--Select Hour--</option> 
                    
                    <% 
                    
                 	for(int i=0; i < 11; i++){
                 	
                 	%>
                 	
                 	<% if(hourTo.equals(hourArray[i]) ){ %>
                 		
                 	<option selected value=<%= i+9 %> > <%= hourArray[i] %>:00</option>
                 	
                 	<% }else{ %>
                 		
                 	<option value=<%= i+9 %> > <%= hourArray[i] %>:00</option>
                 		
                 	<% } %>
                 	
                 	<% } %>
                  </select> 
                </div> 
                <button type="submit" name="update_settings" class="btn btn-md btn-success">Update settings</button>
              </form>

              
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
              
				
            </div>

          </div>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <% if(newNotifications > 0){ %>
        
        	<script src="${pageContext.request.contextPath}/RESOURCES/js/bell-icon-flickering.js"></script>
        
        <% } %>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
        
        <script>
        
        $("#alert-box-cancel").click(function(){
        	
            $("#alert-box").slideUp(500);
            
    });
        
        </script>
        
    </body>
</html>
<%
	
	Database.close(conn);

	}

%>