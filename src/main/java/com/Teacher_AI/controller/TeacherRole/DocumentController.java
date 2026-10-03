package com.Teacher_AI.controller.TeacherRole;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.Teacher_AI.entity.DocumentEntity;
import com.Teacher_AI.service.CloudinaryService;
import com.Teacher_AI.service.DocumentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class DocumentController {

    private final DocumentService documentService;
    private final CloudinaryService cloudinaryService;

    public DocumentController(
            DocumentService documentService,
            CloudinaryService cloudinaryService) {

        this.documentService = documentService;
        this.cloudinaryService = cloudinaryService;
    }

    // =========================================================
    // OPEN UPLOAD PAGE
    // =========================================================

    @GetMapping("/teacher/documents/upload")
    public String openUploadPage(HttpSession session) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        return "DocumentUpload";
    }

    // =========================================================
    // UPLOAD DOCUMENT
    // =========================================================

    @PostMapping("/teacher/documents/upload")
    public String uploadDocument(
            @RequestParam("file") MultipartFile file,
            HttpSession session) throws IOException {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        if (file.isEmpty()) {
            return "redirect:/teacher/documents/upload?error=empty";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        // Upload to Cloudinary
        Map<String, Object> result =
                cloudinaryService.uploadFile(
                        file,
                        userId
                );

        // Create database record
        DocumentEntity document =
                new DocumentEntity();

        document.setUserId(userId);

        document.setFileName(
                file.getOriginalFilename()
        );

        document.setFileType(
                file.getContentType()
        );

        document.setFileSize(
                file.getSize()
        );

        document.setFilePath(
                (String) result.get("secure_url")
        );

        document.setCloudinaryUrl(
                (String) result.get("secure_url")
        );

        document.setCloudinaryPublicId(
                (String) result.get("public_id")
        );

        document.setCloudinaryResourceType(
                (String) result.get("resource_type")
        );

        // Save + extract text
        documentService.saveDocument(document);

        return "redirect:/teacher/documents/upload?success=true";
    }

    // =========================================================
    // MY DOCUMENTS
    // =========================================================

    @GetMapping("/teacher/documents")
    public String myDocuments(
            @RequestParam(required = false) String search,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        List<DocumentEntity> documents;

        if (search == null
                || search.trim().isEmpty()) {

            documents =
                    documentService.getUserDocuments(
                            userId
                    );

        } else {

            documents =
                    documentService.searchDocuments(
                            userId,
                            search.trim()
                    );
        }

        model.addAttribute(
                "documents",
                documents
        );

        model.addAttribute(
                "search",
                search
        );

        return "MyDocuments";
    }

    // =========================================================
    // VIEW DOCUMENT
    // =========================================================

    @GetMapping("/teacher/documents/view")
    public ResponseEntity<Void> viewDocument(
            @RequestParam Integer id,
            HttpSession session) {

        if (session.getAttribute("user") == null) {

            return ResponseEntity
                    .status(302)
                    .header(
                            HttpHeaders.LOCATION,
                            "/login"
                    )
                    .build();
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {

            return ResponseEntity
                    .status(302)
                    .header(
                            HttpHeaders.LOCATION,
                            "/login"
                    )
                    .build();
        }

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return ResponseEntity
                    .notFound()
                    .build();
        }

        // Security check
        if (!document.getUserId().equals(userId)) {

            return ResponseEntity
                    .status(403)
                    .build();
        }

        // Cloudinary URL
        String cloudinaryUrl =
                document.getCloudinaryUrl();

        if (cloudinaryUrl == null
                || cloudinaryUrl.isBlank()) {

            return ResponseEntity
                    .notFound()
                    .build();
        }

        // Redirect browser to Cloudinary
        return ResponseEntity
                .status(302)
                .header(
                        HttpHeaders.LOCATION,
                        cloudinaryUrl
                )
                .build();
    }

    // =========================================================
    // VIEW EXTRACTED TEXT
    // =========================================================

    @GetMapping("/teacher/documents/text")
    public String viewExtractedText(
            @RequestParam Integer id,
            HttpSession session,
            Model model) {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        // Security check
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        model.addAttribute(
                "document",
                document
        );

        return "ExtractedText";
    }

    // =========================================================
    // DELETE DOCUMENT
    // =========================================================

    @GetMapping("/teacher/documents/delete")
    public String deleteDocument(
            @RequestParam Integer id,
            HttpSession session) throws IOException {

        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }

        Integer userId =
                (Integer) session.getAttribute("userId");

        if (userId == null) {
            return "redirect:/login";
        }

        DocumentEntity document =
                documentService.getDocumentById(id);

        if (document == null) {
            return "redirect:/teacher/documents";
        }

        // Security check
        if (!document.getUserId().equals(userId)) {
            return "redirect:/teacher/documents";
        }

        // Delete from Cloudinary
        if (document.getCloudinaryPublicId() != null
                && document.getCloudinaryResourceType() != null) {

            cloudinaryService.deleteFile(
                    document.getCloudinaryPublicId(),
                    document.getCloudinaryResourceType()
            );
        }

        // Delete from PostgreSQL
        documentService.deleteDocument(
                id,
                userId
        );

        return "redirect:/teacher/documents";
    }
}