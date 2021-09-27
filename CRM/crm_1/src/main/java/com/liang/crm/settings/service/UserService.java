package com.liang.crm.settings.service;

import com.liang.crm.exception.LoginException;
import com.liang.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
