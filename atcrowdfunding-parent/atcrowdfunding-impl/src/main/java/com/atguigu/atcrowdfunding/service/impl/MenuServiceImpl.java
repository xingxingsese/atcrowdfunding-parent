package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.api.MenuService;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TPermissionMenuExample;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.mapper.TPermissionMenuMapper;
@Service
public class MenuServiceImpl implements MenuService{
	
	@Autowired
	TMenuMapper menuMapper;
	@Autowired
	TPermissionMenuMapper permissionMenuMapper;
	//查询出所有菜单
	@Override
	public List<TMenu> getAllMenus() {
		// TODO Auto-generated method stub
		return menuMapper.selectByExample(null);
	}
	//有选择的保存,传什么保存什么
	@Override
	public void saveMenu(TMenu menu) {
		menuMapper.insertSelective(menu);
	}
	//按照主键有选择的更新
	@Override
	public void updateMenu(TMenu menu) {
		// TODO Auto-generated method stub
		menuMapper.updateByPrimaryKeySelective(menu);
	}
	//删除
	@Override
	public void deleteMenu(Integer id) {
		// TODO Auto-generated method stub
		menuMapper.deleteByPrimaryKey(id);
	}
	//查询
	@Override
	public TMenu getMenuById(Integer id) {
		// TODO Auto-generated method stub
		return menuMapper.selectByPrimaryKey(id);
	}
	/**
	 * 给指定id分配可操作的菜单
	 * permissionId 权限id
	 * menuIds 菜单的id
	 */
	@Override
	public void saveMenuPermissions(Integer permissionId, String menuIds) {
		List<Integer> menuIdsList = new ArrayList<Integer>();
		if(!StringUtils.isEmpty(menuIds)) {
			String[] split = menuIds.split(",");
			for (String string : split) {
				int menuId = Integer.parseInt(string);
				menuIdsList.add(menuId);
			}
			
			TPermissionMenuExample example = new TPermissionMenuExample();
			//先删除这个权限对应的所有菜单
			example.createCriteria().andPermissionidEqualTo(permissionId);
			permissionMenuMapper.deleteByExample(example);
			//保存这个权限对应的所有菜单
			permissionMenuMapper.insertBatchMenuPermission(permissionId,menuIdsList);
		}
	}
	

}
