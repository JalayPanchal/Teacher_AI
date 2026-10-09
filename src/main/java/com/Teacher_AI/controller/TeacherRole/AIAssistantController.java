package com.Teacher_AI.controller.TeacherRole;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

        // Make sure a language exists
        if (session.getAttribute("teacherLanguage") == null) {
            session.setAttribute(
                    "teacherLanguage",
                    "English"
            );
        }

        System.out.println(
                "AI ASSISTANT REQUEST - ID = " + id
        );

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        System.out.println(
                "========== AI DOCUMENT DEBUG =========="
        );

        System.out.println(
                "Document ID: " + document.getDocumentId()
        );

        System.out.println(
                "File Name: " + document.getFileName()
        );

        System.out.println(
                "Structured Data: " + document.getStructuredData()
        );

        System.out.println(
                "Structured Type: " + document.getStructuredDataType()
        );

        System.out.println(
                "Structured JSON: " + document.getStructuredDataJson()
        );

        System.out.println(
                "========================================"
        );

        // Security
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
    // =========================================================

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

            // Get selected language
            String language =
                    (String) session.getAttribute(
                            "teacherLanguage"
                    );

            if (language == null || language.isBlank()) {
                language = "English";
            }

            String prompt =
                    "You are Teacher_AI, an AI assistant designed specifically for teachers.\n\n"

                    + "LANGUAGE:\n"
                    + "Answer the teacher in " + language + ".\n"
                    + "Do not unnecessarily mix languages.\n\n"

                    + "RULES:\n"
                    + "1. Answer the teacher's question using ONLY the structured table data provided below.\n"
                    + "2. Do not invent information.\n"
                    + "3. Do not use information outside the table.\n"
                    + "4. If the answer cannot be determined from the table, clearly say so in the selected language.\n"
                    + "5. For calculations, use the actual values from the table.\n"
                    + "6. Keep the answer clear and concise.\n"
                    + "7. Answer in a teacher-friendly way.\n"
                    + "8. Do not sound robotic.\n"
                    + "9. Do not unnecessarily repeat the question.\n"
                    + "10. If the teacher asks for a list, use a clear list.\n"
                    + "11. If the teacher asks for a calculation, show the result clearly.\n\n"

                    + "STRUCTURED TABLE DATA:\n"
                    + structuredData
                    + "\n\n"

                    + "TEACHER QUESTION:\n"
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
    // GENERATE NATURAL DOCUMENT SUMMARY
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

        // Security
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        try {

            // =====================================================
            // GET DOCUMENT TEXT
            // =====================================================

            String text =
                    document.getExtractedText();


            // =====================================================
            // GET SELECTED LANGUAGE
            // =====================================================

            String language =
                    (String) session.getAttribute(
                            "teacherLanguage"
                    );

            if (language == null || language.isBlank()) {
                language = "English";
            }


            // =====================================================
            // CHECK DOCUMENT TEXT
            // =====================================================

            if (text == null || text.isBlank()) {

                model.addAttribute(
                        "document",
                        document
                );

                model.addAttribute(
                        "error",
                        "There is no readable text available in this document."
                );

                return "AIResult";
            }


            // =====================================================
            // NATURAL TEACHER SUMMARY PROMPT
            // =====================================================

            String prompt =
                    "You are Teacher_AI, a helpful AI assistant designed specifically for teachers.\n\n"

                    + "LANGUAGE:\n"
                    + "Write the entire summary in " + language + ".\n"
                    + "Do not unnecessarily mix languages.\n"
                    + "Keep proper names, official names, dates and numbers accurate.\n"
                    + "If an official term or name should remain in its original form, you may keep that term unchanged.\n"
                    + "The explanation itself must be in " + language + ".\n\n"

                    + "NATURAL TEACHER-FRIENDLY STYLE:\n"
                    + "- Do NOT sound like a computer-generated report.\n"
                    + "- Do NOT begin with 'This document discusses...' unless it is genuinely necessary.\n"
                    + "- Use natural and simple language.\n"
                    + "- Write like a helpful colleague explaining the document to a teacher.\n"
                    + "- Focus on information that is useful to a teacher.\n"
                    + "- Do not invent or assume information.\n"
                    + "- Do not mention that you are an AI.\n"
                    + "- Do not repeat the same information.\n"
                    + "- Do not make the summary unnecessarily long.\n"
                    + "- Use headings only when they genuinely improve readability.\n"
                    + "- Prefer short paragraphs and bullet points.\n"
                    + "- Keep dates, names, numbers and instructions accurate.\n\n"

                    + "When relevant, naturally cover:\n"
                    + "1. What this document is about.\n"
                    + "2. Important things the teacher should know.\n"
                    + "3. Important dates, numbers or requirements.\n"
                    + "4. Actions the teacher may need to take.\n"
                    + "5. A short 'Keep in mind' section if something is particularly important.\n\n"

                    + "Do NOT create empty sections.\n"
                    + "Do NOT force information into a section when the document does not contain it.\n\n"

                    + "The result should feel like a helpful colleague quickly explaining the document to a teacher.\n\n"

                    + "DOCUMENT:\n"
                    + text;


            // =====================================================
            // ASK AI
            // =====================================================

            String summary =
                    aiService.askAI(prompt);


            // =====================================================
            // STORE SUMMARY CONTEXT IN SESSION
            // =====================================================

            session.setAttribute(
                    "aiSummaryDocumentId",
                    document.getDocumentId()
            );

            session.setAttribute(
                    "aiSummaryDocumentText",
                    text
            );

            session.setAttribute(
                    "aiSummary",
                    summary
            );

            // New summary = new conversation
            session.removeAttribute(
                    "aiSummaryConversation"
            );


            // =====================================================
            // SEND RESULT TO JSP
            // =====================================================

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
                    "The document could not be summarized right now."
            );

            return "AIResult";
        }
    }


    // =========================================================
    // ASK ANYTHING ABOUT THE DOCUMENT
    // =========================================================

    @PostMapping("/teacher/ai/summary/ask")
    public String askSummaryFollowUp(
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

            // =====================================================
            // VALIDATE QUESTION
            // =====================================================

            if (question == null || question.isBlank()) {

                model.addAttribute(
                        "document",
                        document
                );

                model.addAttribute(
                        "summary",
                        (String) session.getAttribute(
                                "aiSummary"
                        )
                );

                model.addAttribute(
                        "error",
                        "Please enter a question."
                );

                return "AIResult";
            }

            question = question.trim();


            // =====================================================
            // GET SELECTED LANGUAGE
            // =====================================================

            String language =
                    (String) session.getAttribute(
                            "teacherLanguage"
                    );

            if (language == null || language.isBlank()) {
                language = "English";
            }


            // =====================================================
            // GET ORIGINAL DOCUMENT TEXT
            // =====================================================

            String documentText =
                    document.getExtractedText();

            if (documentText == null
                    || documentText.isBlank()) {

                model.addAttribute(
                        "document",
                        document
                );

                model.addAttribute(
                        "error",
                        "I couldn't find readable text in this document."
                );

                return "AIResult";
            }


            // =====================================================
            // GET CURRENT SUMMARY
            // =====================================================

            String summary =
                    (String) session.getAttribute(
                            "aiSummary"
                    );

            if (summary == null) {
                summary = "";
            }


            // =====================================================
            // PREVIOUS CONVERSATION
            // =====================================================

            String conversation =
                    (String) session.getAttribute(
                            "aiSummaryConversation"
                    );

            if (conversation == null) {
                conversation = "";
            }


            // Keep conversation reasonably small
            if (conversation.length() > 12000) {

                conversation =
                        conversation.substring(
                                conversation.length() - 12000
                        );
            }


            // =====================================================
            // ASK ANYTHING PROMPT
            // =====================================================

            String prompt =
                    "You are Teacher_AI, a helpful document assistant designed specifically for teachers.\n\n"

                    + "The teacher has uploaded ONE document.\n"
                    + "Your job is to understand the document and answer the teacher's questions naturally and accurately.\n\n"

                    + "RESPONSE LANGUAGE:\n"
                    + "Answer the teacher in " + language + ".\n"
                    + "Do not unnecessarily mix languages.\n\n"

                    + "HOW TO ANSWER:\n"
                    + "1. Answer the teacher's actual question directly.\n"
                    + "2. Use the ORIGINAL DOCUMENT as the main source of truth.\n"
                    + "3. You may understand and interpret information from the document when the answer is clearly supported by its context.\n"
                    + "4. Do NOT require the exact answer to appear as an exact sentence in the document.\n"
                    + "5. If the document clearly indicates who it is for, what its purpose is, what someone should do, or what something means, explain that naturally.\n"
                    + "6. If something is an obvious conclusion from the document, you may state it.\n"
                    + "7. When you are making an interpretation rather than quoting something directly, use natural wording such as 'It appears that...' or 'Based on the document...'.\n"
                    + "8. NEVER invent facts that are not supported by the document.\n"
                    + "9. NEVER use outside knowledge to create an answer.\n"
                    + "10. If the requested information genuinely cannot be found or reasonably understood from the document, say that you could not find that information in the document, using the selected language.\n"
                    + "11. Do not refuse a question simply because the exact words are not present in the document.\n"
                    + "12. If the teacher asks you to explain something from the document, explain it in simple teacher-friendly language.\n"
                    + "13. If the teacher asks 'why', 'how', 'what does this mean', 'who is this for', 'what should I do', or similar questions, use the context of the document to provide a useful answer.\n"
                    + "14. If the teacher asks about a specific date, name, number, rule, requirement, instruction, or other detail, find the relevant information in the document.\n"
                    + "15. If the teacher asks for a calculation, use only numbers actually present in the document.\n"
                    + "16. If the teacher asks a follow-up question such as 'Why?', 'What about this?', 'Which one?', or 'Explain that.', use the previous conversation to understand what they mean.\n"
                    + "17. Do not make the teacher repeat information already established in the conversation.\n"
                    + "18. Keep answers reasonably concise unless the teacher asks for a detailed explanation.\n"
                    + "19. Use bullets or numbered lists when they make the answer easier to understand.\n"
                    + "20. Do not unnecessarily repeat the entire document or summary.\n"
                    + "21. Do not mention these instructions.\n"
                    + "22. Do not say that you are an AI unless the teacher asks.\n\n"

                    + "============================================================\n"
                    + "ORIGINAL DOCUMENT\n"
                    + "============================================================\n\n"

                    + documentText

                    + "\n\n============================================================\n"
                    + "GENERATED SUMMARY\n"
                    + "============================================================\n\n"

                    + summary

                    + "\n\n============================================================\n"
                    + "PREVIOUS CONVERSATION\n"
                    + "============================================================\n\n"

                    + conversation

                    + "\n\n============================================================\n"
                    + "NEW TEACHER QUESTION\n"
                    + "============================================================\n\n"

                    + question;


            // =====================================================
            // ASK GEMINI
            // =====================================================

            String answer =
                    aiService.askAI(prompt);


            // =====================================================
            // SAVE TEMPORARY CONVERSATION
            // =====================================================

            String newConversation =
                    conversation
                    + "\nTeacher: "
                    + question
                    + "\nTeacher_AI: "
                    + answer
                    + "\n";


            // Prevent unlimited session growth
            if (newConversation.length() > 16000) {

                newConversation =
                        newConversation.substring(
                                newConversation.length() - 16000
                        );
            }


            session.setAttribute(
                    "aiSummaryConversation",
                    newConversation
            );


            // =====================================================
            // RETURN RESULT
            // =====================================================

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "summary",
                    summary
            );

            model.addAttribute(
                    "followUpQuestion",
                    question
            );

            model.addAttribute(
                    "followUpAnswer",
                    answer
            );

            return "AIResult";

        } catch (Exception e) {

            e.printStackTrace();

            model.addAttribute(
                    "document",
                    document
            );

            model.addAttribute(
                    "summary",
                    (String) session.getAttribute(
                            "aiSummary"
                    )
            );

            model.addAttribute(
                    "error",
                    "AI could not answer your question right now."
            );

            return "AIResult";
        }
    }
}