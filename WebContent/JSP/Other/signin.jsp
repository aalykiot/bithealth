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
        <title>Sign in to BitHealth</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/main.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Lobster" rel="stylesheet">

    </head>
    <body>

        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-lg-offset-4  _signin-logo-border">
                    <h1 class="_signin-logo"><a href="./" class="_signin-logo-link"><span class="glyphicon glyphicon-plus _nav-glyphicon"></span>BitHealth</a></h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 col-lg-offset-4 _signin-header">
                    <h3>Sign in</h3>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-4 col-lg-offset-4 _signin-header">
                    <div class="well">
                        <div class="form-group">
                        	<form action="./signin" method="POST">
	                            <label class="_signin-label">Email</label><br/>
	                            <input type="email" name="email" class="form-control"/>
	                            <label class="_signin-label">Password</label><br/>
	                            <input type="password" name="password" class="form-control"/>
	                            <button type="submit" name="submit" class="btn btn-primary btn-lg _signin-btn">Sign In</button>
                        	</form>
                        </div>
                    </div>
                </div>
            </div>
            
            <% 
            
            	if(request.getAttribute("error") != null){
            
            %>
            
            	<div class="row">
                	<div class="col-lg-4 col-lg-offset-4 _signin-header">
                    	<div class="alert alert-danger" role="alert"><%= request.getAttribute("error") %></div>
                	</div>
            	</div>
            
            <% } %>
            
            <div class="row">
                <div class="col-lg-4 col-lg-offset-4 _signin-header">
                    <div class="well">
                        New to BitHealth? <a href="./">Create an account</a>
                    </div>
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
