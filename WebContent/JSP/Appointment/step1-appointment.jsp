<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,services.Database"
%>  


<%
	if(session.getAttribute("email") == null || (!session.getAttribute("type").toString().equals("user") && !session.getAttribute("type").toString().equals("doctor"))){
		
		response.sendRedirect("./");
		return;
		
	}else{
		
		String email = session.getAttribute("email").toString();
		String searchQuery = request.getParameter("appointment_query");
		String option = request.getParameter("option");
		
		if(searchQuery != null){
			searchQuery = searchQuery.trim(); // If appointment_query isn't null trim extra white spaces
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
        <title>Book appointment</title>
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
                <a class="navbar-brand _brand" href="#" style="color:#fff;">
                  <span class="glyphicon glyphicon-plus _nav-glyphicon"></span>BitHealth
                </a>
              </div>

              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

                <form class="navbar-form form-inline navbar-left">
                    <span class="glyphicon glyphicon-search _search-glyphicon" style="color:#fff;"></span>
                    <input type="text" class="form-control _search-input" placeholder="Search doctors...">
                </form>


                <ul class="nav navbar-nav navbar-right">
                  <li><a href="#">
                    <span class="glyphicon glyphicon-th-list"></span>
                  </a></li>
                  <li><a href="#">
                    <span class="glyphicon glyphicon-bell"></span>
                    <span class="badge _navbar-not">2</span>
                  </a></li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                      <span class="glyphicon glyphicon-user"></span>
                      <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                      <li class="dropdown-header">Signed in as <br/><strong>Alex Alikiotis</strong></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="#">Settings</a></li>
                      <li role="separator" class="divider"></li>
                      <li><a href="#">Sign out</a></li>
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
              <span class="list-group-item active">

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
              <span class="list-group-item">
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
              <form class="form-inline" action="./appointment" method="GET">
                  <input style="width: 437px;" type="text" class="form-control" placeholder="Doctor's name..." name="appointment_query">
                  <select class="form-control" name="option">
                    <option>Pathology</option>
                    <option>Cardiology</option>
                    <option>Endocrinology</option>
                    <option>Gastroenterology</option>
                    <option>Microbiology</option>
                    <option>Nephrology</option>
                    <option>Neurology</option>
                    <option>Ophthalmology</option>
                    <option>Orthodontics</option>
                    <option>Orthopaedics</option>
                    <option>Paediatrics</option>
                  </select>
                  <button type="submit" class="btn btn-default">Search</button>
                  
              </form>


              <!-- if we dont have results

              <center><span style="font-size: 200px;position: relative; top: 150px; color: #E6E6E6;" class="glyphicon glyphicon-search"></span></center>

              -->

              <!-- if we have results -->

<%
        
        	if(!searchQuery.isEmpty()){
        		
        		try{
        		
        		query = "SELECT COUNT(*) FROM doctors WHERE speciality ILIKE ? AND (CONCAT(first_name, ' ', last_name) ILIKE ? OR CONCAT(last_name, ' ', first_name) ILIKE ?)";
        		
        		
        		ps = conn.prepareStatement(query);
        		
        		ps.setString(1, "%" + option + "%");
				ps.setString(2, "%" + searchQuery + "%");
				ps.setString(3, "%" + searchQuery + "%");
        		
        		
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
        
        		query = "SELECT doctor_id, CONCAT(first_name, ' ', last_name) AS full_name, good_review, bad_review FROM doctors WHERE speciality ILIKE ? AND (CONCAT(first_name, ' ', last_name) ILIKE ? OR CONCAT(last_name, ' ', first_name) ILIKE ?)";
		
				ps = conn.prepareStatement(query);
				
        		ps.setString(1, "%" + option + "%");
				ps.setString(2, "%" + searchQuery + "%");
				ps.setString(3, "%" + searchQuery + "%");
				
				
				rs = ps.executeQuery();
        
        		
        		
        		while(rs.next()){
        			
        			String doctorId = Integer.toString(rs.getInt(1));
        			String fullName = rs.getString(2);
        			String goodReview = Integer.toString(rs.getInt(3));
        			String badReview = Integer.toString(rs.getInt(4));
        		
        		
        %>
        		
        <a href=<%="./appointment?requested_doctor=" + doctorId %>>
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
        			request.setAttribute("debug", e.getMessage());
        		}
        
        %>   
        
        <% } %>

          </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<%
	Database.close();
	}
%>
