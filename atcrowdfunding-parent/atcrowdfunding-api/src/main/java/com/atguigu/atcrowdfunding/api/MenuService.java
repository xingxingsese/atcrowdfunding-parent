package com.atguigu.atcrowdfunding.api;

import java.util.List;

import javax.xml.ws.ServiceMode;

import com.atguigu.atcrowdfunding.bean.TMenu;

@ServiceMode
public interface MenuService {
	
	//查询所有菜单
	List<TMenu> getAllMenus();
	//增加
	void saveMenu(TMenu menu);
	//修改
	void updateMenu(TMenu menu);
	//删除
	void deleteMenu(Integer id);
	//根据id查询
	TMenu getMenuById(Integer id);
	//给指定id分配它可以操作的菜单
	void saveMenuPermissions(Integer permissionId, String menuIds);

}
