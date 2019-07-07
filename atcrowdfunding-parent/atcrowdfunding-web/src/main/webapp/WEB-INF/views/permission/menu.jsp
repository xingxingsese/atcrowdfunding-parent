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
	<%pageContext.setAttribute("title", "菜单维护");%>
	<!--顶部导航  -->
	<%@ include file="/include/top-nav.jsp"%>

	<div class="container-fluid">
		<div class="row">

			<!--  侧栏导航-->
			<%@ include file="/include/side-bar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
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
	
	<!-- 菜单添加模态框 -->
	<div class="modal fade" id="menuAddModel" tabindex="-1" role="dialog" >
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" >菜单添加</h4>
		      </div>
		    <form id="menuAddForm">
		      <div class="modal-body">
		      	<input type="hidden" name="pid" >
			       <div class="form-group">
					    <label >菜单名称</label>
					    <input type="text" class="form-control"  name="name" >
				  </div>
				  <div class="form-group">
					    <label >菜单图标</label>
					    <input type="text" class="form-control"  name="icon" >
				  </div>
				  <div class="form-group"> 
					    <label >菜单路径</label>
					    <input type="text" class="form-control"  name="url" >
				  </div>
				 </div>
			</form>
		      
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        <button type="button" class="btn btn-primary" id="saveMenuBtn">保存</button>
		      </div>
		    </div>
		  </div>
	</div>
	
	<!-- 菜单修改模态框 -->
	<div class="modal fade" id="menuupdateModel" tabindex="-1" role="dialog" >
		  <div class="modal-dialog" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" >菜单修改</h4>
		      </div>
		      <div class="modal-body">
			    <form id="menuUpdateForm">
			      <div class="modal-body">
			      	<input type="hidden" name="pid" >
			      	<input type="hidden" name="id">
				       <div class="form-group">
						    <label >菜单名称</label>
						    <input type="text" class="form-control"  name="name" >
					  </div>
					  <div class="form-group">
						    <label >菜单图标</label>
						    <input type="text" class="form-control"  name="icon" >
					  </div>
					  <div class="form-group"> 
						    <label >菜单路径</label>
						    <input type="text" class="form-control"  name="url" >
					  </div>
					 </div>
				</form>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
		        <button type="button" class="btn btn-primary" id="updateMenuBtn">修改</button>
		      </div>
		    </div>
		  </div>
	</div>
	
	<!-- 树形结构展示菜单 -->
	
	
	<script type="text/javascript">
		//ztree对象
	var ztreeObj = null;
		//文档加载完成后调用这个方法
	$(function(){
		//显示数据
		initMenuTree();
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
		var addBtn = $("<button menuid='"+treeNode.id+"' title='添加' class='btn btn-success btn-xs  glyphicon glyphicon-plus'></button> ");
		//删除按钮
		var deleteBen = $("<button menuid='"+treeNode.id+"' title='删除' class='btn btn-danger btn-xs  glyphicon glyphicon-minus'></button> ");
		//修改按钮
		var updateBen = $("<button menuid='"+treeNode.id+"' title='修改' class='btn btn-primary btn-xs  glyphicon glyphicon-pencil'></button> ");
		//创建span标签往这个标签里面添加按钮
		var btnGroup = $("<span id='"+tid+"_btngroup' class='curdBtnGroup'></span>");
		
		var length = 0;
		
		try{
			length = treeNode.children.length;
		}catch(e){
			length = 0;
		}
		if(treeNode.pid==0 && length>0){
			//如果当前元素是父元素,有子菜单 有添加,删除和修改按钮
			btnGroup.append(addBtn).append(" ").append(updateBen);
		}else if(treeNode.pid==0 && length==0){
			//如果当前元素是父元素,没有子菜单,只有添加
			btnGroup.append(addBtn).append(" ").append(deleteBen);
		}else if(treeNode.pid>0){
			//如果当前是元素是子菜单,只有删除和修改
			btnGroup.append(deleteBen).append(" ").append(updateBen);
		}else if(treeNode.id==0){
			//系统权限菜单
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
	function initMenuTree(){
		var setting = {
				data: {
					simpleData: {
						enable: true,
						pIdKey: "pid"
					},
					key:{
						url: "haha"
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
			//以get方式在当前目录下给menu/list发送请求,成功后回调函数取得data
			//这个data里就是查询到的各种数据
		$.get("${ctx}/menu/list",function(data){
			zNodes = data;
			//给数组添加一个数据
			zNodes.push({id:0,name:"系统权限菜单"});
			//注意:ajax是异步的,所以调用数据展示的代码必须放在ajax代码里面
			//初始化树
		ztreeObj = 	$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			//将整个znode树展开
			ztreeObj.expandAll(true);
		});
	}
	
	</script>
	<!-- 菜单的增删改 -->
	<script type="text/javascript">
		$("#treeDemo").on("click",".curdBtnGroup",function(e){
			//传入当前被点击的元素
			var target = e.target;
			//如果被点击的按钮包含addbtn 就是点击的添加方法
			if($(target).hasClass("btn-success")){
				
				addMenu($(target).attr("menuid"));
				
			}if($(target).hasClass("btn-danger")){
				deleteMenu($(target).attr("menuid"));
				
			}if($(target).hasClass("btn-primary")){
				updateMenu($(target).attr("menuid"));
			}
		});
		
			
			//添加菜单
			function addMenu(menuid){
				$("#menuAddModel input[name='pid']").val(menuid);
				//打开菜单添加的模态框
				$("#menuAddModel").modal({
					show:true,
					backdrop:'static'
				});
			}
		
			//修改菜单
			function updateMenu(menuid){
				//去数据库查询出这个菜单的信息
				$.get("${ctx}/menu/get?id="+menuid,function(data){
					//回显模态框内容
					$("#menuupdateModel input[name='id']").val(data.id);
					$("#menuupdateModel input[name='pid']").val(data.pid);
					$("#menuupdateModel input[name='name']").val(data.name);
					$("#menuupdateModel input[name='icon']").val(data.icon);
					$("#menuupdateModel input[name='url']").val(data.url);
				});	
			
				//打开菜单修改的模态框
				$("#menuupdateModel").modal({
					show:true,
					backdrop:'static'
				});
			}
			
			//给添加的保存按钮绑定单击事件
			$("#saveMenuBtn").click(function(){
				//serialize() 自动将表单的内容转换为key-value的字符串
				
				$.post("${ctx}/menu/add",$("#menuAddForm").serialize(),function(data){
					if(data=="ok"){
						layer.msg("保存成功");
						
					}else{
						layer.msg("保存失败");
					}
					//关闭模态框
					$("#menuAddModal").modal("hide");
					//刷新数据
					initMenuTree(); 
				});
			});
			//给修改按钮绑定单击事件
			$("#updateMenuBtn").click(function(){
				$.post("${ctx}/menu/update",$("#menuUpdateForm").serialize(),function(data) {
					
					if(data=="ok"){
						layer.msg("修改成功");
						
					}else{
						layer.msg("修改失败");
					}
					//关闭模态框
					$("#menuupdateModel").modal("hide");
					//刷新数据
					initMenuTree(); 
			});
			})
			//给删除按钮绑定单击事件
			function deleteMenu(menuid){
				layer.confirm("确认删除【id为："+menuid+"】吗？",{icon: 3, title:'删除提示'},function(){
					//确定的回调函数
					$.get("${ctx}/menu/delete?id="+menuid,function(){
						layer.msg("删除成功");
						initMenuTree();
					});
				},
				function(){
					//取消的毁掉函数
					layer.msg("菜单删除已经取消....");
				}
				);
			}
			
		
	</script>
</body>
</html>
