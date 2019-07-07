package com.atguigu.atcrowdfunding.controller.permission;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.atguigu.atcrowdfunding.api.AdminService;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.constant.AppConstant;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;


/**
 * 所有页面跳转的请求映射
 * @author DELL
 *
 */
@Controller
public class PerminssionPageController {
	
	private static final String String = null;
	@Autowired
	AdminService adminService;
	
	//跳到菜单维护页
	@GetMapping("/menu/index.html")
	public String menuPage() {
		
		return "permission/menu";
	}
	
	/**
	 * 查询页面数据 并分页显示数据
	 * 注解@RequestParam 获取 请求参数pn (显示第几页 )defaultValue 如果没有传值默认显示1
	 * 注解@RequestParam 获取 请求参数ps  (每页显示几条数据)defaultValue 如果没有传值默认显示1
	 */
	@GetMapping("/admin/index.html")
	public String userPage(Model model,
			@RequestParam(value="pn",defaultValue = "1")Integer pn,
			@RequestParam(value="ps",defaultValue = AppConstant.DEFAULT_PAGE_SIZE)Integer ps,
			@RequestParam(value="condition" ,defaultValue = "") String condition,
			HttpSession session) {
		//将查询条件放在session中
		session.setAttribute(AppConstant.QUERY_CONDITION_KEY, condition);
		session.setAttribute("pn", pn);
		//查出系统中所有的用户 显示第1页 每页显示ps条数据
		PageHelper.startPage(pn, ps);
		//用户传进来的有可能带查询条件所以不使用这个方法
		//List<TAdmin> admins = adminService.listAllAdmin();//查询出所有数据,想把数据分页显示的话,必须紧跟 PageHelper.startPage()方法
		
		List<TAdmin> admins = adminService.listAllAdminByCondition(condition);
		//数据源传进来,分页数据条显示几个
		PageInfo<TAdmin> page = new PageInfo<TAdmin>(admins,AppConstant.CONTINUES_PAGE_NUM);
		//把数据共享到页面中
		model.addAttribute("page",page);
		return "permission/user";
		
	}
	//跳到role页面的
	@GetMapping("/role/index.html")
	public String rolePage() {
		
		return "permission/role";
	}
	
	@GetMapping("/permission/index.html")
	public String permissionPage() {
		
		return "permission/permission";
	}

	
	@GetMapping("/auth_cert/index.html")
	public String authcertPage() {
		
		return "serviceauth/auth_cert";
	}
	
	@GetMapping("/auth_adv/index.html")
	public String authadvPage() {
		
		return "serviceauth/auth_adv";
	}
	
	@GetMapping("/auth_project/index.html")
	public String authprojectPage() {
		
		return "serviceauth/auth_project";
	}
	
	@GetMapping("/cert/index.html")
	public String certPage() {
		
		return "servicemanage/cert";
	}
	
	@GetMapping("/certtype/index.html")
	public String typePage() {
		
		return "servicemanage/type";
	}
	
	@GetMapping("/process/index.html")
	public String processPage() {
		
		return "servicemanage/process";
	}
	
	@GetMapping("/advert/index.html")
	public String advertisementPage() {
		
		return "servicemanage/advertisement";
	}
	
	@GetMapping("/message/index.html")
	public String messagePage() {
		
		return "servicemanage/message";
	}
	
	@GetMapping("/projectType/index.html")
	public String projecttypePage() {
		
		return "servicemanage/project_type";
	}
	
	@GetMapping("/tag/index.html")
	public String tagPage() {
		
		return "servicemanage/tag";
	}
}
