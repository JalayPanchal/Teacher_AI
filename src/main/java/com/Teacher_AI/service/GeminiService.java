
package com.Teacher_AI.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
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

            System.out.println("=================================");
            System.out.println("Calling Gemini API");
            System.out.println("Model: " + geminiModel);
            System.out.println("URL: " + geminiApiUrl);
            System.out.println("=================================");

            // =================================================
            // HEADERS
            // =================================================

            HttpHeaders headers = new HttpHeaders();

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
            // *************************************************

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

            Map body = response.getBody();

            if (body == null) {

                System.out.println(
                        "Gemini returned empty response."
                );

                return null;
            }

            System.out.println(
                    "Gemini HTTP Status: "
                    + response.getStatusCode()
            );

            // =================================================
            // CANDIDATES
            // =================================================

            var candidates =
                    (java.util.List<Map<String, Object>>)
                            body.get("candidates");

            if (candidates == null
                    || candidates.isEmpty()) {

                System.out.println(
                        "Gemini returned no candidates."
                );

                System.out.println(
                        "Gemini response body: "
                        + body
                );

                return null;
            }

            Map<String, Object> candidate =
                    candidates.get(0);

            // =================================================
            // CONTENT
            // =================================================

            Map<String, Object> content =
                    (Map<String, Object>)
                            candidate.get("content");

            if (content == null) {

                System.out.println(
                        "Gemini returned no content."
                );

                System.out.println(
                        "Candidate: "
                        + candidate
                );

                return null;
            }

            // =================================================
            // RESPONSE PARTS
            // =================================================

            var responseParts =
                    (java.util.List<Map<String, Object>>)
                            content.get("parts");

            if (responseParts == null
                    || responseParts.isEmpty()) {

                System.out.println(
                        "Gemini returned no response parts."
                );

                System.out.println(
                        "Content: "
                        + content
                );

                return null;
            }

            // =================================================
            // TEXT
            // =================================================

            String result =
                    (String)
                            responseParts
                                    .get(0)
                                    .get("text");

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "Gemini response received."
            );

            System.out.println(
                    "Response:"
            );

            System.out.println(result);

            System.out.println(
                    "================================="
            );

            return result;

        } catch (HttpStatusCodeException e) {

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "GEMINI HTTP ERROR"
            );

            System.out.println(
                    "Status: "
                    + e.getStatusCode()
            );

            System.out.println(
                    "Response body:"
            );

            System.out.println(
                    e.getResponseBodyAsString()
            );

            System.out.println(
                    "================================="
            );

            return null;

        } catch (Exception e) {

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "GEMINI API CALL FAILED"
            );

            System.out.println(
                    "Error: "
                    + e.getMessage()
            );

            e.printStackTrace();

            System.out.println(
                    "================================="
            );

            return null;
        }
    }
}
