package com.atguigu.atcrowdfunding.api;

import java.util.List;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TPermission;

public interface PermissionService {
	//查询所有
	List<TPermission> getAllPermissions();
	//增加
	void savePermission(TPermission permission);
	//修改
	void updatePermission(TPermission permission);
	//删除
	void deletePermission(Integer id);
	//查询
	TPermission getPermissionById(Integer id);
	//给角色分配权限
	void assignPermissionForRole(Integer rid, String permissionIds);
	//查找指定角色的权限
	List<TPermission> getRolePermissions(Integer rid);
	/**
	 * 按照权限id查出它可以操作的所有菜单
	 * @param permissionId 权限id
	 * @return
	 */
	List<TMenu> getMenusByPermissionId(Integer permissionId);
	
	
	
}
