package com.Teacher_AI.controller.TeacherRole;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.Teacher_AI.entity.UserEntity;

import jakarta.servlet.http.HttpSession;

@Controller
public class TeacherDashboardController{
	
	@GetMapping("/TeacherDashboard")
	public String TeacherDashboard(HttpSession session) {
		
		UserEntity user = (UserEntity) session.getAttribute("user");
		
		if (user == null) {
			return "redirect:/login";
		}
		
		return "TeacherDashboard";
		
	}
}


