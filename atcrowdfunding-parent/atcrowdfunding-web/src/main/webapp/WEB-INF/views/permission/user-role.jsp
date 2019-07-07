<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<link rel="stylesheet" href="${ctx}/static/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="${ctx}/static/css/font-awesome.min.css">
	<link rel="stylesheet" href="${ctx}/static/css/main.css">
	<link rel="stylesheet" href="${ctx}/static/css/doc.min.css">
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	</style>
  </head>

  <body>

 
	<%
		pageContext.setAttribute("title", "用户维护");
	%>
	<!-- 顶部导航 -->
	<%@include file="/include/top-nav.jsp"%>

    <div class="container-fluid">
      <div class="row">
      
      <!--  侧栏导航-->
	<%@ include file="/include/side-bar.jsp"%>
			
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<ol class="breadcrumb">
				  <li><a href="${ctx}/static/#">首页</a></li>
				  <li><a href="${ctx}/static/#">数据列表</a></li>
				  <li class="active">分配角色</li>
				</ol>
			<div class="panel panel-default">
			  <div class="panel-body">
				<form role="form" class="form-inline">
				  <div class="form-group">
					<label for="exampleInputPassword1">未分配角色列表</label><br>
					<select id="unAssignSelect" class="form-control" multiple size="10" style="width:200px;overflow-y:auto;">
                      <c:forEach items="${unRoles}" var="role">
                       	 <option value="${role.id }">${role.name }</option>
                      </c:forEach>
                    </select>
				  </div>
				  <div class="form-group">
                        <ul>
                            <li id="addRoleBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                            <br>
                            <li id="removeRoleBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                        </ul>
				  </div>
				  <div class="form-group" style="margin-left:40px;">
					<label for="exampleInputPassword1">已分配角色列表</label><br>
					<select id="assignSelect" class="form-control" multiple size="10" style="width:200px;overflow-y:auto;">
                        <c:forEach items="${roles }" var="role">
                        	<option value="${role.id }">${role.name }</option>
                        </c:forEach>
                    </select>
				  </div>
				</form>
			  </div>
			</div>
        </div>
      </div>
    </div>

   <%@ include file="/include/common-js.jsp"%>
   
   <script type="text/javascript">
   /*给添加按钮绑定事件  */
   	$("#addRoleBtn").click(function(){
   		//取出请求参数中携带的id
   			var uid = "${param.id}";
   			var rids = "";
   		//用:selected找select中被选中的option
   		$.each($("#unAssignSelect option:selected"),function(){
			rids+=$(this).val()+",";   			
   		});
   			location.href="${ctx}/user/assign/role?uid="+uid+"&rids="+rids;
   	});
   /* 给删除按钮绑定事件 */
   $("#removeRoleBtn").click(function(){
	   var uid = "${param.id}";
	   var rids = "";
	   $.each($("#assignSelect option:selected"),function(){
		   rids=+$(this).val()+",";
	   });
	   location.href="${ctx}/user/unassign/role?uid="+uid+"&rids="+rids;
   });
   </script>
  </body>
</html>
