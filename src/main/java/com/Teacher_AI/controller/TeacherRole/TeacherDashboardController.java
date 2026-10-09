package com.Teacher_AI.controller.TeacherRole;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Teacher_AI.entity.UserEntity;

import jakarta.servlet.http.HttpSession;

@Controller
public class TeacherDashboardController {

    @GetMapping("/TeacherDashboard")
    public String TeacherDashboard(HttpSession session) {

        UserEntity user =
                (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // Set English as default language
        if (session.getAttribute("teacherLanguage") == null) {
            session.setAttribute("teacherLanguage", "English");
        }

        return "TeacherDashboard";
    }

    // =========================================================
    // CHANGE TEACHER LANGUAGE
    // =========================================================

    @PostMapping("/teacher/language")
    public String changeLanguage(
            @RequestParam String language,
            HttpSession session) {

        UserEntity user =
                (UserEntity) session.getAttribute("user");

        if (user == null) {
            return "redirect:/login";
        }

        // Allow only supported languages
        if ("English".equals(language)
                || "Hindi".equals(language)
                || "Gujarati".equals(language)) {

            session.setAttribute(
                    "teacherLanguage",
                    language
            );
        }

        return "redirect:/TeacherDashboard";
    }
}