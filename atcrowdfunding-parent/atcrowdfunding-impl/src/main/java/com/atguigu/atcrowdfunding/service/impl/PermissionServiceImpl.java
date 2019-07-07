package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.druid.util.StringUtils;
import com.atguigu.atcrowdfunding.api.PermissionService;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TRolePermissionExample;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;
import com.atguigu.atcrowdfunding.mapper.TRolePermissionMapper;

@Service
public class PermissionServiceImpl implements PermissionService {

	@Autowired
	TPermissionMapper permissionMapper;
	@Autowired
	TRolePermissionMapper rolePermissionMapper;
	
	@Autowired
	TMenuMapper menuMapper;
	// 查询所有
	@Override
	public List<TPermission> getAllPermissions() {
		// TODO Auto-generated method stub
		return permissionMapper.selectByExample(null);
	}

	// 新增
	@Override
	public void savePermission(TPermission permission) {
		// TODO Auto-generated method stub
		permissionMapper.insertSelective(permission);

	}

	// 修改
	@Override
	public void updatePermission(TPermission permission) {
		// TODO Auto-generated method stub
		permissionMapper.updateByPrimaryKeySelective(permission);
	}

	// 删除
	@Override
	public void deletePermission(Integer id) {
		// TODO Auto-generated method stub
		permissionMapper.deleteByPrimaryKey(id);
	}

	// 查询某个
	@Override
	public TPermission getPermissionById(Integer id) {
		// TODO Auto-generated method stub
		return permissionMapper.selectByPrimaryKey(id);
	}

	// 给角色分配权限
	@Override
	public void assignPermissionForRole(Integer rid, String permissionIds) {
		List<Integer> permissionIdList = new ArrayList<Integer>();
		if (!StringUtils.isEmpty(permissionIds)) {
			String[] split = permissionIds.split(",");
			for (String string : split) {
				Integer pid = Integer.parseInt(string);
				permissionIdList.add(pid);
			}
			// 插入数据之前先删除
			TRolePermissionExample example = new TRolePermissionExample();
			example.createCriteria().andRoleidEqualTo(rid)/*.andPermissionidIn(permissionIdList)*/;
			rolePermissionMapper.deleteByExample(example);
			// 批量插入角色对应的权限
			rolePermissionMapper.insertPermissonsToRoleBatch(rid, permissionIdList);
		}
	}

	// 查找指定角色的权限
	@Override
	public List<TPermission> getRolePermissions(Integer rid) {
		List<TPermission> permissions = permissionMapper.selectRolePermissions(rid);
		return permissions;
	}
	//获取当前权限对应的所有菜单
	@Override
	public List<TMenu> getMenusByPermissionId(Integer permissionId) {
		 
		return menuMapper.getMenusByPermissionId(permissionId);
	}

}
