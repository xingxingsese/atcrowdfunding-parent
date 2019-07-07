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

<link rel="stylesheet" href="${ctx}/static/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/css/font-awesome.min.css">
<link rel="stylesheet" href="${ctx}/static/css/main.css">
<link rel="stylesheet" href="${ctx}/static/ztree/zTreeStyle.css">
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
		pageContext.setAttribute("title", "角色维护");
	%>
	<!--顶部导航  -->
	<%@ include file="/include/top-nav.jsp"%>

	<div class="container-fluid">
		<div class="row">
			<!--  侧栏导航-->
			<%@ include file="/include/side-bar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float: left;">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input id="searchConditionInput"
										class="form-control has-success" type="text"
										placeholder="请输入查询条件">
								</div>
							</div>
							<button type="button" class="btn btn-warning" id="searchBtn">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>
						<button id="deleteAllRoleBtn" type="button" class="btn btn-danger"
							style="float: right; margin-left: 10px;">
							<i class=" glyphicon glyphicon-remove"></i> 删除
						</button>
						<button type="button" class="btn btn-primary"
							style="float: right;" id="openRoleAddmodelBtn">
							<i class="glyphicon glyphicon-plus"></i> 新增
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
									<tr>
										<th width="30">#</th>
										<th width="30"><input id="allCheckBtn" type="checkbox"></th>
										<th>名称</th>
										<th width="100">操作</th>
									</tr>
								</thead>

								<tbody id="content"></tbody>

								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<ul class="pagination" id="pageInfoBar">

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
	<!--模态框  添加 -->
	<div class="modal fade" id="roleAddModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="roleAddModalTitle">角色新增</h4>
				</div>
				<!--模态框中的内容  -->
				<div class="modal-body">
					<form id="roleAddForm" action="${ctx}/role/add" method="post">
						<div class="form-group">
							<label >角色名</label> 
							<input type="email" class="form-control" id="rolename_input" name="name"
								placeholder="用户名">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveRoleAddBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- model修改 -->
	<div class="modal fade" id="roleUpdateModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" >角色修改</h4>
				</div>
				
				<!--模态框中的内容  -->
				<div class="modal-body">
					<form id="roleUpdateForm" action="${ctx}/role/add" method="post">
						<div class="form-group">
						<input type="hidden" name="id" />
							<label >角色名</label> 
							<input type="email" class="form-control" id="rolename_input" name="name"
								placeholder="用户名">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="UpdateRoleAddBtn">修改</button>
				</div>
			</div>
		</div>
	</div>

	<!-- model权限维护模态框 -->
	<div class="modal fade" id="rolePermissionModal" tabindex="-1" role="dialog">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" >权限维护</h4>
				</div>
				
				<!--模态框中的内容  -->
				<div class="modal-body">
				
					<ul id="treeDemo" class="ztree"></ul>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updataRolePermissionBtn">修改</button>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/include/common-js.jsp"%>
	<!--分页带条件查询  -->
	<script type="text/javascript">
		var globalPn = 1;
		var globalPs = 3;
		var golalCondition = "";
		var golalTotal = 0;
		$(function() {
			//页面加载完成获得所有的数据
			getAllRoles(globalPn, globalPs, golalCondition);
		})
		//发送请求获取所有数据
		function getAllRoles(pn, ps, condition) {
			//从数据库取得所有数据
			$.get("${ctx}/role/list?pn=" + pn + "&ps=" + ps + "&condition="
					+ condition, function(data) {
				//构建表格的内容
				buildTableContent(data.list);
				//构建页面的分页条
				buildTablePageInfo(data);
			});
		}

		//把数据库取出的数据遍历出构建表格数据
		function buildTableContent(data) {
			//清空表单数据
			$("#content").empty();

			$.each(data,function() {
							var id = this.id;
							var name = this.name;
							//准备好按钮的单元格,复杂元素创建出来,手动修改里面的内容
							var btnTd = $("<td></td>");
							btnTd.append('<button type="button" rid="'+id+'" class="btn btn-success btn-xs rolePermissonAssignBtn"><i class=" glyphicon glyphicon-check"></i></button> ');
							btnTd.append('<button type="button" rid="'+id+'" class="btn btn-primary btn-xs roleItemUpdateBtn"><i class=" glyphicon glyphicon-pencil"></i></button> ');
							btnTd.append('<button type="button" rid="'+id+'" class="btn btn-danger btn-xs roleItemDeleteBtn"><i class=" glyphicon glyphicon-remove"></i></button>');
							//取出数据拼接展示到页面中
							//这样拼接太麻烦,换个拼接的简单方式
							//var tr = '<tr><td>'+id+'</td><td><input type="checkbox"></td><td>'+name+'</td></tr>'
							var tr = $("<tr></tr>");
							tr.append("<td>" + id + "</td>")
								.append("<td><input rid= '"+id+"' class = 'checkItem' type='checkbox'></td>")
								.append("<td>" + name + "</td>")
								.append(btnTd)
								.appendTo("#content");
							// 用$("<tr></tr>"):创建出这个对象
						});
		}
		//构造分页条
		function buildTablePageInfo(data) {
			//清空分页表数据
			$("#pageInfoBar").empty();
			golalTotal = data.pages;
			//首页和上一页
			var first = '<li tonum="1"><a >首页</a></li>';
			var prev = "<li tonum='"+data.prePage+"'><a >上一页</a></li>";
			$("#pageInfoBar").append(first);
			$("#pageInfoBar").append(prev);
			//显示连续分页
			$.each(data.navigatepageNums,function() {
				var li = "";
				//判断是否是当前页
				if (data.pageNum == this) {
					var li = '<li class="active"><a >'
							+ this
							+ '<span class="sr-only">(current)</span></a></li>';
				} else {
					li = '<li tonum="'+this+'"><a>' + this
							+ '</a></li>';
				}
				$("#pageInfoBar").append(li);
			});

			//下一页和末页
			var next = "<li tonum='"+data.nextPage+"'><a >下一页</a></li>";
			var last = "<li tonum='"+data.pages+"'><a >末页</a></li>";
			$("#pageInfoBar").append(next);
			$("#pageInfoBar").append(last);
		}

		//给分页条的每个按钮绑定单击时间,跳转到指定位置
		//click只能给已有的数据绑定事件,不能给未来元素绑定
		//可以用on()给未来元素帮事件
		//$(已经存在的父元素).on("click","目标元素选择器",function(){回调函数})
		$("#pageInfoBar").on("click", "li", function() {
			
			var pn = $(this).attr("tonum");
			globalPn = pn;
			getAllRoles(pn, globalPs, golalCondition);
		});
		$("#searchBtn").click(function() {
			//查询条件等于 这个id框内的文本值
			golalCondition = $("#searchConditionInput").val();
			getAllRoles(1, globalPs, golalCondition);
		});

		
	</script>
	
	<!--模态框  -->
	<!-- Modal添加 -->
	<script type="text/javascript">
	/*  点击新增打开模态框*/
		$("#openRoleAddmodelBtn").click(function() {
			
			var val = $("#roleAddForm input[name='name']").val("");
			
			//点击背景框不会关闭模态框
			$("#roleAddModal").modal({
				backdrop :'static',
				show :true
			});
		});
		//点击保存,提交表单给服务器保存数据
		$("#saveRoleAddBtn").click(function(){
			//找到表单提交
			//提交表单,href,等等这些都属于页面跳转方式,而不是ajax
			//为了防止页面跳转,所以我们要使用ajax方式,
			//$("#roleAddForm input:eq(0)").val();//最好不要用eq方式找数据,这样input顺序必须按这个来
			var val = $("#roleAddForm input[name='name']").val();
			//ajax提交携带数据,只需要把数据组装成对象,放在参数位置即可
			$.post("${ctx}/role/add",{"name":val},function(data){
				if(data == "ok"){
					layer.msg("保存成功");
					//关闭模态框
					$("#roleAddModal").modal('hide');
					//保存成功后把查询条件置空
					golalCondition = "";
					//跳转到最后一页展示添加的数据
					getAllRoles(golalTotal+1000,globalPs,golalCondition);
				}
			});
		});
		
	 	 //点击单个删除按钮进行删除
		$("#content").on("click",".roleItemDeleteBtn",function(){
			//找到当前删除的id的name
			var name = $(this).parents("tr").find("td:eq(2)").text();
			var that = this;
			deleteRole($(that).attr("rid"));
		});
			function deleteRole(ids){
			layer.confirm("确认删除["+ids+"]吗?",{icon: 3,title:'删除提示'},
					function(){
				//确定的回调函数
				//location.href="${ctx}/role/delete?ids="+id;
				$.get("${ctx}/role/delete?ids="+ids,function(data){
					layer.msg("角色删除完成")
					if(data == "ok"){
						//删除成功
						getAllRoles(globalPn,globalPs,golalCondition);
					}
				});
			},
			function(){
				layer.msg("删除已取消");
			}
		);
		}; 
		
		//多个删除
		$("#allCheckBtn").click(function() {
			$(".checkItem").prop("checked", $(this).prop("checked"));
		});
		
		$("#content").on("click", ".checkItem", function() {
			//checkItem的总数量
			//获取当前有多少个被勾中
			$("#allCheckBtn").prop("checked", $(".checkItem").length == $(".checkItem:checked").length);
		});
		$("#deleteAllRoleBtn").click(function(){
			var ids = "";
			$.each($(".checkItem:checked"),function(){
					ids += $(this).attr("rid")+",";
			});
			deleteRole(ids);
		});
		
		</script>
	<!--给修改按钮绑定单击事件 -->
	<script type="text/javascript">
			<!-- 1 给修改按钮绑定单击事件 -->
			$("#content").on("click",".roleItemUpdateBtn",function(){
				var rid = $(this).attr("rid");
				//2 查出当前被第点击的role的信息,并在model框中显示
				$.get("${ctx}/role/get?id="+rid,function(data){
					//3 获取data数据,显示到输入栏里
					$("#roleUpdateForm input[name='name']").val(data.name);
					$("#roleUpdateForm input[name='id']").val(data.id);
					
					//1弹出模态框
					$("#roleUpdateModal").modal({
						backdrop :'static',
						show :true
					});
				});
			});
			
			//点击修改,发送请求数据进行修改
			$("#UpdateRoleAddBtn").click(function(){
			var id =	$("#roleUpdateForm input[name='id']").val();
				var name = $("#roleUpdateForm input[name='name']").val();
				 //给服务器发送请求
				 $.post("${ctx}/role/update",{"id":id,"name":name},function(date){
					 layer.msg("修改完成");
					 //关闭model窗口
					 $("#roleUpdateModal").modal("hide");
					 //哪一页调的回到哪一页
					 getAllRoles(globalPn,globalPs,golalCondition);
				 })
			})
		</script>
	<!--权限维护模态框  -->
	<script type="text/javascript">
			<!-- 1 给权限分配按钮绑定单击事件 -->
			$("#content").on("click",".roleItemUpdateBtn",function(){
				var rid = $(this).attr("rid");
				//2 查出当前被第点击的role的信息,并在model框中显示
				$.get("${ctx}/role/get?id="+rid,function(data){
					//3 获取data数据,显示到输入栏里
					$("#roleUpdateForm input[name='name']").val(data.name);
					$("#roleUpdateForm input[name='id']").val(data.id);
					
					//1弹出模态框
					$("#roleUpdateModal").modal({
						backdrop :'static',
						show :true
					});
				});
			});
			
			//点击修改,发送请求数据进行修改
			$("#UpdateRoleAddBtn").click(function(){
			var id =	$("#roleUpdateForm input[name='id']").val();
				var name = $("#roleUpdateForm input[name='name']").val();
				 //给服务器发送请求
				 $.post("${ctx}/role/update",{"id":id,"name":name},function(date){
					 layer.msg("修改完成");
					 //关闭model窗口
					 $("#roleUpdateModal").modal("hide");
					 //哪一页调的回到哪一页
					 getAllRoles(globalPn,globalPs,golalCondition);
				 })
			})
		</script>
	<!--给角色权限树实现  -->
	<script type="text/javascript">
		//加载权限树
		var ztreeObj = null;
		//文档加载完成后调用这个方法
		$(function(){
			//显示数据
			initPermissionTree();
		});
		//初始化树形结构配置显示在ul里面
		function initPermissionTree(){
			var setting = {
					data: {
						simpleData: {
							enable: true,
							pIdKey: "pid"
						},
						key:{
							url: "haha",
							name:"title"
						}
					},
					view:{
						addDiyDom:showMyIcon,//调用这个方法显示自定义图标
						
					},check: {//勾选框
						enable: true
					}
				};
			var zNodes = null;
				//找服务器要数据
				//以get方式在当前目录下给permission/list发送请求,成功后回调函数取得data
				//这个data里就是查询到的各种数据
			$.get("${ctx}/permission/list",function(data){
				zNodes = data;
				//给数组添加一个数据
				zNodes.push({id:0,title:"系统所有权限"});
				//注意:ajax是异步的,所以调用数据展示的代码必须放在ajax代码里面
				//初始化树
			ztreeObj = 	$.fn.zTree.init($("#treeDemo"), setting, zNodes);
				//将整个znode树展开
				ztreeObj.expandAll(true);
			});
		//自定义显示图标的回调函数
		function showMyIcon(treeId, treeNode){
			//treeId 对应 zTree 的 treeId，便于用户操控
			//treeNode 需要显示自定义控件的节点 JSON 数据对象
			
			var tId = treeNode.tId; 
			var iconSpan = $("<span class='"+treeNode.icon+"'></span>");
			//查询id为tid_ico的属性,然后把class内容都清空,然后添加数据库的内容
			$("#"+tId+"_ico").removeClass();//清除默认样式
			$("#"+tId+"_ico").after(iconSpan); //使用自己的图标
		}
		
	//=======================以上是权限树的方法==========
			
		}
	</script>
	<!-- 角色权限维护功能实现 -->
	<script type="text/javascript">
		var globalRid = "";
		$("#content").on("click",".rolePermissonAssignBtn",function(){
			//获取被点击按钮的id
			globalRid = $(this).attr("rid");
			//查出这个角色之前的permisson信息,回显在权限树中
			$.get("${ctx}//permission/role/get?rid="+globalRid,function(data){
				//查看之前先清空上次树的勾选状态,把所有节点全部取消勾选
				ztreeObj.checkAllNodes(false);
				$.each(data,function(){
					//查找出勾中的节点id
					var treeNode = ztreeObj.getNodeByParam("id",this.id,null);
					//把查找出来勾中节点的id给勾中
					ztreeObj.checkNode(treeNode,true,false);
				});
			
			});
			
			//打开模态框
			$("#rolePermissionModal").modal({
				show:true,
				backdrop:'static'
			});
		});	
	
		$("#updataRolePermissionBtn").click(function(){
			//上一次点击的角色idlayer.msg(globalRid);
			//获取选中的权限id	
			var permissionIds = "";
			//getCheckedNodes(true)获取选中的权限id false获取为选中的id
			$.each(ztreeObj.getCheckedNodes(true),function(){
				if(this.id != 0){
					permissionIds +=  this.id+ ",";
				}
			});
			
			$.post("${ctx}/permission/role/assign",{"rid":globalRid,"permissionIds":permissionIds},function(data){
				if(data=="ok"){
					layer.msg("分配完成");
					$("#rolePermissionModal").modal("hide");
				}
					
			});
		});
	</script>
</body>
</html>
