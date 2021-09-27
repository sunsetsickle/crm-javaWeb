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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
    <script type="text/javascript">

        $(function () {
            $(".time").datetimepicker({
                //日期插件  这个time选择器写在日期的input里
                minView:"month",
                language:"zh-CN",
                format:"yyyy-mm-dd",
                autoclose:true,
                todayBtn:true,
                pickerPosition:"bottom-left"
            });
        // 来为创建按钮绑定事件，打开添加操作的模态窗口
            $("#addBtn").click(function (){
                /*
                * 操作模态窗口的方式：
                *   需要操作的模态窗口的jquery对象，调用modal为该方法传递参数 show：打开  hide：关闭
                * */

                // $("#createActivityModal").modal("show");
                //走后台，目的是取得用户信息列表为 “所有者”下拉框赋值
                $.ajax({
                    url:"workbench/activity/getUserList.do",
                    type:"get",
                    dataType:"json",
                    success: function (data){
                        /*
                        * data
                        *   [{用户1},{2},{3}]
                        * */
                        var html="<option></option>";
                        //遍历出来的每一个n就是一个user对象
                        $.each(data,function(i,n){
                            html+="<option value='"+n.id+"'>"+n.name+"</option>"
                        })

                        $("#create-owner").html(html);

                        //默认下拉框选中当前用户：使用EL表达式从session中获取user的id
                        var id="${user.id}";
                        $("#create-owner").val(id);

                    //    所有者下拉框处理完毕后，展现模态窗口
                        $("#createActivityModal").modal("show");
                    }
                })
            });
            $("#saveBtn").click(function () {
                $.ajax({
                    url:"workbench/activity/save.do",
                    data:{
                        "id":$.trim($("#create-id").val()),
                        "owner":$.trim($("#create-owner").val()),
                        "name":$.trim($("#create-name").val()),
                        "startDate":$.trim($("#create-startDate").val()),
                        "endDate":$.trim($("#create-endDate").val()),
                        "cost":$.trim($("#create-cost").val()),
                        "description":$.trim($("#create-description").val()),
                    },
                    type:"post",
                    dataType:"json",
                    success: function (data){
                        /*
                        * data
                        *   {"success":true/false}
                        * */
                        if(data.success){
                        //    添加成功后
                        //    刷新市场活动信息列表（局部刷新）
                        //    清空模态窗口中的数据
                        //    $("#activityAddForm").submit();提交表单
                            /*
                            *   注意：
                            *       拿到form表单的jquery对象
                            *       对于表单的jquery对象，提供了submit()方法让我们提交表单
                            *       但是表单的jquery对象没有方法让我们重置表单
                            *       虽然jquery没有reset方法，但是原生js提供了reset方法
                            *       所以我们要将jquery对象转换为原生dom对象：
                            *           jquery对象转换为dom：
                            *               jquery对象[下标]
                            *           dom对象转换为jquery：
                            *               $(dom)
                            * */
                            $("#activityAddForm")[0].reset();
                        //    关闭添加操作的模态窗口
                            $("#createActivityModal").modal("hide");

                            pageList(1,2);
                        }else{
                            alert("添加市场活动失败");
                        }
                    }
                })
            })
            //页面加载完毕后触发一个方法
            //默认展开列表的
            pageList(1,2);//入口1

        //    为查询按钮绑定事件，触发pageList方法
            $("#search-Btn").click(function () {
                /*
                解决BUG：
                    查询框中输入搜索信息，不点击查询，直接点击下一页，或点击查询后，修改搜索信息再点下一页
                解决：
                  点击查询按钮的时候，我们应该将搜索框中的信息保存起来
                  保存在隐藏域中
                 */
                $("#hidden-name").val($.trim($("#search-name").val()));
                $("#hidden-owner").val($.trim($("#search-owner").val()));
                $("#hidden-startData").val($.trim($("#search-startDate").val()));
                $("#hidden-endData").val($.trim($("#search-endDate").val()));
                pageList(1,2);//入口2
            })


        //    为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function(){
                $("input[name=xz]").prop("checked",this.checked);
            })

            /*一下做法不行：
                因为动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
            $("input[name=xz]").click(function(){
                alert(123);
            })
            */

            /*
            动态生成的元素，我们要以on方法的形式来触发时间
                语法：
                    $(需要绑定元素的有效外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象，回调函数)
                    外层有效元素：不是动态生成的，这里是#activityBody
             */
            $("#activityBody").on("click",$("input[name=xz]"),function(){
                $("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);
            })



            /*为删除按钮绑定事件*/
            $("#deleteBtn").click(function () {
                //找到复选框中所有挑勾的jquery
                var $xz=$("input[name=xz]:checked");

                if ($xz.length==0){
                    alert("请选择需要删除的记录");
                }else {

                    //url:
                    //拼接参数

                    var param="";
                    //将$xz 中每一个dom对象遍历出来，取其value值，相当于取得需要删除记录的id
                    for (var i=0;i<$xz.length;i++){
                        param += "id="+$($xz[i]).val();
                        //如果不是最后一条，需要在后面追加 &

                        if (i<$xz.length-1){
                            param+="&";
                        }

                    }

                    $.ajax({
                        url:"workbench/activity/delete.do",
                        data:param,
                        type:"post",
                        dataType:"json",
                        success: function (data){
                            /*
                            * data
                            *       {"success":true/false}
                            * */
                            if (data.success){
                                pageList(1,2);
                            }else{
                                alert("删除失败");
                            }
                        }
                    })


                }

            })
        })





        /*
        *   对于所有的关系数据库，做前端的分页相关操作的基础组件
        *   就是pageNo和pageSize
        *   pageNo:页码
        *   pageSize:每页展现的记录
        *
        *   pageList方法：就是发出ajax请求到后台，从后台取得最新的市场活动信息列表数据
        *       通过响应回来的数据，局部刷新市场活动信息列表
        *
        *   我们都在哪些情况下，需要调用pageList方法（刷新市场活动列表）
        *       1）点击左侧菜单中的市场活动链接
        *       2）创建、修改、删除后，需要刷新市场活动列表
        *       3）点击查询按钮的时候
        *       4）点击分页组件的时候
        *
        * */
        function pageList(pageNo,pageSize){
            //将全选的复选框 的勾 去掉
            $("#qx").prop("checked",false);

            //查询前，将隐藏域中保存的信息取出来，重新赋予搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-startData").val($.trim($("#hidden-startDate").val()));
            $("#search-endData").val($.trim($("#hidden-endDate").val()));
            $.ajax({
                url:"workbench/activity/pageList.do",
                data:{
                    "pageNo":pageNo,
                    "pageSize":pageSize,
                    "name":$.trim($("#search-name").val()),
                    "owner":$.trim($("#search-owner").val()),
                    "startDate":$.trim($("#search-startDate").val()),
                    "endDate":$.trim($("#search-endDate").val())
                },
                type:"get",
                dataType:"json",
                success: function (data){
                    /*
                    *   data
                    *       我们需要的：[{市场活动1},{2},{3}]
                    *       分页插件需要的：查询出来的总记录数
                    *       {"total":100}
                    *
                    *       {"total":100,"dataList":[{市场活动1},{2},{3}]}
                    * */
                    var html="";
                    //每一个n，就是一个市场活动对象
                    $.each(data.dataList, function (i,n) {
                       html += '<tr class="active">';
                       html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
                       html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.jsp\';">'+n.name+'</a></td>';
                       html += '<td>'+n.owner+'</td>';
                       html += '<td>'+n.startDate+'</td>';
                       html += '<td>'+n.endDate+'</td>';
                       html += '</tr>';
                    })
                    $("#activityBody").html(html);
                //    计算总页数
                    var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
                //数据处理完毕后，结合分页插件，对前端展现分页信息（插件直接复制，不求掌握）
                    $("#activityPage").bs_pagination({
                        currentPage:pageNo,//页码
                        rowsPerPage:pageSize,//每页展现记录数
                        maxRowsPerPage: 20, //每页最多显示的记录数
                        totalPages:totalPages,//总页数
                        totalRows:data.totalPages,//总记录数
                        visiblePageLinks: 5,//显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsDefaultInfo: true,

                        //回调函数，点击分页组件的时候触发
                        onChangePage:function (event,data) {
                            pageList(data.currentPage,data.rowsPerPage)//里面的参数不要动，
                        }
                    });
                }
            })
        }

    </script>
