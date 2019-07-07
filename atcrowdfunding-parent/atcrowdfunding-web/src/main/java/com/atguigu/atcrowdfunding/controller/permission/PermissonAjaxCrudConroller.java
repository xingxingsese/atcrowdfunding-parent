package com.atguigu.atcrowdfunding.controller.permission;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.atguigu.atcrowdfunding.api.PermissionService;
import com.atguigu.atcrowdfunding.bean.TPermission;

@RestController
public class PermissonAjaxCrudConroller {
	@Autowired
	PermissionService permissionService;
	
	
	//查找指定id的权限
	@GetMapping("/permission/role/get")
	public List<TPermission> getRolePermissions(@RequestParam("rid")Integer rid){
		
		List<TPermission> permission = permissionService.getRolePermissions(rid);
		return permission;
	}
	
	//给角色分配权限
	@PostMapping("/permission/role/assign")
	public String roleAssignPermission(@RequestParam("rid")Integer rid,
			@RequestParam("permissionIds")String permissionIds) {
		
		permissionService.assignPermissionForRole(rid,permissionIds);
		return "ok";
	}
	
	
	//获取所有权限
	@RestController
	public class PermissionAjaxCrudController {
		@Autowired
		PermissionService permissionService;
		/**
		 * 查询所有权限
		 */
		@GetMapping("/permission/list")
		public List<TPermission> getAllPermissions(){
			
			return permissionService.getAllPermissions();
		}
		//增加权限
		@PostMapping("/permission/add")
		public String savePermission(TPermission permission) {
			permissionService.savePermission(permission);
			return "ok";
		}
		//修改权限
		@PostMapping("/permission/update")
		public String updatePermission(TPermission permission) {
			permissionService.updatePermission(permission);
			return "ok";
		}
		//删除权限
		@GetMapping("/permission/delete")
		public String deletePermission(Integer id) {
			permissionService.deletePermission(id);
			return "ok";
		}
		//查询某个权限
		@GetMapping("/permission/get")
		public TPermission getPermission(Integer id) {
			
			TPermission permission = permissionService.getPermissionById(id);
			return permission;
		}
	}

}
