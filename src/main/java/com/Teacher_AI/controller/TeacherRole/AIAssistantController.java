
package com.Teacher_AI.controller.TeacherRole;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PostMapping;

import com.Teacher_AI.entity.DocumentEntity;
import com.Teacher_AI.service.AIService;
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

    // =========================================================
    // OPEN AI ASSISTANT
    // =========================================================

    @GetMapping("/teacher/ai")
    public String openAIAssistant(
            @RequestParam Integer id,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        System.out.println(
                "AI ASSISTANT REQUEST - ID = " + id
        );

        DocumentEntity document =
                documentService.getDocumentById(id);

        System.out.println("========== AI DOCUMENT DEBUG ==========");
        System.out.println("Document ID: " + document.getDocumentId());
        System.out.println("File Name: " + document.getFileName());
        System.out.println("Structured Data: " + document.getStructuredData());
        System.out.println("Structured Type: " + document.getStructuredDataType());
        System.out.println("Structured JSON: " + document.getStructuredDataJson());
        System.out.println("========================================");
        
        if (document == null) {
            return "redirect:/teacher/documents";
        }

        // Security: teacher can only accwess own document
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        model.addAttribute(
                "document",
                document
        );

        return "AIAssistant";
    }


    // =========================================================
    // TEST AI
    // *********************************************************

    @GetMapping("/teacher/ai/test")
    @ResponseBody
    public String testAI() {

        try {

            String response =
                    aiService.askAI(
                            "Say hello to Teacher_AI in one short sentence."
                    );

            return response;

        } catch (Exception e) {

            e.printStackTrace();

            return "AI ERROR: " + e.getMessage();
        }
    }


    // =========================================================
    // ASK AI ABOUT STRUCTURED TABLE
    // =========================================================

    @PostMapping("/teacher/ai/ask")
    public String askAboutTable(
            @RequestParam Integer id,
            @RequestParam String question,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        // Security check
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        try {

            String structuredData =
                    document.getStructuredDataJson();

            if (structuredData == null
                    || structuredData.isBlank()) {

                model.addAttribute(
                        "error",
                        "No structured data is available for this document."
                );

                model.addAttribute(
                        "document",
                        document
                );

                return "AIAssistant";
            }

            String prompt =
                    """
                    You are Teacher_AI, an AI assistant for teachers.

                    Answer the teacher's question using ONLY
                    the structured table data provided below.

                    Rules:
                    1. Do not invent information.
                    2. Do not use information outside the table.
                    3. If the answer cannot be determined from
                       the table, clearly say so.
                    4. For calculations, use the actual values
                       from the table.
                    5. Keep the answer clear and concise.
                    6. Answer in a teacher-friendly way.

                    STRUCTURED TABLE DATA:
                    """
                    + structuredData
                    + """

                    TEACHER QUESTION:
                    """
                    + question;

            String answer =
                    aiService.askAI(prompt);

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "question",
                    question
            );

            model.addAttribute(
                    "answer",
                    answer
            );

            return "AIAssistant";

        } catch (Exception e) {

            e.printStackTrace();

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "question",
                    question
            );

            model.addAttribute(
                    "error",
                    "AI could not answer the question."
            );

            return "AIAssistant";
        }
    }


    // =========================================================
    // EXISTING DOCUMENT SUMMARY
    // =========================================================

    @PostMapping("/teacher/ai/summarize")
    public String summarizeDocument(
            @RequestParam Integer id,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        try {

            String text =
                    document.getExtractedText();

            String prompt =
                    "Summarize the following teaching document clearly for a teacher. "
                    + "Use simple language and important bullet points.\n\n"
                    + text;

            String summary =
                    aiService.askAI(prompt);

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "summary",
                    summary
            );

            return "AIResult";

        } catch (Exception e) {

            e.printStackTrace();

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "error",
                    e.getMessage()
            );

            return "AIResult";
        }
    }
}