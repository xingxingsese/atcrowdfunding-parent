package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.druid.util.StringUtils;
import com.atguigu.atcrowdfunding.Exception.EmailExistException;
import com.atguigu.atcrowdfunding.Exception.LoginacctExistException;
import com.atguigu.atcrowdfunding.api.AdminService;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TAdminExample.Criteria;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TMenuExample;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.utils.AppUtils;
/**
 * 处理admin有关的所有请求
 * @author DELL
 *
 */
@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	TAdminMapper adminMapper;
	
	@Autowired
	TMenuMapper menuMapper;

	
	
	// 登入功能查询数据库帐号密码是否正确
	@Override
	public TAdmin login(String username, String password) {
		
		String pwd = AppUtils.getDigestPwd(password);
		
		// 带查询条件
		TAdminExample example = new TAdminExample();
		//创建一个条件
		Criteria criteria = example.createCriteria();
		//查询Loginacct是否等于传入的username和userpswd是否等于传入的password
		criteria.andLoginacctEqualTo(username).andUserpswdEqualTo(pwd);
		//根据上面的标准查询到的结果返回给list
		List<TAdmin> list = adminMapper.selectByExample(example);
		//如果list不等于null并且只有1个代表查询到了,则成功登入
		return list != null && list.size() == 1 ? list.get(0) : null;
	}

	@Override
	public List<TMenu> listMenus() {
		//查出父菜单
		TMenuExample example = new TMenuExample();
		example.createCriteria().andPidEqualTo(0);
		//把父菜单封装到一个集合里
		List<TMenu> parentMenus = menuMapper.selectByExample(example);
		//把这些父菜单的子菜单找到
		for (TMenu menu : parentMenus) {
			TMenuExample example2 = new TMenuExample();
			//父菜单的id就是子菜单的pid
			example2.createCriteria().andPidEqualTo(menu.getId());
			List<TMenu> childMenus = menuMapper.selectByExample(example2);
			//查找出所有的子菜单
			menu.setChilds(childMenus);
			
			
		}
		return parentMenus;
	}
	
	//查出所有用户
	@Override
	public List<TAdmin> listAllAdmin() {
		
		
		return adminMapper.selectByExample(null);
	}
	//查询带条件的数据
	@Override
	public List<TAdmin> listAllAdminByCondition(String condition) {
		
		TAdminExample example = new TAdminExample();
		//String工具类提供了一个isEmpty方法是否是空字符串
		if(!StringUtils.isEmpty(condition)) {
			//所有的and条件都放在第一个Criterid条件里
			Criteria c0 = example.createCriteria();
			c0.andLoginacctLike("%"+condition+"%");
			//有or条件就创建新的criteria
			Criteria c1 = example.createCriteria();
			c1.andUsernameLike("%"+condition+"%");
			
			Criteria c2 = example.createCriteria();
			c2.andEmailLike("%"+condition+"%");
			
			example.or(c1);
			example.or(c2);
			
		}
		return adminMapper.selectByExample(example);
	}
	
	//按照id查询用户
	@Override
	public TAdmin getAdminById(Integer id) {
		// TODO Auto-generated method stub
		return adminMapper.selectByPrimaryKey(id);
	}
	
	//修改用户信息
	@Override
	public void updateAdmin(TAdmin admin) { 
		// TODO Auto-generated method stub
		//有选择的更新
		adminMapper.updateByPrimaryKeySelective(admin);
	}
	
	//新增用户对象
	@Override
	public void saveAdmin(TAdmin admin) {
		//检查邮箱是否被占用
		boolean email =  checkEmail(admin);
		if(!email) {
			//邮箱不可用
			throw new EmailExistException();
		}
		//检查帐号是否可用
		boolean loginacct = checkLoginacct(admin);
		 if(!loginacct) {
			 //帐号不可用
			 throw new LoginacctExistException();
		 }
		 
		 //保存对象
		 //默认给密码加密
		 admin.setUserpswd(AppUtils.getDigestPwd("123456"));
		 //默认给创建时间
		 admin.setCreatetime(AppUtils.getCurrentTimeStr());
		 adminMapper.insertSelective(admin);
	}

	public boolean checkLoginacct(TAdmin admin) {
		
		TAdminExample example = new TAdminExample();
		example.createCriteria().andLoginacctEqualTo(admin.getLoginacct());
		long count = adminMapper.countByExample(example);
		return count==0?true:false;
	}

	public boolean checkEmail(TAdmin admin) {
		TAdminExample example = new TAdminExample();
		example.createCriteria().andEmailEqualTo(admin.getEmail());
		long count = adminMapper.countByExample(example);
		return count==0?true:false;
	}

	@Override
	public void deleteAdminById(Integer id) {
		adminMapper.deleteByPrimaryKey(id);
	}

	//根据用户id动态查出菜单
	@Override
	public List<TMenu> listYourMenus(Integer id) {
		//父菜单集合
		List<TMenu> parentsMenu = new ArrayList<TMenu>();
		//全部菜单
		List<TMenu> myMenus = menuMapper.getMyMenus(id);
		for (TMenu tMenu : myMenus) {
			if(tMenu.getPid() == 0) {
				//找出父菜单
				parentsMenu.add(tMenu);
			}
		}
		for(TMenu pMenu :parentsMenu) {//遍历出所有父菜单
			
			for(TMenu childMenu : myMenus) {//遍历所有菜单
				
				if(childMenu.getPid() == pMenu.getId()) {//判断菜单的pid是否等于当前这个父菜单的id
					
					pMenu.getChilds().add(childMenu);//getChilds()方法存储他的子菜单
				}
			}	
		}
		
		return parentsMenu;
	}

}
