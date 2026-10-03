
package com.Teacher_AI.service;

import java.io.File;

import org.springframework.stereotype.Service;

import net.sourceforge.tess4j.Tesseract;

@Service
public class OcrService {

    public String extractText(String filePath) throws Exception {

        Tesseract tesseract = new Tesseract();

        // Tesseract tessdata folder
        tesseract.setDatapath(
        	    "C:\\Program Files\\Tesseract-OCR\\tessdata"
        	);
        
        // English language
        tesseract.setLanguage("eng");

        // Image file
        File imageFile = new File(filePath);
        
    // DEBUG: Check the actual file path 
     System.out.println("OCR File Path: " + imageFile.getAbsolutePath()); System.out.println("OCR File Exists: " + imageFile.exists());

        // Extract text
        return tesseract.doOCR(imageFile);
    }
}