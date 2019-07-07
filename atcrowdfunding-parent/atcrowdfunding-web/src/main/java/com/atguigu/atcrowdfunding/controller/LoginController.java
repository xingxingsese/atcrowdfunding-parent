package com.atguigu.atcrowdfunding.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.atguigu.atcrowdfunding.api.AdminService;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.constant.AppConstant;


@Controller
public class LoginController {
	Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	AdminService adminService;
	
	//@PostMapping("/doLogin")
	public String login(String username,String password,HttpSession session,Model model) {
		logger.info("{}用户正在使用{}密码进行登入操作",username,password);
		
		//admin为null 说明帐号密码错误
		TAdmin admin = adminService.login(username,password);
		
		if(admin !=null) {
			logger.info("{}用户登录成功",username);
			//将登录成功的用户保存到session中,因为要在多个页面中使用登入成功的用户
			session.setAttribute(AppConstant.LOGIN_USER_SESSION_KEY,admin);
		}else {
			//登入不成功,来 到登入页面并提示帐号密码错误
			model.addAttribute(AppConstant.PAGE_MSG_KEY, "帐号或密码错误!");
			//帐号回显
			model.addAttribute("username",username);
			return "forward:/login.jsp";
		}
		
		//重定向到当前页面的main.html方法
		return "redirect:/main.html";
	}
	
	@GetMapping("/main.html")
	public String mianPage(HttpSession session,Model model) {
		//判断登入了没, 登入才能访问
		TAdmin loginUser = (TAdmin) session.getAttribute(AppConstant.LOGIN_USER_SESSION_KEY);
		
		if(loginUser == null) {
			//session中没有,就是没有登入,跳转到登入页面
			model.addAttribute(AppConstant.PAGE_MSG_KEY, "请先登入");
			return "forward:/login.jsp";
		}else {
			//动态的去数据库查出菜单,并且组装好
			//List<TMenu> meunus = adminService.listMenus();
			List<TMenu> meunus = adminService.listYourMenus(loginUser.getId());
			//菜单查询出来后放在session域中
			session.setAttribute(AppConstant.MENU_SESSION_KEY, meunus);
			
			
			//登入了才能访问后台主页
			return "main";
		}
		
	}
	
	@PostMapping("/login")
	public String loginPage() {
		return "forward:/login.jsp";
	}	
}
