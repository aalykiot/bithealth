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

	if(session.getAttribute("email") == null){
		
		response.sendRedirect("./");
		return;
		
	}else{
		
		if(session.getAttribute("type").toString().equals("user") || session.getAttribute("type").toString().equals("doctor")){
			
			String email = session.getAttribute("email").toString();

			String searchQuery = request.getParameter("search_query");
			
			if(searchQuery != null){
				searchQuery = searchQuery.trim(); // If search_query isn't null trim extra white spaces
			}else{
				searchQuery = "";
			}
		
			Connection conn = Database.getConnection();
			
			PreparedStatement ps = null;
			ResultSet rs = null;
			String query = null;
			
			String sId = null;
			String first_name = null;
			String last_name = null;
			
			if(conn != null){
				
				try{
					
					if(session.getAttribute("type").toString().equals("user")){
						
						query = "SELECT user_id, first_name, last_name FROM users WHERE email = ? ";
						
					}else{
						
						query = "SELECT doctor_id, first_name, last_name FROM doctors WHERE email = ? ";
						
					}
					
					ps = conn.prepareStatement(query);
					ps.setString(1, email);
					
					rs = ps.executeQuery(); // Execute query
					
					if(rs.next()){
						
						sId = Integer.toString(rs.getInt(1));
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
	        <link rel="icon" href="${pageContext.request.contextPath}/RESOURCES/img/favicon.ico" type="image/x-icon">
	        <title>Search</title>
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
	                <a class="navbar-brand _brand" href="./" style="color:#fff;">
	                  <span class="glyphicon glyphicon-plus _nav-glyphicon"></span>BitHealth
	                </a>
	              </div>

	              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

	                <form class="navbar-form form-inline navbar-left" action="./search" method="GET">
	                    <span class="glyphicon glyphicon-search _search-glyphicon" style="color:#fff;"></span>
	                    <input type="text" class="form-control _search-input" name="search_query" autocomplete="off" placeholder="Search doctors...">
	                </form>


	                <ul class="nav navbar-nav navbar-right">
	                  <li><a href="./<%= session.getAttribute("type") %>/dashboard">
	                    <span class="glyphicon glyphicon-th-list"></span>
	                  </a></li>
		
					<% 
					
						// Finding how many new notifications
						
						if(session.getAttribute("type").toString().equals("user")){
							
							query = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND seen = false";
							
						}else{
							
							query = "SELECT COUNT(*) FROM notifications WHERE doctor_id = ? AND seen = false";
							
						}
						
						ps = conn.prepareStatement(query);
						
						ps.setInt(1, Integer.parseInt(sId));
						
						rs = ps.executeQuery();
						
						int newNotifications = 0;
						
						if(rs.next()){
							
							newNotifications = rs.getInt(1);
							
						}
						
						rs.close();
						ps.close();
						
					
					%>	
						
	                  <li><a href="./<%= session.getAttribute("type") %>/notifications">
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
	                      <li><a href="./<%= session.getAttribute("type") %>/settings">Settings</a></li>
	                      <li role="separator" class="divider"></li>
	                      <li><a href="./signout">Sign out</a></li>
	                    </ul>
	                  </li>
	                </ul>

	              </div><!-- /.navbar-collapse -->
	            </div>
	          </div><!-- /.container-fluid -->
	        </nav>

	        <div class="_empty-space"></div>
	        <div class="container _container">
	        
	        
	        <%
	        
	        	if(!searchQuery.isEmpty()){
	        		
	        		try{
	        		
	        		query = "SELECT COUNT(*) FROM doctors WHERE CONCAT(first_name, ' ', last_name) ILIKE ? OR CONCAT(last_name, ' ', first_name) ILIKE ?";
	        		
	        		
	        		ps = conn.prepareStatement(query);
	        		
	        		ps.setString(1, "%" + searchQuery + "%");
	        		ps.setString(2, "%" + searchQuery + "%");
	        		
	        		
	        		rs = ps.executeQuery();
	        		
	        		int results = 0;
	        		
	        		if(rs.next()){
	        			results = Integer.parseInt(rs.getString(1));
	        		}
	        		
	        		rs.close();
	        		ps.close();
	        		
	        %>
	        
	        
	        <% if(results == 0){ %>
	        		<div class="row">
	        		<div style="text-align: center;position: relative; top: 30px;">
					<span style="color: #bbb; font-size: 100px;" class="glyphicon glyphicon-search"></span><br />
					<span style="font-weight: bold;color: #bbb; font-size: 40px;">No results found</span>
					</div>
	        
	        <% }else{ %>
	        		<span><b><%= results %></b> result(s) found for <b><i><%= searchQuery %></i></b></span><hr>
	        		<div class="row">
	        <%		
	        		}
	        
	        		query = "SELECT doctor_id, CONCAT(first_name, ' ', last_name) AS full_name, good_review, bad_review FROM doctors WHERE CONCAT(first_name, ' ', last_name) ILIKE ? OR CONCAT(last_name, ' ', first_name) ILIKE ?";
			
			
					ps = conn.prepareStatement(query);
					
					ps.setString(1, "%" + searchQuery + "%");
					ps.setString(2, "%" + searchQuery + "%");
					
					
					rs = ps.executeQuery();
	        
	        		
	        		
	        		while(rs.next()){
	        			
	        			String doctorId = Integer.toString(rs.getInt(1));
	        			String fullName = rs.getString(2);
	        			String goodReview = Integer.toString(rs.getInt(3));
	        			String badReview = Integer.toString(rs.getInt(4));
	        		
	        		
	        %>
	        
	        <% if(session.getAttribute("type").toString().equals("user")){ %>
	        
	        	<a href="<%="./appointment/new?requested_doctor=" + doctorId %>">
	        
	        <% }else{ %>
	        
	        	<a href="#">
	        
	        <% } %>
	        		
	            <div class="col-sm-3">
	              <div class="thumbnail">
	                <center>
	                  <span class="glyphicon glyphicon-user _doctor-icon"></span>
	                  <div class="caption">
	                    <h4>Dr. <%= fullName %></h4>
	                    <div class="btn-group" role="group">
	                      <button type="button" style="color:#5cb85c;" class="btn btn-default disabled">
	                        <span class="glyphicon glyphicon-thumbs-up"></span>
	                        <strong><%= goodReview %></strong>
	                      </button>
	                      <button type="button" style="color:#d9534f;" class="btn btn-default disabled">
	                        <span class="glyphicon glyphicon-thumbs-down"></span>
	                        <strong><%= badReview %></strong>
	                      </button>
	                    </div>
	                  </div>
	                </center>
	              </div>
	            </div>
	          </a>
	        		
	        <% 
	        
	        		}
	        		
	        		rs.close();
	        		ps.close();
	        		
	        		
	        		}catch(Exception e){
	        			System.out.println("Runtime-log: " + e.getMessage());
	        		}
	        
	        %>   
	        
	        <% }else{ %>
	        
	        <div class="row">
	        	<div class="col-sm-12">
	        		<!-- Search Field -->
		                <h1 class="text-center">Search Doctor</h1>
		                <center>
		                <div class="form-group">
		                	<form action="./search" method="GET">
		                		<div class="input-group" style="width: 700px">
			                        <input class="form-control" type="text" name="search_query" placeholder="Search" required/>
			                        <span class="input-group-btn">
			                            <button class="btn btn-success" type="submit"><span class="glyphicon glyphicon-search"></button>
			                        </span>
			                        </span>
		                    	</div>
		                	</form>
		            </div>
		            </center>
	        		<!-- End of Search Form -->
	        	</div>
	        </div>
	        
	        
	        <% } %>


	          </div>
	        </div>

	        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	        <% if(newNotifications > 0){ %>
        
        	<script src="${pageContext.request.contextPath}/RESOURCES/js/bell-icon-flickering.js"></script>
        
        	<% } %>
	        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
	    </body>
	</html>

<%
	Database.close(conn);
			
		}else{
			
			response.sendRedirect("./");
			return;
			
		}
		

	}
%>