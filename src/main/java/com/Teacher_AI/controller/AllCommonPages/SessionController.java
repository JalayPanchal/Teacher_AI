package com.Teacher_AI.controller.AllCommonPages;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.Session;
import jakarta.servlet.http.HttpSession;

import com.Teacher_AI.entity.UserEntity;
import com.Teacher_AI.service.UserService;

@Controller
public class SessionController {

    private final UserService userService;

    public SessionController(UserService userService) {
        this.userService = userService;
    }

    
    //signup
    @GetMapping("/signup")
    public String openSignup() {
        return "Signup";
    }
    
    //signup
    @PostMapping("/signup")
    public String signup(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String gender,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String contactNum) {

        UserEntity user = new UserEntity();

        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(password);
        user.setGender(gender);
        user.setState(state);
        user.setCity(city);
        user.setContactNum(contactNum);

        userService.createUser(user);

        return "redirect:/login";
    }
    
    //open login
    @GetMapping("login")
    public String openLogin() {
    	return "Login";
    }
    
    //Login
    @PostMapping("/login")
    public String login(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session) {

        UserEntity user = userService.loginUser(email, password);

        if (user == null) {
            return "redirect:/login?error=true";
        }

        session.setAttribute("userId", user.getUserId());
        session.setAttribute("user", user);

        return "redirect:/TeacherDashboard";
    }
    
    
    @GetMapping("/logout")
    public String logout(HttpSession session){
    	
    	
		session.invalidate();
    	
    	return "redirect:/login";
    }
    
    
    
}