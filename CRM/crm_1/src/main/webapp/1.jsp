<%--
  Created by IntelliJ IDEA.
  User: 凉
  Date: 2021/8/6
  Time: 15:20
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <title>Title</title>

    <script>
        $.ajax({
            url:"",
            data:{

            },
            type:"",
            dataType:"",
            success: function (data){

            }
        })

        String editTime=request.getParameter("editTime");
        String editBy=request.getParameter("editBy");
    </script>
</head>
<body>

</body>
</html>
