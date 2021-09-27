package com.liang.crm.workbench.service;

import com.liang.crm.vo.PaginationVo;
import com.liang.crm.workbench.domain.Activity;

import java.util.Map;

public interface ActivityService {
    boolean save(Activity a);

    PaginationVo<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);
}
