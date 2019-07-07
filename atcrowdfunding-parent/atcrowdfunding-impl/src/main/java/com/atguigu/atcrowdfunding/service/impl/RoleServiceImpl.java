package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.api.RoleService;
import com.atguigu.atcrowdfunding.bean.TAdminRoleExample;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.mapper.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;

@Service
public class RoleServiceImpl implements RoleService {

	@Autowired
	TRoleMapper roleMapper;
	@Autowired
	TAdminRoleMapper adminRoleMapper;
	
	@Override
	public List<TRole> getAllRole() {
		
		return roleMapper.selectByExample(null);
	}
	public List<TRole> getAllrolesByCondition(String condition){
		 //检索条件
		TRoleExample example = new TRoleExample();
		
		if(!StringUtils.isEmpty(condition)) {
			//创造检索条件
			example.createCriteria().andNameLike("%"+condition+"%");
		}
		return roleMapper.selectByExample(example);
	}
	//插入用户
	@Override
	public void addRole(TRole role) {
		roleMapper.insertSelective(role);
	}
	//删除单个角色
	@Override
	public void deleteRole(int id) {
		roleMapper.deleteByPrimaryKey(id);
	}
	//查询role
	@Override
	public TRole getRoleById(Integer id) {
		
		return roleMapper.selectByPrimaryKey(id);
	}
	//修改指定id的role
	@Override
	public void updateRole(TRole role) {
		
		roleMapper.updateByPrimaryKey(role);
	}
	//查询用户已有的角色
	@Override
	public List<TRole> getUserHasRoles(Integer id) {
		List<TRole> roles = roleMapper.getUserHasRoles(id);
		return roles;
	}
	//查询用户没有的角色
	@Override
	public List<TRole> getUserUnRoles(Integer id) {
		List<TRole> roles = roleMapper.getUserUnRoles(id);
		return roles;
	}
	//给用户添加指定角色
	@Override
	public void assignUserRole(Integer uid, String rids) {
		List<Integer> ridsList = new ArrayList<Integer>();
		if(!StringUtils.isEmpty(rids)) {
			String[] strings = rids.split(",");
			for (String string : strings) {
				int rid = Integer.parseInt(string);
				ridsList.add(rid);
			}
		}
		//插入之前先尝试删除
		TAdminRoleExample example = new TAdminRoleExample();
		//例子,创建标准并且admin的id等于(uid)并且角色id在(ridslist)中
		example.createCriteria().andAdminidEqualTo(uid).andRoleidIn(ridsList);
		adminRoleMapper.deleteByExample(example);
		
		//批量插入数据,但是有重复数据
		adminRoleMapper.insertBatchUserRole(uid,ridsList);
	}
	//给指定id删除角色
	@Override
	public void unAssignUserRole(Integer uid, String rids) {
		// TODO Auto-generated method stub
		List<Integer> ridsList = new ArrayList<Integer>();
		if(!StringUtils.isEmpty(rids)) {
			String[] strings = rids.split(",");
			for (String string : strings) {
				int rid = Integer.parseInt(string);
				ridsList.add(rid);
			}
		}
		//删除
		TAdminRoleExample example = new TAdminRoleExample();
		//例子,创建标准并且admin的id等于(uid)并且角色id在(ridslist)中
		example.createCriteria().andAdminidEqualTo(uid).andRoleidIn(ridsList);
		adminRoleMapper.deleteByExample(example);
	}
}
