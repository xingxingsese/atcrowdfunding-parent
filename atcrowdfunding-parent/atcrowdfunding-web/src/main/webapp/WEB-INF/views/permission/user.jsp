<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<link rel="stylesheet"
	href="${ctx}/static/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/css/font-awesome.min.css">
<link rel="stylesheet" href="${ctx}/static/css/main.css">
<style>
.tree li {
	list-style-type: none;
	cursor: pointer;
}

table tbody tr:nth-child(odd) {
	background: #F4F4F4;
}

table tbody td:nth-child(even) {
	color: #C00;
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

			<!--侧边栏 -->
			<%@include file="/include/side-bar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float: left;"
							action="${ctx }/admin/index.html">
							<div class="form-group has-feedback">
								<div class="input-group">

									<div class="input-group-addon">查询条件</div>
									<input class="form-control has-success" type="text"
										name="condition" placeholder="请输入查询条件"
										value="${sessionScope.condition}">
								</div>
							</div>
							<button type="submit" class="btn btn-warning">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>
						<button type="button" class="btn btn-danger" id="deleteAllBtn"
							style="float: right; margin-left: 10px;">
							<i class=" glyphicon glyphicon-remove"></i> 删除
						</button>
						<button type="button" class="btn btn-primary"
							style="float: right;"
							onclick="location.href='${ctx}/user/add.html'">
							<i class="glyphicon glyphicon-plus"></i> 新增
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
									<tr>
										<th width="30">#</th>
										<th width="30"><input type="checkbox" id="allCheckBtn"></th>
										<th>账号</th>
										<th>名称</th>
										<th>邮箱地址</th>
										<th width="100">操作</th>
									</tr>
								</thead>

								<tbody>
									<c:forEach items="${page.list }" var="admin">
										<tr>
											<td>${admin.id }</td>
											<td><input type="checkbox" class="checkItem"></td>
											<td>${admin.loginacct }</td>
											<td>${admin.username }</td>
											<td>${admin.email }</td>
											<td>
												<button type="button" class="btn btn-success btn-xs" 
												onclick="location.href='${ctx}/user/assignRole.html?id=${admin.id }'">
													<i class=" glyphicon glyphicon-check"></i>
												</button>
												<button type="button" class="btn btn-primary btn-xs"
													onclick="location.href='${ctx}/user/edit.html?id=${admin.id }'">
													<i class=" glyphicon glyphicon-pencil"></i>
												</button>
												<button type="button" class="btn btn-danger btn-xs"
													onclick="deleteAdmin(${admin.id },'${admin.username }')">
													<i class=" glyphicon glyphicon-remove"></i>
												</button>
											</td>
										</tr>
									</c:forEach>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<ul class="pagination">

												<!-- 有上一页再显示 -->
												<li><a href="${ctx}/admin/index.html?pn=1">首页</a></li>
												<c:if test="${page.hasPreviousPage }">
													<li><a
														href="${ctx}/admin/index.html?pn=${page.prePage }&condition=${sessionScope.condition}">上一页</a></li>
												</c:if>

												<!-- 连续分页 -->
												<c:forEach items="${page.navigatepageNums }" var="num">
													<!-- 如果相等就正在遍历当前页 -->
													<c:if test="${num == page.pageNum }">
														<!--当前页码高亮  -->
														<li class="active"><a
															href="${ctx}/admin/index.html?pn=${num }&condition=${sessionScope.condition}">${num }
																<span class="sr-only">(current)</span>
														</a></li>
													</c:if>

													<!-- 不是当前页 -->
													<c:if test="${num !=page.pageNum }">
														<li><a
															href="${ctx}/admin/index.html?pn=${num }&condition=${sessionScope.condition}">${num }</a></li>
													</c:if>
												</c:forEach>

												<c:if test="${page.hasNextPage }">
													<li><a
														href="${ctx}/admin/index.html?pn=${page.nextPage }&condition=${sessionScope.condition}">下一页</a></li>
												</c:if>

												<li><a
													href="${ctx}/admin/index.html?pn=${page.pages }&condition=${sessionScope.condition}">末页</a></li>
											</ul>
										</td>
									</tr>

								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="/include/common-js.jsp"%>
	<script type="text/javascript">
			function deleteAdmin(id,name){
				layer.confirm("确认要删除"+name+"用户吗?",  {icon: 3, title:'提示'}, function(){
					//确定删除的回调函数
				   location.href="${ctx}/user/delete?id="+id;
				}, function(){
					//取消的回雕函数
				    layer.msg("已取消");
				});
			}
			
		//批量删除
		$("#allCheckBtn").click(function(){
			//获取到当前这个按钮的勾选状态
			//this永远都是dom对象,没办法直接调用jquery方法,我们需要转换为jquery对象
			//console 给浏览器的控制台打印对象信息
			//attr() 获取标签上的属性,一定要写在标签上的
			//prop() 获取标签的属性,紫瑶标签具有的属性改变了,就可以正确的用prop获取到,
			// 获取标签的属性优先选择使用prop
			//console.log($(this).prop("checked"));
			
			$(".checkItem").prop("checked",$(this).prop("checked"));
		});
		
		// 单个check钩中,全局的大check也得勾中(单个/全局的状态同步)
		$(".checkItem").click(function(){
			//checkItem的总数量
			var total = $(".checkItem").length;
			//获取当前有多少个被勾中
			var checked = $(".checkItem:checked").length;
			
			$("#allCheckBtn").prop("checked",checked==total);
		});
		
		//批量删除
		$("#deleteAllBtn").click(function(){
			//获取到当前所有被选中的id
			var checked =  $(".checkItem:checked");
			
			if(checked.length == 0 ){
				layer.alert("您还没有选择任何用户");
			}else{
				var ids = "";
				//遍历元素
				$.each(checked,function(){
					//this代表当前对象,parent找他的父类,find找他父类的父类的子类,其中的第1个td
					//然后获取他的id
					ids+=$(this).parent().parent().find("td:eq(0)").text()+",";
				});			
					layer.confirm("确认要删除{"+ids+"}这些人吗?",{icon:3,tile:"删除提示"},
							function(){
						//携带要删除的id跳转到这个这面
						location.href="${ctx}/user/batch/delete?ids="+ids;
						},
						function(){
							layer.msg("取消删除")
						})	
				}
			});
		
	</script>

</body>
</html>
