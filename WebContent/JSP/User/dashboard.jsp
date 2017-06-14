<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<%@ 
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,services.Database"
%>    

<%

	if(session.getAttribute("email") == null || !session.getAttribute("type").toString().equals("user")){
		
		response.sendRedirect("../");
		
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

                <form class="navbar-form form-inline navbar-left" action="./search" method="GET">
                    <span class="glyphicon glyphicon-search _search-glyphicon" style="color:#fff;"></span>
                    <input type="text" class="form-control _search-input" name="q" placeholder="Search doctors...">
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

        <div class="_empty-space"></div>


        <div class="container _container">
          <div class="row">
            <div class="col-sm-4">
              <div class="list-group">
                <a href="#" class="list-group-item disabled">
                  Appointments
                  <button type="button" class="btn btn-sm btn-success _book-app-button">
                    <i class="glyphicon glyphicon-plus"></i><strong> Book new appointment</strong>
                  </button>
                </a>
                <a href="#" class="list-group-item">All <span class="badge">5</span></a>
                <a href="#" class="list-group-item">Pending <span class="badge">2</span></a>
                <a href="#" class="list-group-item">Completed <span class="badge">2</span></a>
                <a href="#" class="list-group-item">Canceled <span class="badge">1</span></a>
              </div>
            </div>
            <div class="col-sm-8">

              <div class="panel panel-info">
                <div class="panel-heading">
                  <h3 class="panel-title">Pending</h3>
                  <div class="progress _progress-bar">
                    <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" style="width: 70%">
                    </div>
                  </div>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giorgos Vlahos</a><br/>
                  <strong>Date: </strong> 14/6/2017 2:00 PM

                  <div class="btn-group _panel-btn-group" role="group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                      Edit
                      <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-right">
                      <li><a href="#"><span class="glyphicon glyphicon-time"></span> Reschedule</a></li>
                      <li><a href="#"><span class="glyphicon glyphicon-remove"></span> Cancel</a></li>
                    </ul>
                  </div>

                </div>
              </div>

              <div class="panel panel-info">
                <div class="panel-heading">
                  <h3 class="panel-title">Pending</h3>
                  <div class="progress _progress-bar">
                    <div class="progress-bar progress-bar-info  progress-bar-striped" role="progressbar" style="width: 25%">
                    </div>
                  </div>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giannis Vlachodimos</a><br/>
                  <strong>Date: </strong> 16/7/2017 11:00 AM

                  <div class="btn-group _panel-btn-group" role="group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                      Edit
                      <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-right">
                      <li><a href="#"><span class="glyphicon glyphicon-time"></span> Reschedule</a></li>
                      <li><a href="#"><span class="glyphicon glyphicon-remove"></span> Cancel</a></li>
                    </ul>
                  </div>

                </div>
              </div>

              <div class="panel panel-success">
                <div class="panel-heading">
                  <h3 class="panel-title">Completed</h3>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giorgos Vlahos</a><br/>
                  <strong>Date: </strong> 15/7/2017 2:00 PM

                  <div class="btn-group _panel-btn-group" role="group">
                    <button type="button" class="btn btn-default disabled">
                      <strong>experience</strong>
                    </button>
                    <button type="button" class="btn btn-default">
                      <span class="glyphicon glyphicon-thumbs-up"></span>
                      Good
                    </button>
                    <button type="button" class="btn btn-default">
                      <span class="glyphicon glyphicon-thumbs-down"></span>
                      Bad
                    </button>
                  </div>

                </div>
              </div>

              <div class="panel panel-danger">
                <div class="panel-heading">
                  <h3 class="panel-title">Canceled</h3>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giorgos Vlahos</a><br/>
                  <strong>Date: </strong> 15/7/2017 2:00 PM

                </div>
              </div>

              <div class="panel panel-success">
                <div class="panel-heading">
                  <h3 class="panel-title">Completed</h3>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giorgos Vlahos</a><br/>
                  <strong>Date: </strong> 15/7/2017 2:00 PM

                  <div class="btn-group _panel-btn-group" role="group">
                    <button type="button" class="btn btn-default disabled">
                      <strong>experience</strong>
                    </button>
                    <button type="button" class="btn btn-default">
                      <span class="glyphicon glyphicon-thumbs-up"></span>
                      Good
                    </button>
                    <button type="button" class="btn btn-default">
                      <span class="glyphicon glyphicon-thumbs-down"></span>
                      Bad
                    </button>
                  </div>

                </div>
              </div>

              <div class="panel panel-success">
                <div class="panel-heading">
                  <h3 class="panel-title">Completed</h3>
                </div>
                <div class="panel-body">
                  <strong>Doctor's Name: </strong><a href="">Giorgos Vlahos</a><br/>
                  <strong>Date: </strong> 15/7/2017 2:00 PM

                  <div class="btn-group _panel-btn-group" role="group">
                    <button type="button" class="btn btn-default disabled">
                      <strong>experience submited</strong>
                    </button>
                  </div>

                </div>
              </div>

            </div>
          </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<% } %>