package com.Teacher_AI.service;

import org.springframework.stereotype.Service;

@Service
public class StructuredDataAnalyzer {

    private final GeminiService geminiService;

    public StructuredDataAnalyzer(
            GeminiService geminiService) {

        this.geminiService = geminiService;
    }

    public String analyze(String extractedText) {

        if (extractedText == null
                || extractedText.isBlank()) {

            System.out.println(
                    "No extracted text available."
            );

            return null;
        }

        System.out.println(
                "Starting structured data analysis..."
        );

        System.out.println(
                "Extracted text length: "
                        + extractedText.length()
        );

        String prompt = """
                Analyze the following extracted document text.

                Determine whether the document contains
                structured tabular or record-based data.

                Structured data means information organized
                into rows and columns or repeated records.

                Examples include:
                - Student records
                - Student marks
                - Attendance records
                - Timetables
                - Employee records
                - Inventory
                - Fees
                - Exam results

                If the document is NOT structured data,
                return exactly this JSON structure:

                {
                  "isStructured": false,
                  "type": null,
                  "columns": [],
                  "rows": []
                }

                If the document IS structured data,
                return:

                {
                  "isStructured": true,
                  "type": "SHORT_TYPE_NAME",
                  "columns": [
                    "column1",
                    "column2"
                  ],
                  "rows": [
                    {
                      "column1": "value",
                      "column2": "value"
                    }
                  ]
                }

                Rules:
                1. Return ONLY valid JSON.
                2. Do NOT use markdown.
                3. Do NOT add explanations.
                4. Do NOT invent data.
                5. Preserve values from the document.
                6. Keep the type short and descriptive.
                7. If there is not enough evidence that the
                   document is structured data, return false.
                8. Do not treat ordinary paragraphs as structured data.

                Document text:

                """
                + extractedText;

        String result =
                geminiService.generateText(prompt);

        if (result == null
                || result.isBlank()) {

            System.out.println(
                    "No response from Gemini."
            );

            return null;
        }

        System.out.println(
                "Structured data analysis completed."
        );

        System.out.println(
                "Gemini result:"
        );

        System.out.println(result);

        return result;
    }
}