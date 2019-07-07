package com.atguigu.atcrowdfunding.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class regController {
	
	@PostMapping("/reg")
	public String reg() {
		
		return "redirect:member.html";
	}
	@GetMapping("/member.html")
	public String memberPage() {
		return "member";
	}
}
