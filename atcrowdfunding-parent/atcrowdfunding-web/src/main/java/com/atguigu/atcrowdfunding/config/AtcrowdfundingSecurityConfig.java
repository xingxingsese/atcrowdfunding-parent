package com.atguigu.atcrowdfunding.config;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.component.MyUserDetail;
import com.atguigu.atcrowdfunding.constant.AppConstant;

@EnableGlobalMethodSecurity(prePostEnabled=true)//开启全局的安全方法功能
@EnableWebSecurity//开启webSecurity功能.
@Configuration//配置类
public class AtcrowdfundingSecurityConfig extends WebSecurityConfigurerAdapter{
	@Qualifier("myUserDetailService")
	@Autowired
	UserDetailsService userDetailsService;//用户查询服务
	
	@Qualifier("myPasswordEncoder")//指定就要这个id的注解
	@Autowired
	PasswordEncoder passwordEncoder;//密码加密器
	/**
	 * 定义认证规则
	 */
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		//super.configure(auth);这个必须注掉
		auth.userDetailsService(userDetailsService)//用户查询服务
			.passwordEncoder(passwordEncoder);//密码加密规则
	}
	/**
	 * 定义http访问规则(授权)
	 */
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		//super.configure(http);这个必须注掉
		http.authorizeRequests()
			.antMatchers("/static/**").permitAll()
			.antMatchers("/index.jsp","/reg.jsp","/login.jsp").permitAll()
			.anyRequest().authenticated();//除了以上请求,其余都要认证通过
		//禁用跨站请求伪造,form表单提交的时候都需要携带_csrf令牌,改起来太麻烦,所以禁用掉	
		http.csrf().disable();
		
		//表单登入功能
		//表单登入,登入页的地址
		http.formLogin().loginPage("/login")
		.usernameParameter("loginacct")
		.passwordParameter("pwd")
		.successHandler(new AuthenticationSuccessHandler() {

			@Override
			public void onAuthenticationSuccess(HttpServletRequest request,
					HttpServletResponse response,
					Authentication authentication)
					throws IOException, ServletException {
				//当前登录的用户的对象
				UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) authentication;
				
				//封装了当前登录的用户
				MyUserDetail principal = (MyUserDetail) token.getPrincipal();
				TAdmin admin = principal.getAdmin();
				//登入成功后重定向到main页面
				request.getSession().setAttribute(AppConstant.LOGIN_USER_SESSION_KEY,admin);
				response.sendRedirect(request.getContextPath()+"/main.html");
				
			}
			
		})
		.failureHandler(new AuthenticationFailureHandler() {

			@Override
			public void onAuthenticationFailure(HttpServletRequest request,
					HttpServletResponse response,
					AuthenticationException exception) throws IOException, ServletException {
				request.setAttribute("msg", "帐号密码错误,请重新输入");
				
				String username = request.getParameter("loginacct");
				
				request.setAttribute("username",username );
				
				request.getRequestDispatcher("/login").forward(request, response);
			}
			
		}).permitAll();
			
		
	}
}
