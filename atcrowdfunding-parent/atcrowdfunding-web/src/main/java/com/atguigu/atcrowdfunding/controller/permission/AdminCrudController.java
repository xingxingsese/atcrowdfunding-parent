package com.atguigu.atcrowdfunding.controller.permission;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.druid.util.StringUtils;
import com.atguigu.atcrowdfunding.Exception.EmailExistException;
import com.atguigu.atcrowdfunding.Exception.LoginacctExistException;
import com.atguigu.atcrowdfunding.api.AdminService;
import com.atguigu.atcrowdfunding.api.RoleService;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.constant.AppConstant;

@Controller
public class AdminCrudController {
	/**
	 * 如果某个请求是以html结尾那就是跳转页面,否则就是进行真正的业务操作增删改查
	 */
	Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	AdminService adminService;
	@Autowired
	RoleService roleService;
	//给用户删除指定的id角色
	@GetMapping("/user/unassign/role")
	public String unAssignUserRole(@RequestParam("uid")Integer uid,
			@RequestParam("rids")String rids) {
		roleService.unAssignUserRole(uid,rids);
		
		return "redirect:/user/assignRole.html?id="+uid;
	}
	
	
	/**
	 * 给用户添加指定的id角色
	 * @param uid 用户id
	 * @param rids 所有角色的id 用,号分割
	 * @return
	 */
	
	@GetMapping("/user/assign/role")
	public String assignUserRole(@RequestParam("uid")Integer uid,
			@RequestParam("rids")String rids) {
		roleService.assignUserRole(uid,rids);
		
		return "redirect:/user/assignRole.html?id="+uid;
	}
	//跳转到用户的角色分配页
	@GetMapping("/user/assignRole.html")
	public String toAssignRolePage(@RequestParam("id")Integer id,Model model) {
		
		//查出用户已有的的角色
		List<TRole> roles =  roleService.getUserHasRoles(id);
		//查出用户没有的角色
		List<TRole> unRoles = roleService.getUserUnRoles(id); 
		
		model.addAttribute("roles",roles);
		model.addAttribute("unRoles",unRoles);
		
		return "permission/user-role";
	}
	/**
	 * 传递所有选中的ids
	 * 
	 */
	@GetMapping("/user/batch/delete")
	public String deleteBatchAdmin(@RequestParam("ids")String ids,
			HttpSession session,Model model) {
		//取出页面中的回显
		String condition = (String) session.getAttribute(AppConstant.QUERY_CONDITION_KEY);
		//取出当前页码
		Integer pn = (Integer) session.getAttribute("pn");
		//把当前页和回显添加到模型中
		model.addAttribute("pn",pn);
		model.addAttribute("condition",condition);
		
		//分割id,并批量删除
		if(!StringUtils.isEmpty(ids)) {
			String [] split = ids.split(",");
			for (String id : split) {
				try {
					int i = Integer.parseInt(id);
					//调用业务方法
					adminService.deleteAdminById(i);
				} catch (NumberFormatException e) {			
				}
			}
		}	
		//删除后返回之前页面
		return "redirect:/admin/index.html";
	}
	//根据id删除用户
	@GetMapping("/user/delete")
	public String deleteAdmin(@RequestParam("id")Integer id,
			HttpSession session,Model model) {
		//取出页面中的回显
		String condition = (String) session.getAttribute(AppConstant.QUERY_CONDITION_KEY);
		//取出当前页码
		Integer pn = (Integer) session.getAttribute("pn");
		//把当前页和回显添加到模型中
		model.addAttribute("pn",pn);
		model.addAttribute("condition",condition);
		//调用业务方法
		adminService.deleteAdminById(id);
		//删除后返回之前页面
		return "redirect:/admin/index.html";
	}
	
	
	/**
	 * 接受添加页面的数据
	 * 
	 * 如果封装请求参数是一个对象 比如TAdmin springmvc默认会自动的将这个对象放在model中,也就是请求域中 key用的是TAdmin
	 * ;如果首字母和紧挨的字母都是大写,那名字还按这个来 key的默认规则是按照类名首字母小写的驼峰方式做的
	 */
	@PostMapping("/user/add")
	public String addAdmin(TAdmin admin, Model model) {
		logger.debug("将要添加的用户是:{}", admin);

		boolean vaile = true;

		// 可以使用异常机制,使得上层感知下层的状态
		try {
			adminService.saveAdmin(admin);
		} catch (LoginacctExistException e) {
			// 帐号被占用
			vaile = false;
			model.addAttribute("loginacctmsg", e.getMessage());
			logger.error("{}用户添加出错:{}", admin, e);
		} catch (EmailExistException e) {
			// 邮箱被占用
			vaile = false;
			model.addAttribute("emailmsg", e.getMessage());
			logger.error("{}用户添加出错:{}", admin, e);
		}
		if (vaile == false) {

			return "permission/user-add";
		}

		// 新增完成以后跳转到最后一页,利用分页合理化机制,跳转到最后一页
		return "redirect:/admin/index.html?pn=" + Integer.MAX_VALUE;
	}

	/**
	 * 跳转用户添加页面
	 */
	@GetMapping("/user/add.html")
	public String addPage() {

		return "permission/user-add";

	}

	// 处理用户修改页
	@GetMapping("/user/edit.html")
	public String toEditPage(@RequestParam("id") Integer id, Model model) {

		// 查出当前用户信息
		TAdmin admin = adminService.getAdminById(id);
		// 把查询到的数据共享到model中
		model.addAttribute("data", admin);
		return "permission/user-edit";
	}

	// 修改用户信息
	@PostMapping("/user/update")
	public String updateAdmin(TAdmin admin, HttpSession session, Model model) {
		adminService.updateAdmin(admin);
		Integer pn = (Integer) session.getAttribute("pn");
		String condition = (String) session.getAttribute(AppConstant.QUERY_CONDITION_KEY);
		// 浏览器的url地址中文一定要编码才行,Base64 和UTF-8之间来回转
		model.addAttribute("pn", pn);
		model.addAttribute("condition", condition);
		/**
		 * SpirngMVC高级特性: 往Model中存放数据 1 如果是转发到下一个页面,数据是在请求域中,用${}取出数据 2
		 * 如果是重定向到下一个页面,数据是以请求参数的方式拼接在url地址后面, 并且可以解决中文乱码问题
		 */
		// 重新来到用户列表页
		return "redirect:/admin/index.html";
	}
}
