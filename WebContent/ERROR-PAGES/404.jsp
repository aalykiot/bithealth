<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="${pageContext.request.contextPath}/RESOURCES/img/favicon.ico" type="image/x-icon">
        <title>Page not found</title>
        <link href="${pageContext.request.contextPath}/RESOURCES/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/RESOURCES/css/404.css" rel="stylesheet">

        <!-- Google fonts -->
        <link href="https://fonts.googleapis.com/css?family=Ubuntu" rel="stylesheet">

    </head>
    <body>

        <div class="container">
            <div class="row">
              <div align="center">
                <img src="${pageContext.request.contextPath}/RESOURCES/img/banner_404.png" class="image" width="600px">
                <h3 class="message">This is not the web page you are looking for.</h3>
                <button class="btn btn-lg btn-primary" onclick="location.href = '${pageContext.request.contextPath}/';">Go back to home page</buton>
              </div>
          </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/RESOURCES/js/bootstrap.min.js"></script>
    </body>
</html>