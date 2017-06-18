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
	
	String doctorId = null;

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
                  Developers
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
                  <div class="row">
                    <div class="col-sm-5 col-sm-offset-1">
                      <strong><span style="font-size: 70px;">1,234</span></strong> <span style="font-size: 30px;color:#888;">Users</span>
                    </div>
                    <div class="col-sm-5">
                      <strong><span style="font-size: 70px;">234</span></strong> <span style="font-size: 30px;color:#888;">Doctors</span>
                    </div>
                  </div>

                  <div style="height: 50px;"></div>

                  <blockquote>
                    <p style="position:relative; left: -310px;"><i>Appointments</i></p>
                  </blockquote>

                  <div class="row">
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;">1,234</span></strong> <span style="font-size: 20px;color:#888;">Pending</span>
                    </div>
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;">234</span></strong> <span style="font-size: 20px;color:#888;">Completed</span>
                    </div>
                    <div class="col-sm-4">
                      <strong><span style="font-size: 50px;">34</span></strong> <span style="font-size: 20px;color:#888;">Canceled</span>
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
                    <tr>
                      <th scope="row">1</th>
                      <td>Alex</td>
                      <td>Alikiotis</td>
                      <td>alexalikiotis5@gmail.com</td>
                      <td>12345678912</td>
                      <td>3</td>
                      <td>10</td>
                      <td>1</td>
                    <tr>
                    <tr>
                      <th scope="row">2</th>
                      <td>Alex</td>
                      <td>Alikiotis</td>
                      <td>alexalikiotis5@gmail.com</td>
                      <td>12345678912</td>
                      <td>3</td>
                      <td>10</td>
                      <td>1</td>
                    <tr>
                    <tr>
                      <th scope="row">3</th>
                      <td>Alex</td>
                      <td>Alikiotis</td>
                      <td>alexalikiotis5@gmail.com</td>
                      <td>12345678912</td>
                      <td>3</td>
                      <td>10</td>
                      <td>1</td>
                    <tr>
                    <tr>
                      <th scope="row">4</th>
                      <td>Alex</td>
                      <td>Alikiotis</td>
                      <td>alexalikiotis5@gmail.com</td>
                      <td>12345678912</td>
                      <td>3</td>
                      <td>10</td>
                      <td>1</td>
                    <tr>
                      <tr>
                        <th scope="row">5</th>
                        <td>Alex</td>
                        <td>Alikiotis</td>
                        <td>alexalikiotis5@gmail.com</td>
                        <td>12345678912</td>
                        <td>3</td>
                        <td>10</td>
                        <td>1</td>
                      <tr>
                      <tr>
                        <th scope="row">6</th>
                        <td>Alex</td>
                        <td>Alikiotis</td>
                        <td>alexalikiotis5@gmail.com</td>
                        <td>12345678912</td>
                        <td>3</td>
                        <td>10</td>
                        <td>1</td>
                      <tr>
                      <tr>
                        <th scope="row">7</th>
                        <td>Alex</td>
                        <td>Alikiotis</td>
                        <td>alexalikiotis5@gmail.com</td>
                        <td>12345678912</td>
                        <td>3</td>
                        <td>10</td>
                        <td>1</td>
                      <tr>
                      <tr>
                        <th scope="row">8</th>
                        <td>Alex</td>
                        <td>Alikiotis</td>
                        <td>alexalikiotis5@gmail.com</td>
                        <td>12345678912</td>
                        <td>3</td>
                        <td>10</td>
                        <td>1</td>
                      <tr>
                  </tbody>
                </table>
                
                <%}else if(view.equals("doctors")){ 
                //For the Doctors UI%> 
                
                <%

					// Finding all the doctors 

					query = "SELECT first_name,last_name,email,amka,speciality  FROM doctors WHERE doctor_id = ? ";
					ps = conn.prepareStatement(query);
					ps.setInt(1, Integer.parseInt(doctorId));
					rs = ps.executeQuery();
					
					

					while(rs.next()){
						
						String firstName = null;
						String lastName = null;
						String email = null;
						long amka = 0;
						String speciality = null;

						firstName = rs.getString(1);
						lastName = rs.getString(2);
						email = rs.getString(3);
						amka = rs.getInt(4);
						speciality = rs.getString(5);
						

				%>

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
                    <tr>
                      <th scope="row">1</th>
                      <td><%=firstName %></td>
                      <td><%=lastName %></td>
                      <td><%=email %></td>
                      <td><%=amka %></td>
                      <td><%=speciality %></td>
                    <tr>
                  </tbody>
                </table> 
                
                <% 
                }

					rs.close();
					ps.close();
				%>

                <center>
                  <button class="btn btn-default" data-toggle="modal" data-target="#myModal">
                    <i class="glyphicon glyphicon-plus"></i><strong> New Doctor </strong>
                  </button>

                  <button class="btn btn-default" data-toggle="modal" data-target="#secModal">
                    <i class="glyphicon glyphicon-minus"></i><strong> Delete Doctor </strong>
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

                        <form class="form-group">
                            <strong>First Name</strong>
                            <input type="text" class="form-control"/><p></p>
                            <strong>Last Name</strong>
                            <input type="text" class="form-control"/><p></p>
                            <strong>Email</strong>
                            <input type="email" class="form-control"/><p></p>
                            <strong>Password</strong>
                            <input type="password" class="form-control"/><p></p>
                            <strong>Amka</strong>
                            <input type="text" class="form-control"/><p></p>
                            <strong>Speciality</strong>
                            <select class="form-control">
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
                            </select>
                        </form>
                                                
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Add doctor</button>
                      </div>
                    </div>
                  </div>
                </div>
            
        
        		<!-- Modal #2(Delete Button) -->
                <div class="modal fade" id="secModal" tabindex="-1" role="dialog">
                  <div class="modal-dialog" role="document">
                    <div class="modal-content">
                      <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="secModalLabel">
                          <i class="glyphicon glyphicon-minus"></i>
                          Delete Doctor
                        </h4>
                      </div>
                      <div class="modal-body">

                        <form class="form-group">
                            <strong>Amka</strong>
                            <input type="text" class="form-control"/><p></p>
                        </form>
                                                
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Delete doctor</button>
                      </div>
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