</head>
<body>
    <input type="hidden" id="hidden-name" />
    <input type="hidden" id="hidden-owner" />
    <input type="hidden" id="hidden-startData" />
    <input type="hidden" id="hidden-endData" />
<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="activityAddForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">

                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-startDate" />
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control time" id="create-endDate" />
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                    <%-- data-dismiss="modal" 表示关闭模态窗口--%>
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <option>zhangsan</option>
                                <option>lisi</option>
                                <option>wangwu</option>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="search-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control time" type="text" id="search-startDate"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control time" type="text" id="search-endDate">
                    </div>
                </div>

                <button type="button" id="search-Btn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <%--
                    点击创建按钮，观察两个属性和属性值
                    data-toggle="model":
                        表示触发该按钮，将要打开一个模态窗口
                    data-target="createActivityModel"
                        表示要打开哪个模态窗口，通过#id的形式找到该窗口
                    现在我们是以属性和属性值的方式写在button元素中用来打开模态窗口

                    但是这样做有问题：没有办法对按钮的功能进行扩充

                    所以未来的实际项目开发中，对于触发模态窗口的操作，一定不要写死在元素中
                    应该由我们自己写js代码来操作



                --%>

                <!--
                  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                -->
                <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="activityBody">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                </tr>--%>
                </tbody>
            </table>
        </div>
        <div style="height: 50px; position: relative;top: 30px;">
            <div id="activityPage">

            </div>
        </div>
    </div>

</div>
</body>
</html>