<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<% 
	if(session.getAttribute("email") != null){
		
		if(session.getAttribute("type").equals("user")){
			
			response.sendRedirect("./user/dashboard");
			return;
			
		}else if(session.getAttribute("type").equals("doctor")){
			
			response.sendRedirect("./doctor/dashboard");
			return;
			
		}
		
	}else{
%>    
    
    
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>BitHealth</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/main.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Lobster" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu" rel="stylesheet">

    </head>
    <body>

        <div class="container">
            <nav class="navbar navbar-default _navbar">
              <div class="container-fluid">
                <div class="navbar-header">
                  <a class="navbar-brand _brand" href="./">
                    <span class="glyphicon glyphicon-plus _nav-glyphicon"></span>BitHealth
                  </a>
                </div>
                <p class="navbar-text navbar-right _navbar-links"><strong><a href="./signin">Sign In</a></strong></p>
              </div>
            </nav>
        </div>

        <div class="container _container">
            <div class="row">
                <div class="col-md-7">
                	<center>
                		<img src="${pageContext.request.contextPath}/RESOURCES/img/banner.png" width="450px"/>
                    	<h1 class="_slogan">Manage your health efficiently</h1>
                    	<p class="_par">This platform allows you to get an appointment with your favorite doctor easily and efficiently. You can also manage and evaluate your appointments with a few simple steps and all these with the help of BitHealth.</p>
                	</center>
                </div>
                <div class="col-md-4 col-md-offset-1">
                     <% 
                        	
                    	if(request.getAttribute("error") != null){
                        	
                     %>
                        	
                     <div class="alert alert-danger" role="alert"><%= request.getAttribute("error") %></div>
                        	
                        	
                     <% } %>
                    <div class="well">
                        <form class="form-group" action="./" method="POST">
                            <input type="text" class="form-control" placeholder="First Name" name="firstName" autocomplete="off" maxlength="30"/>
                            <input type="text" class="form-control" placeholder="Last Name" name="lastName" autocomplete="off" maxlength="30"/>
                            <input type="email" class="form-control" placeholder="Email" name="email" autocomplete="off" maxlength="255"/>
                            <input type="password" class="form-control" placeholder="Password" name="password" maxlength="255"/>
                            <input type="text" class="form-control" placeholder="AMKA" name="amka" autocomplete="off" maxlength="20"/>
                            <button type="submit" class="btn btn-success btn-lg _form-btn" name="submit">Manage your health</button>
                            <p class="_reminder">By clicking "Manage your health", you agree to our <a href="#">terms of service</a> and <a href="#">privacy policy</a>. </p>
                        </form>
                    </div>
                    
                    
                </div>
            </div>
            <div class="row">
                <div class="footer">

                </div>
            </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>

<%
	}
%>