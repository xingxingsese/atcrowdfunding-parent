package com.atguigu.atcrowdfunding.api;

import java.util.List;

import com.atguigu.atcrowdfunding.Exception.EmailExistException;
import com.atguigu.atcrowdfunding.Exception.LoginacctExistException;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;

public interface AdminService {

	TAdmin login(String username, String password);

	// 查出所有菜单组装好父子关系
	List<TMenu> listMenus();

	// 查出所有用户tadmin
	List<TAdmin> listAllAdmin();

	// 带条件查询所有admiin
	List<TAdmin> listAllAdminByCondition(String condition);

	// 按照id查询用户
	TAdmin getAdminById(Integer id);

	// 修改用户信息
	void updateAdmin(TAdmin admin);

	// 保存admin对象
	void saveAdmin(TAdmin admin) throws LoginacctExistException,EmailExistException;
	//检查用户名是否被占用
	boolean checkLoginacct(TAdmin admin);
	//检查邮箱是否被占用
	boolean checkEmail(TAdmin admin);
	//删除指定id的用户
	void deleteAdminById(Integer id);
	//根据用户id查出用户可以操作的菜单
	List<TMenu> listYourMenus(Integer id);
}
