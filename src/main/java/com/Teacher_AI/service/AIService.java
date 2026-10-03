package com.Teacher_AI.service;

import java.net.URI;

import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AIService {

    @Value("${gemini.api.url}")
    private String apiUrl;

    @Value("${gemini.api.key}")
    private String apiKey;

    @Value("${gemini.api.model}")
    private String model;

    public String askAI(String prompt) throws Exception {

        JSONObject requestBody = new JSONObject();

        JSONArray contents = new JSONArray();

        JSONObject content = new JSONObject();
        JSONArray parts = new JSONArray();

        JSONObject textPart = new JSONObject();
        textPart.put("text", prompt);

        parts.put(textPart);
        content.put("parts", parts);

        contents.put(content);

        requestBody.put("contents", contents);

        HttpClient client = HttpClient.newHttpClient();

        String url = apiUrl
                + "/v1beta/models/"
                + model
                + ":generateContent";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .header("x-goog-api-key", apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(
                        requestBody.toString()
                ))
                .build();

        HttpResponse<String> response =
                client.send(
                        request,
                        HttpResponse.BodyHandlers.ofString()
                );

        if (response.statusCode() != 200) {
            throw new RuntimeException(
                    "Gemini API Error: "
                    + response.statusCode()
                    + " - "
                    + response.body()
            );
        }

        JSONObject responseJson =
                new JSONObject(response.body());

        return responseJson
                .getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text");
    }
}