package com.atguigu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.atguigu.api.UserService;
import com.atguigu.bean.Admin;

/**
 * 
 * @author lfy
 *
 */
@Controller
public class UserController {
	
	@Autowired
	UserService userService;
	
	@RequestMapping("/getAdmin")
	public String getAdmin(@RequestParam("id")Integer id,Model model) {
		Admin admin = userService.getAdmin(id);
		model.addAttribute("admin", admin);
		
		return "success";
		
	}
	

}
