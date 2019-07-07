package com.atguigu.atcrowdfunding.controller.permission;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.alibaba.druid.util.StringUtils;
import com.atguigu.atcrowdfunding.api.RoleService;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.constant.AppConstant;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;



@RestController
public class RoleAjaxCrudController {
	
	@Autowired
	RoleService roleService;
	
	//修改指定id的role
	@PostMapping("/role/update")
	public String updateRole(TRole role) {
		roleService.updateRole(role);
		return "ok";
	}
	
	//查询role
	@GetMapping("/role/get")
	public TRole getRole(@RequestParam("id")Integer id) {
		TRole role = roleService.getRoleById(id);
		return role;
	}

	//单个删除和批量删除的集合
	@GetMapping("/role/delete")
	public String deleteRole(@RequestParam("ids")String ids) {
		//判断这个字符串是否是空的
		if(!StringUtils.isEmpty(ids)) {
			//可能是多个id分割开
			String[] split = ids.split(",");
			for (String string : split) {
				try {
					int id = Integer.parseInt(string);
					roleService.deleteRole(id);
				} catch (NumberFormatException e) {
				}
			}
			return "ok";
		}
		return "fail";
	}
	
	//增加用户
	@PostMapping("/role/add")
	public String addRole(TRole role) {
		roleService.addRole(role);
		 //添加ResponseBody 页面就不会跳转,告诉浏览器操作是否成功
		return "ok";
	}
	
	
	
	@GetMapping("/role/list")
	public PageInfo<TRole> rolelist(@RequestParam(value = "pn",defaultValue="1")Integer pn,
								@RequestParam(value="ps",defaultValue=AppConstant.DEFAULT_PAGE_SIZE)Integer ps,
								@RequestParam(value="condition",defaultValue="")String condition) {
		//分页展示数据
		PageHelper.startPage(pn,ps);
		//查询到所有数据
		//List<TRole> roles = roleService.getAllRole();
		List<TRole> roles = roleService.getAllrolesByCondition(condition);
		//封装: 把找到的所有数据封装到pageInfo对象中,
		PageInfo<TRole> pageInfo = new PageInfo<TRole>(roles,5);
		
		return pageInfo;
	}
}
