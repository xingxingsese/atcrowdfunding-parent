package com.atguigu.atcrowdfunding.component;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;


import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;

/**
 * 用户查询服务
 * 
 * @author DELL
 *
 */
@Component("myUserDetailService")
public class MyUserDetailService implements UserDetailsService {

	@Autowired
	TAdminMapper adminMapper;
	@Autowired
	TRoleMapper roleMapper;
	@Autowired
	TPermissionMapper permissionMapper;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		TAdminExample example = new TAdminExample();// 创建查询规则
		example.createCriteria().andLoginacctEqualTo(username);// 根据用户名查询
		List<TAdmin> list = adminMapper.selectByExample(example);
		//如果用户名为null或者长度为0,代表没查出来
		if (list == null || list.size() == 0) {
			return null;
		}
		//用户数量不唯一的话,证明查询的也不对
		if (list.size() != 1) {
			return null;
			
		} else {
			TAdmin tAdmin = list.get(0);
			// 权限集合
			List<GrantedAuthority> grantedAuthoritys = new ArrayList<GrantedAuthority>();
			// 查出当前用户的角色信息
			List<TRole> roles = roleMapper.getUserHasRoles(tAdmin.getId());
			// 查出当前用户的权限信息
			for (TRole role : roles) {
				//根据id查到的角色详细信息循环遍历给name加上role_前缀
				grantedAuthoritys.add(new SimpleGrantedAuthority("ROLE_" + role.getName()));
				// 查出当前角色的所有权限放入集合
				List<TPermission> permissions = permissionMapper.selectRolePermissions(role.getId());
				//遍历这个角色中的权限
				for (TPermission permiss : permissions) {
					//获取这个权限的名字
					String name = permiss.getName();
					//如果这个权限名字不为null,添加到集合中
					if (!StringUtils.isEmpty(name)) {
						grantedAuthoritys.add(new SimpleGrantedAuthority(name));
					}
				}

			}
			MyUserDetail user = new MyUserDetail(
					tAdmin.getLoginacct(), 
					tAdmin.getUserpswd(), 
					grantedAuthoritys,
					tAdmin);
			return user;
		}

	}

}
