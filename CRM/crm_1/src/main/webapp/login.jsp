<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>

<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function(){

            if (window.top!=window){
                //防止登录页面出现在frame框内
                window.top.location=window.location;
            }
        //    页面加载完毕后，自动获取焦点
            $("#loginAct").focus();

            //为登录按钮绑定点击事件
            $("#submitBtn").click(function (){
                login();
            })
        //    为浏览器窗口绑定回车事件
        //    event:这个参数可以获得我们敲击的按键
        //    event.keyCode=13(回车)
            $(window).keydown(function (event){
                if (event.keyCode==13){
                    login();
                }
            })
        })
        function login(){
            //验证登录密码，将文本中左右空格去掉
            var loginAct=$.trim($("#loginAct").val());
            var loginPwd=$.trim($("#loginPwd").val());
            if (loginAct==""||loginPwd==""){
                $("#msg").html("账号密码不能为空");

                //如果为空，则需要及时强制终止该方法
                return false;
            }
            $.ajax({
                url:"settings/user/login.do",
                data:{
                    "loginAct" : loginAct,
                    "loginPwd" : loginPwd
                },
                type:"post",
                dataType:"json",
                success: function (data){
                    /*
                    * data：
                    *
                    * */
                    if (data.success){//登录成功
                        window.location.href="workbench/index.jsp";
                    }else{//登录失败
                        $("#msg").html(data.msg);
                    }
                }
            })
        }
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2021&nbsp;满眼的玫瑰</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.jsp" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct" value="zs">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd" value="123">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">

                    <span id="msg" style="color: red"></span>

                </div>
                <button type="button" id="submitBtn" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>