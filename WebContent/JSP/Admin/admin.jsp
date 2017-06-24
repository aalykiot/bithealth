<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@
	page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.util.Date,java.text.DateFormat,java.text.SimpleDateFormat,services.Database"
%>

<%
	Connection conn = Database.getConnection();
	
	PreparedStatement ps = null;
	ResultSet rs = null;
	String query = null;
	
	String fName = request.getParameter("firstName");
    String lName = request.getParameter("lastName");
    String eml = request.getParameter("email");
    String pass = request.getParameter("password");
    String amka = request.getParameter("amka");
    String speciality = request.getParameter("speciality");
    String dayFrom=request.getParameter("dayFrom");
    String dayTo=request.getParameter("dayTo");
    String hourFrom=request.getParameter("hourFrom");
    String hourTo=request.getParameter("hourTo");  
	

%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Admin Panel</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/inner.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:700" rel="stylesheet">

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
                <a class="navbar-brand _dev-brand" href="#" style="color:#fff;">
                  Bithealth Developers
                </a>
              </div>

              <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">


                <ul class="nav navbar-nav navbar-right">>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                      <span class="glyphicon glyphicon-user"></span>
                      <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                      <li class="dropdown-header">Signed in as <br/><strong>Alex Alikiotis</strong></li>
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
            <div class="col-sm-12">
              <ul class="nav nav-tabs">
                <li role="presentation" class="active"><a href="#">
                  <span class="glyphicon glyphicon-cog"></span>
                  Admin Panel
                </a></li>
              </ul>
            </div>
          </div>

          <div class="_empty-space-not"></div>

          <div class="row">
            <div class="col-sm-3">
              <ul class="nav nav-pills nav-stacked">
              <%  String view = request.getParameter("v");
              	if(view == null || (!view.equals("users") && !view.equals("doctors"))){
              	//For the General's button
              %>
                <li role="presentation" class="active" ><a href="./dashboard?v=general">General</a></li> 
                <li role="presentation" ><a href="./dashboard?v=users">Users</a></li>
                <li role="presentation" ><a href="./dashboard?v=doctors">Doctors</a></li>
             <%}else if(view.equals("users")){ 
             //For the Users' button%>
             	<li role="presentation"  ><a href="./dashboard?v=general">General</a></li>
                <li role="presentation" class="active" ><a href="./dashboard?v=users">Users</a></li>
                <li role="presentation" ><a href="./dashboard?v=doctors">Doctors</a></li>
             <%}else if(view.equals("doctors")){ 
             //For the Doctors' button%>
             	<li role="presentation"  ><a href="./dashboard?v=general">General</a></li>
                <li role="presentation"  ><a href="./dashboard?v=users">Users</a></li>
                <li role="presentation" class="active"><a href="./dashboard?v=doctors">Doctors</a></li>
             <%} %>
              </ul>
            </div>
            <div class="col-sm-9">
             
              <% if(view == null || (!view.equals("users") && !view.equals("doctors"))){ 
              //For the General UI%> 
              <center>
                  <blockquote>
                    <p style="position:relative; left: -290px;"><i>Users and Doctors</i></p>
                  </blockquote>
                  
                    
                    <%
                    	//Count all Users
	                    query = "SELECT COUNT(*) FROM users ";
						ps = conn.prepareStatement(query);
	
						
	
						rs = ps.executeQuery();
	
						int users = 0;
	
						if(rs.next()){
	
							users = rs.getInt(1);
	
						}
	
						rs.close();
						ps.close();
                    
                    %>
                    <div class="row">
                      <div class="col-sm-5 col-sm-offset-1">
                      <strong><span style="font-size: 70px;"><%=users %></span></strong> <span style="font-size: 30px;color:#888;">Users</span>
                    </div>
                    
                    <%
	                	//Count all Users
	                    query = "SELECT COUNT(*) FROM doctors ";
						ps = conn.prepareStatement(query);
	
						
	
						rs = ps.executeQuery();
	
						int doctors = 0;
	
						if(rs.next()){
	
							doctors = rs.getInt(1);
	
						}
	
						rs.close();
						ps.close();
                    
                    	
                    %>
                    
                    <div class="col-sm-5">
                      <strong><span style="font-size: 70px;"><%=doctors%></span></strong> <span style="font-size: 30px;color:#888;">Doctors</span>
                    </div>
                  </div>

                  <div style="height: 50px;"></div>

                  <blockquote>
                    <p style="position:relative; left: -310px;"><i>Appointments</i></p>
                  </blockquote>
                  
                  <%

                	
                	int pendingApp = 0;
                	int completedApp = 0;
                	int canceledApp = 0;

                	// Pending appointments

					query = "SELECT COUNT(*) FROM appointments WHERE  status = 'pending'";
					ps = conn.prepareStatement(query);

					

					rs = ps.executeQuery();

					if(rs.next()){

						pendingApp = Integer.parseInt(rs.getString(1));

					}

					rs.close();
					ps.close();

					// Completed appointments

					query = "SELECT COUNT(*) FROM appointments WHERE  status = 'completed'";
					ps = conn.prepareStatement(query);

					

					rs = ps.executeQuery();

					if(rs.next()){

						completedApp = Integer.parseInt(rs.getString(1));

					}

					rs.close();
					ps.close();

					// Canceled appointments

					query = "SELECT COUNT(*) FROM appointments WHERE  status = 'canceled'";
					ps = conn.prepareStatement(query);

					

					rs = ps.executeQuery();

					if(rs.next()){

						canceledApp = Integer.parseInt(rs.getString(1));

					}

					rs.close();
					ps.close();

					


                %>

                  <div class="row">
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;"><%=pendingApp%></span></strong> <span style="font-size: 20px;color:#888;">Pending</span>
                    </div>
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;"><%=completedApp%></span></strong> <span style="font-size: 20px;color:#888;">Completed</span>
                    </div>
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;"><%=canceledApp%></span></strong> <span style="font-size: 20px;color:#888;">Canceled</span>
                    </div>
                  </div>
                </center>
                
                <%}else if(view.equals("users")){
                //For the Users UI%> 
                
				<table class="table table-bordered">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>First Name</th>
                      <th>Last Name</th>
                      <th>Email</th>
                      <th>Amka</th>
                      <th>Pending</th>
                      <th>Completed</th>
                      <th>Canceled</th>
                    </tr>
                  </thead>
                  <tbody>
                  
                  <%

					// Finding all the users 

					query = "SELECT u.first_name,u.last_name,u.email,u.amka,(SELECT COUNT(*) FROM appointments WHERE status='pending' and appointments.user_id = u.user_id) as PenCount,(SELECT COUNT(*) FROM appointments WHERE status='completed' and appointments.user_id = u.user_id) as ComCount,(SELECT COUNT(*) FROM appointments WHERE status='canceled' and appointments.user_id = u.user_id) as CanCount FROM users u ORDER BY user_id ";
					ps = conn.prepareStatement(query);
					rs = ps.executeQuery();
					
					
					
					int j = 1;
					int pendingStatus = 0;
					int completedStatus = 0;
					int canceledStatus = 0;

					while(rs.next()){
						
						String firName = null;
						String lastName = null;
						String email = null;
						long amkaUsers = 0;
						

						firName = rs.getString(1);
						lastName = rs.getString(2);
						email = rs.getString(3);
						amkaUsers = rs.getLong(4);
						pendingStatus = rs.getInt(5);
						completedStatus = rs.getInt(6);
						canceledStatus = rs.getInt(7);
						
						

				%>
                  
                    <tr>
                      <th scope="row"><%=j%></th>
                      <td><%=firName%></td>
                      <td><%=lastName%></td>
                      <td><%=email%></td>
                      <td><%=amkaUsers%></td>
                      <td><%=pendingStatus%></td>
                      <td><%=completedStatus%></td>
                      <td><%=canceledStatus%></td>
                    <tr>
                  
                
                <% 
                j = j + 1;
                }

					rs.close();
					ps.close();
				%>
				
					</tbody>
                </table>
                
                <%}else if(view.equals("doctors")){ 
                //For the Doctors UI%> 
                
                <table class="table table-bordered">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>First Name</th>
                      <th>Last Name</th>
                      <th>Email</th>
                      <th>Amka</th>
                      <th>Speciality</th>
                    </tr>
                  </thead>
                <tbody>
                  
                
                <%

					// Finding all the doctors 

					query = "SELECT first_name,last_name,email,amka,speciality  FROM doctors ";
					ps = conn.prepareStatement(query);
					
					rs = ps.executeQuery();
					
					int i = 1;

					while(rs.next()){
						
						String firstName = null;
						String lastName = null;
						String email = null;
						long amk = 0;
						String specialty = null;

						firstName = rs.getString(1);
						lastName = rs.getString(2);
						email = rs.getString(3);
						amk = rs.getLong(4);
						specialty = rs.getString(5);
						
						

				%>

                
                   <tr>
                      <th scope="row"><%=i %></th>
                      <td><%=firstName %></td>
                      <td><%=lastName %></td>
                      <td><%=email %></td>
                      <td><%=amk %></td>
                      <td><%=specialty %></td>
                      <td><button class="btn btn-danger btn-sm _admin_del_btn"><span class="glyphicon glyphicon-remove"></span></button></td>
                    <tr>
                  
                
                <% 
                i = i + 1;
                }

					rs.close();
					ps.close();
				%>
				</tbody>
              </table>

                <center>
                  <button class="btn btn-default" data-toggle="modal" data-target="#myModal">
                    <i class="glyphicon glyphicon-plus"></i><strong> New Doctor </strong>
                  </button>
                </center>

                <!-- Modal #1(Add Button) -->
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog">
                  <div class="modal-dialog" role="document">
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">
                          <i class="glyphicon glyphicon-plus"></i>
                          Add Doctor
                        </h4>
                      </div>
                      <div class="modal-body">
                      

	                 <form class="form-group" method = "post" action ="./dashboard">
	                     <strong>First Name</strong>
	                     <input type="text" autocomplete="off" value = "<%=fName %>" class="form-control"/><p></p>
	                     <strong>Last Name</strong>
	                     <input type="text" autocomplete="off" value = "<%=lName %>" class="form-control"/><p></p>
	                     <strong>Email</strong>
	                     <input type="email" autocomplete="off" value = "<%=eml %>" class="form-control"/><p></p>
	                     <strong>Password</strong>
	                     <input type="password" autocomplete="off" value = "<%=pass %>" class="form-control"/><p></p>
	                     <strong>Amka</strong>
	                     <input type="text" autocomplete="off" value = "<%=amka %>" class="form-control"/><p></p>
	                     <strong>Speciality</strong>
	                     <select  value = "<%=speciality %>" class="form-control">
	                       <option selected value='-1'>--Select Speciality--</option>
	                       <option value="Pathology">Pathology</option>
	                       <option value="Cardiology">Cardiology</option>
	                       <option value="Endocrinology">Endocrinology</option>
	                       <option value="Gastroenterology">Gastroenterology</option>
	                       <option value="Microbiology">Microbiology</option>
	                       <option value="Nephrology">Nephrology</option>
	                       <option value="Neurology">Neurology</option>
	                       <option value="Ophthalmology">Ophthalmology</option>
	                       <option value="Orthodontics">Orthodontics</option>
	                       <option value="Orthopaedics">Orthopaedics</option>
	                       <option value="Paediatrics">Paediatrics</option>
	                     </select><p></p>
	
	                     <strong>Available from(Day)</strong>
	                     <select value = "<%=dayFrom %>" class="form-control">
	                       <option selected value='-1'>--Select Day--</option>
	                       <option value="1">Monday</option>
	                       <option value="2">Tuesday</option>
	                       <option value="3">Wednesday</option>
	                       <option value="4">Thursday</option>
	                       <option value="5">Friday</option>
	                     </select><p></p>
	
	                     <strong>Available to(Day)</strong>
	                     <select value = "<%=dayTo %>" class="form-control">
	                       <option selected value='-1'>--Select Day--</option>
	                       <option value="1">Monday</option>
	                       <option value="2">Tuesday</option>
	                       <option value="3">Wednesday</option>
	                       <option value="4">Thursday</option>
	                       <option value="5">Friday</option>
	                     </select><p></p>
	
	                     <strong>Available from(Hour)</strong>
	                     <select value = "<%=hourFrom %>" class="form-control">
	                       <option selected value='-1'>--Select Hour--</option>
	                       <option value="9">9:00</option>
	                       <option value="10">10:00</option>
	                       <option value="11">11:00</option>
	                       <option value="12">12:00</option>
	                       <option value="13">13:00</option>
	                       <option value="14">14:00</option>
	                       <option value="15">15:00</option>
	                       <option value="16">16:00</option>
	                       <option value="17">17:00</option>
	                       <option value="18">18:00</option>
	                       <option value="19">19:00</option>
	                     </select><p></p>
	
	                     <strong>Available to(Hour)</strong>
	                     <select  class="form-control" value ="<%=hourTo %>">
	                       <option selected value='-1'>--Select Hour--</option>
	                       <option value="9">9:00</option>
	                       <option value="10">10:00</option>
	                       <option value="11">11:00</option>
	                       <option value="12">12:00</option>
	                       <option value="13">13:00</option>
	                       <option value="14">14:00</option>
	                       <option value="15">15:00</option>
	                       <option value="16">16:00</option>
	                       <option value="17">17:00</option>
	                       <option value="18">18:00</option>
	                       <option value="19">19:00</option>
	                     </select><p></p>
	
	                 
	                 
		    		 </div>
	                 <div class="modal-footer">
	                   <button type="button" class="btn btn-default" data-dismiss="modal" >Close</button>
	                   <button type="submit" name = "b1" class="btn btn-primary"  >Add doctor</button>
	                 </div>
	                 
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
	             </div>
	           </div>
	       </div>
	     </div>
	   </div>
        <% } %>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<%
		Database.close();
	

%>