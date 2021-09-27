package com.liang.crm.settings.web.controller;

import com.liang.crm.settings.domain.User;
import com.liang.crm.settings.service.UserService;
import com.liang.crm.settings.service.impl.UserServiceImpl;
import com.liang.crm.utils.MD5Util;
import com.liang.crm.utils.PrintJson;
import com.liang.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");

        String path=request.getServletPath();
        if ("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if ("/settings/user/xxx.do".equals(path)){

        }
    }

    private void login(HttpServletRequest request,HttpServletResponse response){
        System.out.println("登录验证操作");
        String loginAct=request.getParameter("loginAct");
        String loginPwd=request.getParameter("loginPwd");
//        将明文密码转为MD5的密文形式
        loginPwd= MD5Util.getMD5(loginPwd);
//        接收浏览器端ip地址
        String ip=request.getRemoteAddr();
        System.out.println("ip地址-------->"+ip);

        UserService us= (UserService) ServiceFactory.getService(new UserServiceImpl());

        System.out.println("===========测试===");
        try{
            User user= us.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user",user);

            PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            e.printStackTrace();
            //一旦程序执行了catch的信息，说明业务层登录验证失败，抛出异常

            String msg=e.getMessage();
            /*
            * 作为controller，需要为ajax请求提供多项信息
            *   1）将多项信息打包成map，将map解析成json串()
            *   2）创建一个Vo(开销大，可以多次使用)
            *           private boolean success;
            *           private String msg;
             */
            Map<String,Object> map=new HashMap<String,Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);//把map打包成json 并发送给前端
        }
    }
}




























