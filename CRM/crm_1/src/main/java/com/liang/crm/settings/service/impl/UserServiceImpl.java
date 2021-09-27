package com.liang.crm.settings.service.impl;

import com.liang.crm.exception.LoginException;
import com.liang.crm.settings.dao.UserDao;
import com.liang.crm.settings.domain.User;
import com.liang.crm.settings.service.UserService;
import com.liang.crm.utils.DateTimeUtil;
import com.liang.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao=  SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {

        Map<String,String> map=new HashMap<String,String>();

        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userDao.login(map);

        if (user==null){
            throw new LoginException("账号密码错误");
        }

//        验证失效时间
        String expireTime=user.getExpireTime();
        String currentTime= DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }

//        判断锁定状态
        String locaState =user.getLockState();
        if ("0".equals(locaState)){
            throw new LoginException("账号已锁定，请联系管理员");
        }

//        判断ip地址
        String allowIps=user.getAllowIps();

        if (!(allowIps.equals("")) &&!allowIps.contains(ip)){
            throw new LoginException("ip地址受限");
        }
        System.out.println("登录成功");
        return user;
    }

    @Override
    public List<User> getUserList() {
       List<User> userList = userDao.getUserList();

        return userList;
    }
}
