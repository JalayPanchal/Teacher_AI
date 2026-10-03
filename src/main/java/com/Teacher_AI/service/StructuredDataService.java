package com.Teacher_AI.service;

import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.Teacher_AI.entity.DocumentEntity;

@Service
public class StructuredDataService {

    public void process(
            DocumentEntity document,
            String structuredDataJson) {

        if (structuredDataJson == null
                || structuredDataJson.isBlank()) {

            return;
        }

        try {

            JSONObject json =
                    new JSONObject(structuredDataJson);

            boolean isStructured =
                    json.optBoolean(
                            "isStructured",
                            false
                    );

            document.setStructuredData(
                    isStructured
            );

            if (!isStructured) {

                document.setStructuredDataType(
                        null
                );

                System.out.println(
                        "Document does not contain structured data."
                );

                return;
            }

            String type =
                    json.optString(
                            "type",
                            "UNKNOWN"
                    );

            document.setStructuredDataType(
                    type
            );

            System.out.println(
                    "Structured data detected."
            );

            System.out.println(
                    "Type: " + type
            );

            System.out.println(
                    "Columns: "
                    + json.optJSONArray("columns")
            );

            System.out.println(
                    "Rows: "
                    + json.optJSONArray("rows")
            );

        } catch (Exception e) {

            System.out.println(
                    "Failed to process structured data."
            );

            e.printStackTrace();
        }
    }
}