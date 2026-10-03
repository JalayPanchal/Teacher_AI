package com.Teacher_AI.controller.TeacherRole;

import org.springframework.stereotype.Controller;
import com.Teacher_AI.service.AIService;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PostMapping;

import com.Teacher_AI.entity.DocumentEntity;
import com.Teacher_AI.service.DocumentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class AIAssistantController {

	private final DocumentService documentService;
	private final AIService aiService;
    
	public AIAssistantController(
	        DocumentService documentService,
	        AIService aiService) {

	    this.documentService = documentService;
	    this.aiService = aiService;
	}

    @GetMapping("/teacher/ai")
    public String openAIAssistant(
            @RequestParam Integer id,
            HttpSession session,
            Model model) {
    	
        // Check login
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =(Integer) session.getAttribute("userId");
        System.out.println("🔥 SUMMARIZE REQUEST REACHED - ID = " + id);

        // Get document
        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        // Make sure document belongs to logged-in teacher
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        // Send document to JSP
        model.addAttribute("document", document);

        return "AIAssistant";
    }
    
    @GetMapping("/teacher/ai/test")
    @ResponseBody
    public String testAI() {

        try {

            String response = aiService.askAI(
                    "Say hello to Teacher_AI in one short sentence."
            );

            return response;

        } catch (Exception e) {

            e.printStackTrace();

            return "AI ERROR: " + e.getMessage();
        }
    }
    
    @PostMapping("/teacher/ai/summarize")
    public String summarizeDocument(
            @RequestParam Integer id,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId = (Integer) session.getAttribute("userId");

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        try {

            String text = document.getExtractedText();

            String prompt =
                    "Summarize the following teaching document clearly for a teacher. "
                    + "Use simple language and important bullet points.\n\n"
                    + text;

            String summary = aiService.askAI(prompt);

            model.addAttribute("document", document);
            model.addAttribute("summary", summary);

            return "AIResult";

        } catch (Exception e) {

            e.printStackTrace();

            model.addAttribute("document", document);
            model.addAttribute("error", e.getMessage());

            return "AIResult";
        }
    }
}