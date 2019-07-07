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
<link rel="stylesheet" href="${ctx}/static/css/doc.min.css">
<link rel="stylesheet" href="${ctx}/static/ztree/zTreeStyle.css">
<style>
.tree li {
	list-style-type: none;
	cursor: pointer;
}
</style>
</head>

<body>
	<%pageContext.setAttribute("title", "权限维护");%>
	<!--顶部导航  -->
	<%@ include file="/include/top-nav.jsp"%>

	<div class="container-fluid">
		<div class="row">

			<!--  侧栏导航-->
			<%@ include file="/include/side-bar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-th-list"></i> 权限列表
						<div style="float: right; cursor: pointer;" data-toggle="modal"
							data-target="#myModal">
							<i class="glyphicon glyphicon-question-sign"></i>
						</div>
					</div>
					<div class="panel-body">
						<ul id="treeDemo" class="ztree"></ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@ include file="/include/common-js.jsp" %>
	
	<!-- 权限添加模态框 -->
	<div class="modal fade" id="permissionAddModel" tabindex="-1" role="dialog" >
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" >权限添加</h4>
		      </div>
		    <form id="permissionAddForm">
		      <div class="modal-body">
		      	<input type="hidden" name="pid" >
			       <div class="form-group">
					    <label >权限名称</label>
					    <input type="text" class="form-control"  name="title" >
				  </div>
				  <div class="form-group">
					    <label >权限图标</label>
					    <input type="text" class="form-control"  name="icon" >
				  </div>
				  <div class="form-group"> 
					    <label >权限标识 </label>
					    <input type="text" class="form-control"  name="name" >
				  </div>
				 </div>
			</form>
		      
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        <button type="button" class="btn btn-primary" id="savePermissionBtn">保存</button>
		      </div>
		    </div>
		  </div>
	</div>
	
	<!-- 权限修改模态框 -->
	<div class="modal fade" id="permissionupdateModel" tabindex="-1" role="dialog" >
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" >权限修改</h4>
		      </div>
		      <div class="modal-body">
			    <form id="permissionUpdateForm">
			      <div class="modal-body">
			      	<input type="hidden" name="pid" >
			      	<input type="hidden" name="id">
				       <div class="form-group">
						    <label >权限名称</label>
						    <input type="text" class="form-control"  name="title" >
					  </div>
					  <div class="form-group">
						    <label >权限图标</label>
						    <input type="text" class="form-control"  name="icon" >
					  </div>
					  <div class="form-group"> 
						    <label >权限标识</label>
						    <input type="text" class="form-control"  name="name" >
					  </div>
					 </div>
				</form>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        <button type="button" class="btn btn-primary" id="updatePermissionBtn">修改</button>
		      </div>
		    </div>
		  </div>
	</div>
	
	<!-- 权限分配菜单模态框 -->
	<div class="modal fade" id="permissionRoleAssignModal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title">权限可操作的菜单</h4>
	      </div>
	      <div class="modal-body">
	      		<!-- 准备一个菜单树 -->
	      		<ul class="ztree" id="menuTree"></ul>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="updatePermissionMenuBtn">修改</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 获取和展示菜单的整个树 -->
	<script type="text/javascript">
		var menuZtreeObj =null;
		$(function(){
			initMenuTree();
		});
		
	
    //初始化菜单树
    function initMenuTree(){
    	//1、导入js和css
        //2、准备好树形节点；
        //3、显示在ul里面
    	var setting = {
    			data: {
    				simpleData: {
    					enable: true,
    					pIdKey: "pid",
    				},
    				key:{
    					url: "haha"
        			}
    			},
    			view:{
    				addDiyDom: showMyIcon//显示自定义图标
        		},
        		check: {
        			//打开勾选框
    				enable: true
    			}
        		
    	};var zNodes = null;
    	$.get("${ctx}/menu/list",function(data){
    		zNodes = data;
    		zNodes.push({id:0,name:"系统权限菜单"});//给数组添加一个数据
    		menuZtreeObj = $.fn.zTree.init($("#menuTree"), setting, zNodes);
    		menuZtreeObj.expandAll(true);
        });
    }
	</script>
	
	<!-- 树形结构展示权限 -->
	<script type="text/javascript">
		//ztree对象
	var ztreeObj = null;
		//文档加载完成后调用这个方法
	$(function(){
		//显示数据
		initPermissionTree();
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
	//显示自定义的按钮组
	function showCrudBtnGroup(treeId, treeNode){
		//console.log(treeNode);
		var tid =treeNode.tId;
		//添加按钮
		var addBtn = $("<button permissionid='"+treeNode.id+"' title='添加' class='btn btn-success btn-xs  glyphicon glyphicon-plus'></button> ");
		//删除按钮
		var deleteBen = $("<button permissionid='"+treeNode.id+"' title='删除' class='btn btn-danger btn-xs  glyphicon glyphicon-minus'></button> ");
		//修改按钮
		var updateBen = $("<button permissionid='"+treeNode.id+"' title='修改' class='btn btn-primary btn-xs  glyphicon glyphicon-pencil'></button> ");
		//分配菜单
		var assignMenuBtn = $("<button permissionid='"+treeNode.id+"' title='分配菜单' class='btn btn-info btn-xs glyphicon glyphicon-th-list'></button> ");
		//创建span标签往这个标签里面添加按钮
		var btnGroup = $("<span id='"+tid+"_btngroup' class='curdBtnGroup'></span>");
		
		var length = 0;
		
		try{
			length = treeNode.children.length;
		}catch(e){
			length = 0;
		}
		if(treeNode.pid==0 && length>0){
			//如果当前元素是父元素,有子权限 有添加,删除和修改按钮
			btnGroup.append(addBtn).append(" ").append(updateBen);
		}else if(treeNode.pid==0 && length==0){
			//如果当前元素是父元素,没有子权限,只有添加
			btnGroup.append(addBtn).append(" ").append(deleteBen).append(" ").append(updateBen);
		}else if(treeNode.pid>0){
			//如果当前是元素是子权限,只有删除和修改
			btnGroup.append(deleteBen).append(" ").append(updateBen).append(" ").append(assignMenuBtn);
		}else if(treeNode.id==0){
			//系统权限权限
			btnGroup.append(addBtn);
		}
			if($("#"+tid+"_a").nextAll("#"+tid+"_btngroup").length==0){
				$("#"+tid+"_a").after(btnGroup);
			}
	}
	//移除其他组的按钮
	function removeCrudBtnGroup(treeId, treeNode){
		//鼠标从当前元素移走
		var tid =treeNode.tId;
		$("#"+tid+"_a").nextAll("#"+tid+"_btngroup").remove();
	}
	/* 使用树形结构
	1 导入js和css  
	2 准备好树形节点
	3 显示在ul里面
	*/
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
					addHoverDom:showCrudBtnGroup,// 鼠标移入显示自定义btn按钮
					removeHoverDom:removeCrudBtnGroup//移除其他的按钮组
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
	}
	
	</script>
	<!-- 权限的增删改 -->
	<script type="text/javascript">
		$("#treeDemo").on("click",".curdBtnGroup",function(e){
			//传入当前被点击的元素
			var target = e.target;
			//如果被点击的按钮包含addbtn 就是点击的添加方法
			if($(target).hasClass("btn-success")){
				
				addPermission($(target).attr("permissionid"));
				
			}if($(target).hasClass("btn-danger")){
				deletePermission($(target).attr("permissionid"));
				
			}if($(target).hasClass("btn-primary")){
				updatePermission($(target).attr("permissionid"));
			}if($(target).hasClass("btn-info")){
				//分配这个权限可以操作哪些菜单
				assignPermissionsMenu($(target).attr("permissionid"));
			}
		});
		//打开给权限分配菜单的模态框
		function assignPermissionsMenu(permissionid){
			globalPermissionId = permissionid;
			//回显当前权限能操作的菜单
			$.get("${ctx}/menu/permisson/get?pid="+permissionid,function(data){
				$.each(data,function(){
					//找到ztree中id为我们指定值的节点
					var treeNode = menuZtreeObj.getNodeByParam("id",this.id,null);
					menuZtreeObj.checkNode(treeNode,true,false);
				});
				
			});
			// 打开菜单树的模态框
			$("#permissionRoleAssignModal").modal({
				show:true,
				backdrop:'static'
			});
		}
		
		//点击按钮给权限分配菜单
		$("#updatePermissionMenuBtn").click(function(){
			//所有被选中的节点id
			var checkedNode = menuZtreeObj.getCheckedNodes(true);
			var menuIds = "";
			$.each(checkedNode,function(){
				if(this.id != 0){
					menuIds += this.id+",";
				}
			});
			//发送请求进行保存
			$.post("${ctx}/menu/permisson/save",{"permissionId":globalPermissionId,
				"menuIds":menuIds},function(data){
					if(data =="ok"){
						layer.msg("权限的菜单分配完成");
						$("#permissionRoleAssignModal").modal("hide");
					}
				});
			
			
			
		});
		//添加权限  addPermission 
		function addPermission(permissionid){
			$("#permissionAddModel input[name='pid']").val(permissionid);
			//打开权限添加的模态框
			$("#permissionAddModel").modal({
				show:true,
				backdrop:'static'
			});
		}
		
			//修改权限
			function updatePermission(permissionid){
				//去数据库查询出这个权限的信息
				$.get("${ctx}/permission/get?id="+permissionid,function(data){
					//回显模态框内容
					$("#permissionupdateModel input[name='id']").val(data.id);
					$("#permissionupdateModel input[name='pid']").val(data.pid);
					$("#permissionupdateModel input[name='title']").val(data.title);
					$("#permissionupdateModel input[name='icon']").val(data.icon);
					$("#permissionupdateModel input[name='name']").val(data.name);
				});	
			
				//打开权限修改的模态框
				$("#permissionupdateModel").modal({
					show:true,
					backdrop:'static'
				});
			}
			
			//给添加的保存按钮绑定单击事件
			$("#savePermissionBtn").click(function(){
				//serialize() 自动将表单的内容转换为key-value的字符串
				
				$.post("${ctx}/permission/add",$("#permissionAddForm").serialize(),function(data){
					if(data=="ok"){
						layer.msg("保存成功");
						
					}else{
						layer.msg("保存失败");
					}
					//关闭模态框
					$("#permissionAddModal").modal("hide");
					//刷新数据
					initPermissionTree(); 
				});
			});
			//给修改按钮绑定单击事件
			$("#updatePermissionBtn").click(function(){
				$.post("${ctx}/permission/update",$("#permissionUpdateForm").serialize(),function(data) {
					
					if(data=="ok"){
						layer.msg("修改成功");
						
					}else{
						layer.msg("修改失败");
					}
					//关闭模态框
					$("#permissionupdateModel").modal("hide");
					//刷新数据
					initPermissionTree(); 
			});
			})
			//给删除按钮绑定单击事件
			function deletePermission(permissionid){
				layer.confirm("确认删除【id为："+permissionid+"】吗？",{icon: 3, title:'删除提示'},function(){
					//确定的回调函数
					$.get("${ctx}/permission/delete?id="+permissionid,function(){
						layer.msg("删除成功");
						initPermissionTree();
					});
				},
				function(){
					//取消的毁掉函数
					layer.msg("权限删除已经取消....");
				}
				);
			}
			
		
	</script>
</body>
</html>
