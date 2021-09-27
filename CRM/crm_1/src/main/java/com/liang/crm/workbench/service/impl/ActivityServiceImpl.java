package com.liang.crm.workbench.service.impl;

import com.liang.crm.utils.SqlSessionUtil;
import com.liang.crm.vo.PaginationVo;
import com.liang.crm.workbench.dao.ActivityDao;
import com.liang.crm.workbench.dao.ActivityRemarkDao;
import com.liang.crm.workbench.domain.Activity;
import com.liang.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {

    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);


    @Override
    public boolean save(Activity a) {
        boolean flag=true;
        int count=activityDao.save(a);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {

//        取得total
        int total=activityDao.getTotalByCondition(map);
//        取得dataList
        List<Activity> dataList=activityDao.getActivityListByCondition(map);
//        将total和dataList封装到vo
        PaginationVo<Activity> vo=new PaginationVo<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
//        将vo返回

        return vo;
    }

    @Override
    public boolean delete(String[] ids) {

        boolean flag=true;
        //先查询出需要删除的备注的数量
        int count1=activityRemarkDao.getCountByAids(ids);

        //删除备注，返回收到影响的条数（实际删除的数量）
        int count2=activityRemarkDao.deleteByIds(ids);

        if (count1!=count2){
            flag=false;
        }
        //删除市场活动
        int count3=activityDao.delete(ids);
        if (count3!=ids.length){
            flag=false;
        }


        return flag;
    }
}
