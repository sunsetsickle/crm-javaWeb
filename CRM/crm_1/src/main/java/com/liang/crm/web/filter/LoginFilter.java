package com.liang.crm.web.filter;

import com.liang.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        System.out.println("进入到验证有没有登录过的过滤器====》com.liang.crm.web.filter.LoginFilter");

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getServletPath();
//        不应该被拦截的请求，自动放行
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)) {
            filterChain.doFilter(servletRequest, servletResponse);
        } else {
//            其他请求
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user != null) {
                filterChain.doFilter(servletRequest, servletResponse);
            } else {
                /*
                 * 重定向到登录页
                 *   路径：实际项目开发中，对于路径的使用不论，操作的是前端还是后端，一律使用绝对路径
                 *   转发：使用的是一种特殊的绝对路径的使用方式，前面不加/项目名，也称内部路径 /login.jsp
                 *
                 *   重定向：使用传统绝对路径的写法 必须以 /项目名开头 后面跟具体资源路径 /crm_1/login.jsp
                 *
                 * 为什么使用重定向,使用转发不行?:
                 *   转发之后，路径会停留到原来的路径上，而不是跳转之后最新资源的路径上
                 *   我们应该在为用户跳转到登录页之后，将浏览器的地址栏自动设置为当前页的路径
                 * */
                //response.sendRedirect("/crm_1/login.jsp");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }


    }
}
