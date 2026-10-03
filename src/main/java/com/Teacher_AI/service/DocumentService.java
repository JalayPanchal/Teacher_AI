package com.Teacher_AI.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.Teacher_AI.entity.DocumentEntity;
import com.Teacher_AI.repository.DocumentRepository;

@Service
public class DocumentService {

    private final DocumentRepository documentRepository;
    private final PdfTextExtractor pdfTextExtractor;
    private final OcrService ocrService;
    private final StructuredDataAnalyzer structuredDataAnalyzer;
    private final StructuredDataService structuredDataService;

    public DocumentService(
            DocumentRepository documentRepository,
            PdfTextExtractor pdfTextExtractor,
            OcrService ocrService,
            StructuredDataAnalyzer structuredDataAnalyzer,
            StructuredDataService structuredDataService) {

        this.documentRepository =
                documentRepository;

        this.pdfTextExtractor =
                pdfTextExtractor;

        this.ocrService =
                ocrService;

        this.structuredDataAnalyzer =
                structuredDataAnalyzer;

        this.structuredDataService =
                structuredDataService;
    }

    public DocumentEntity saveDocument(
            DocumentEntity document) throws IOException {

        document.setStatus("UPLOADED");
        document.setCreatedAt(LocalDateTime.now());

        String fileType =
                document.getFileType();

        Path temporaryFile = null;

        try {

            /*
             * --------------------------------
             * 1. Download file temporarily
             * --------------------------------
             */

            temporaryFile =
                    downloadTemporaryFile(
                            document.getCloudinaryUrl(),
                            document.getFileName()
                    );

            String extractedText = null;

            /*
             * --------------------------------
             * 2. Extract text
             * --------------------------------
             */

            if ("application/pdf"
                    .equalsIgnoreCase(fileType)) {

                extractedText =
                        pdfTextExtractor.extractText(
                                temporaryFile.toString()
                        );

                document.setExtractedText(
                        extractedText
                );

                document.setStatus(
                        "TEXT_EXTRACTED"
                );
            }

            else if (fileType != null
                    && fileType.startsWith("image/")) {

                try {

                    extractedText =
                            ocrService.extractText(
                                    temporaryFile.toString()
                            );

                    document.setExtractedText(
                            extractedText
                    );

                    document.setStatus(
                            "TEXT_EXTRACTED"
                    );

                } catch (Exception e) {

                    document.setStatus(
                            "OCR_FAILED"
                    );

                    System.out.println(
                            "OCR failed."
                    );

                    e.printStackTrace();
                }
            }

            else {

                document.setStatus(
                        "UNSUPPORTED_FILE"
                );
            }

            /*
             * --------------------------------
             * 3. AI structured-data analysis
             * --------------------------------
             */

            if (extractedText != null
                    && !extractedText.isBlank()) {

                try {

                    System.out.println(
                            "Sending extracted text for structured data analysis..."
                    );

                    String analysisResult =
                            structuredDataAnalyzer.analyze(
                                    extractedText
                            );

                    if (analysisResult != null
                            && !analysisResult.isBlank()) {

                        /*
                         * Save the complete AI JSON
                         */
                        document.setStructuredDataJson(
                                analysisResult
                        );

                        /*
                         * Process the JSON generically.
                         *
                         * IMPORTANT:
                         * This is NOT student-specific.
                         */
                        structuredDataService.process(
                                document,
                                analysisResult
                        );

                        System.out.println(
                                "Structured data analysis saved."
                        );
                    }

                } catch (Exception e) {

                    System.out.println(
                            "Structured data analysis failed."
                    );

                    e.printStackTrace();
                }
            }

        } finally {

            /*
             * --------------------------------
             * 4. Delete temporary file
             * --------------------------------
             */

            if (temporaryFile != null) {

                try {

                    Files.deleteIfExists(
                            temporaryFile
                    );

                    System.out.println(
                            "Temporary file deleted: "
                                    + temporaryFile
                    );

                } catch (IOException e) {

                    e.printStackTrace();
                }
            }
        }

        /*
         * --------------------------------
         * 5. Save document to PostgreSQL
         * --------------------------------
         */

        DocumentEntity savedDocument =
                documentRepository.save(
                        document
                );

        System.out.println(
                "Document saved with ID: "
                        + savedDocument.getDocumentId()
        );

        return savedDocument;
    }

    /*
     * --------------------------------
     * Download Cloudinary file
     * temporarily for OCR/PDF extraction
     * --------------------------------
     */

    private Path downloadTemporaryFile(
            String cloudinaryUrl,
            String originalFileName)
            throws IOException {

        if (cloudinaryUrl == null
                || cloudinaryUrl.isBlank()) {

            throw new IOException(
                    "Cloudinary URL is missing"
            );
        }

        String extension =
                getFileExtension(
                        originalFileName
                );

        Path temporaryFile =
                Files.createTempFile(
                        "teacher-ai-",
                        extension
                );

        try (InputStream inputStream =
                     new java.net.URL(
                             cloudinaryUrl
                     ).openStream()) {

            Files.copy(
                    inputStream,
                    temporaryFile,
                    StandardCopyOption.REPLACE_EXISTING
            );
        }

        System.out.println(
                "Temporary file downloaded: "
                        + temporaryFile
        );

        return temporaryFile;
    }

    /*
     * --------------------------------
     * Get original file extension
     * --------------------------------
     */

    private String getFileExtension(
            String fileName) {

        if (fileName == null
                || !fileName.contains(".")) {

            return ".tmp";
        }

        String extension =
                fileName.substring(
                        fileName.lastIndexOf(".")
                );

        if (extension.length() > 10) {

            return ".tmp";
        }

        return extension;
    }

    /*
     * --------------------------------
     * Get teacher's documents
     * --------------------------------
     */

    public List<DocumentEntity> getUserDocuments(
            Integer userId) {

        return documentRepository
                .findByUserId(userId);
    }

    /*
     * --------------------------------
     * Search documents by filename
     * --------------------------------
     */

    public List<DocumentEntity> searchDocuments(
            Integer userId,
            String fileName) {

        return documentRepository
                .findByUserIdAndFileNameContainingIgnoreCase(
                        userId,
                        fileName
                );
    }

    /*
     * --------------------------------
     * Get document by ID
     * --------------------------------
     */

    public DocumentEntity getDocumentById(
            Integer documentId) {

        return documentRepository
                .findById(documentId)
                .orElse(null);
    }

    /*
     * --------------------------------
     * Delete document
     * --------------------------------
     */

    public void deleteDocument(
            Integer documentId,
            Integer userId) {

        DocumentEntity document =
                documentRepository
                        .findById(documentId)
                        .orElseThrow(
                                () -> new RuntimeException(
                                        "Document not found"
                                )
                        );

        if (!document.getUserId()
                .equals(userId)) {

            throw new RuntimeException(
                    "You are not allowed to delete this document"
            );
        }

        documentRepository.delete(
                document
        );
    }
}