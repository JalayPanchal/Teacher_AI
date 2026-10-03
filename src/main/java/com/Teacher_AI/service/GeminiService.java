package com.Teacher_AI.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class GeminiService {

    @Value("${gemini.api.url}")
    private String geminiApiUrl;

    @Value("${gemini.api.key}")
    private String geminiApiKey;

    @Value("${gemini.api.model}")
    private String geminiModel;

    private final RestTemplate restTemplate;

    public GeminiService() {
        this.restTemplate = new RestTemplate();
    }

    public String generateText(String prompt) {

        try {

            // =================================================
            // GEMINI URL
            // =================================================

            String url =
                    geminiApiUrl
                    + "/v1beta/models/"
                    + geminiModel
                    + ":generateContent?key="
                    + geminiApiKey;

            // =================================================
            // HEADERS
            // =================================================

            HttpHeaders headers =
                    new HttpHeaders();

            headers.setContentType(
                    MediaType.APPLICATION_JSON
            );

            // =================================================
            // REQUEST BODY
            // =================================================

            Map<String, Object> textPart =
                    Map.of(
                            "text",
                            prompt
                    );

            Map<String, Object> parts =
                    Map.of(
                            "parts",
                            new Object[] {
                                    textPart
                            }
                    );

            Map<String, Object> requestBody =
                    Map.of(
                            "contents",
                            new Object[] {
                                    parts
                            }
                    );

            // =================================================
            // HTTP REQUEST
            // =================================================

            HttpEntity<Map<String, Object>> request =
                    new HttpEntity<>(
                            requestBody,
                            headers
                    );

            ResponseEntity<Map> response =
                    restTemplate.postForEntity(
                            url,
                            request,
                            Map.class
                    );

            // =================================================
            // RESPONSE
            // =================================================

            Map body =
                    response.getBody();

            if (body == null) {

                throw new RuntimeException(
                        "Gemini returned empty response"
                );
            }

            /*
             * Expected structure:

             * candidates
             *   ↓
             * content
             *   ↓
             * parts
             *   ↓
             * text
             */

            var candidates =
                    (java.util.List<Map<String, Object>>)
                            body.get("candidates");

            if (candidates == null
                    || candidates.isEmpty()) {

                throw new RuntimeException(
                        "Gemini returned no candidates"
                );
            }

            Map<String, Object> candidate =
                    candidates.get(0);

            Map<String, Object> content =
                    (Map<String, Object>)
                            candidate.get("content");

            var responseParts =
                    (java.util.List<Map<String, Object>>)
                            content.get("parts");

            if (responseParts == null
                    || responseParts.isEmpty()) {

                throw new RuntimeException(
                        "Gemini returned no text"
                );
            }

            String result =
                    (String)
                            responseParts
                                    .get(0)
                                    .get("text");

            System.out.println(
                    "Gemini response received."
            );

            return result;

        } catch (Exception e) {

            System.out.println(
                    "Gemini API call failed."
            );

            e.printStackTrace();

            return null;
        }
    }
}