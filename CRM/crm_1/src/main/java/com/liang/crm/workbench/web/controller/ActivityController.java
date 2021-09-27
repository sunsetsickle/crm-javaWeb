package com.liang.crm.workbench.web.controller;

import com.liang.crm.settings.domain.User;
import com.liang.crm.settings.service.UserService;
import com.liang.crm.settings.service.impl.UserServiceImpl;
import com.liang.crm.utils.DateTimeUtil;
import com.liang.crm.utils.PrintJson;
import com.liang.crm.utils.ServiceFactory;
import com.liang.crm.utils.UUIDUtil;
import com.liang.crm.vo.PaginationVo;
import com.liang.crm.workbench.domain.Activity;
import com.liang.crm.workbench.service.ActivityService;
import com.liang.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入市场活动控制器");

        String path=request.getServletPath();
        if ("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        }else if ("/workbench/activity/save.do".equals(path)){
            save(request,response);
        }else if ("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("==执行市场活动的删除操作==");
        String ids[]=request.getParameterValues("id");
        ActivityService as= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        boolean flag=as.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动信息列表的查找（结合条件查询和分页查询）");
        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");

//        每页展现的记录数
        int pageNo= Integer.parseInt(request.getParameter("pageNo"));
        int pageSize= Integer.parseInt(request.getParameter("pageSize"));
//        计算出略过的记录数
        int skipCount=(pageNo-1)*pageSize;

        Map<String,Object> map= new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService as= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        PaginationVo<Activity> vo =as.pageList(map);

        PrintJson.printJsonObj(response,vo);

        /*
        *   前端要什么：市场活动信息列表
        *             查询的总条数
        *   业务层拿到了以上两项信息之后，做返回
        *
        *   vo
        *   PaginationVo<T>
                private int tatal;
                private List<T> dataList;
        *   将来分页查询，每个模块都有，所以选择使用一个通用的VO封装
        *
        *   PaginationVo<Activity> vo=new PaginationVo<>;
        * */
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("市场活动添加操作");

       String id= UUIDUtil.getUUID();
       String owner=request.getParameter("owner");
       String name=request.getParameter("name");
       String startDate=request.getParameter("startDate");
       String endDate=request.getParameter("endDate");
       String cost=request.getParameter("cost");
       String description=request.getParameter("description");
//       创建时间：当前系统时间
       String createTime= DateTimeUtil.getSysTime();
       //创建人：当前登录用户
       String createBy= ((User) request.getSession().getAttribute("user")).getName();

//       封装成对象
        Activity a=new Activity();
        a.setId(id);
        a.setOwner(owner);
        a.setName(name);
        a.setStartDate(startDate);
        a.setEndDate(endDate);
        a.setCost(cost);
        a.setDescription(description);
        a.setCreateTime(createTime);
        a.setCreateBy(createBy);


        ActivityService as= (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flage= as.save(a);
        PrintJson.printJsonFlag(response,flage);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得模态窗口用户信息列表");

        UserService us= (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList= us.getUserList();

        PrintJson.printJsonObj(response,uList);
    }
}




























