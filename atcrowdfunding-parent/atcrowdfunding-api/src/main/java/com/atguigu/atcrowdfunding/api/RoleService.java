package com.atguigu.atcrowdfunding.api;

import java.util.List;

import com.atguigu.atcrowdfunding.bean.TRole;

public interface RoleService {
	/**
	 * 返回所有的role数据
	 * @return
	 */
	List<TRole> getAllRole();
	//查询条件
	public List<TRole> getAllrolesByCondition(String condition);
	//新增用户
	void addRole(TRole role);
	//删除单个角色
	void deleteRole(int id);
	//根据id查询
	TRole getRoleById(Integer id);
	//修改指定idrole
	void updateRole(TRole role);
	//查找用户已有的角色
	List<TRole> getUserHasRoles(Integer id);
	//查找用户没有的角色
	List<TRole> getUserUnRoles(Integer id);
	//给用户分配指定角色
	void assignUserRole(Integer uid, String rids);
	//给用户删除指定角色
	void unAssignUserRole(Integer uid, String rids);
}
