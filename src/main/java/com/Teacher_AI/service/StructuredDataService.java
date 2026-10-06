package com.Teacher_AI.service;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.Teacher_AI.entity.DocumentEntity;

@Service
public class StructuredDataService {

    public void process(
            DocumentEntity document,
            String structuredDataJson) {

        if (document == null) {

            System.out.println(
                    "StructuredDataService: Document is null."
            );

            return;
        }

        if (structuredDataJson == null
                || structuredDataJson.isBlank()) {

            System.out.println(
                    "StructuredDataService: No structured JSON received."
            );

            document.setStructuredData(false);
            document.setStructuredDataType(null);

            return;
        }

        try {

            /*
             * --------------------------------
             * 1. Clean Gemini response
             * --------------------------------
             */

            String cleanJson =
                    cleanJsonResponse(
                            structuredDataJson
                    );

            /*
             * --------------------------------
             * 2. Parse JSON
             * --------------------------------
             */

            JSONObject json =
                    new JSONObject(cleanJson);

            /*
             * --------------------------------
             * 3. Read isStructured
             * --------------------------------
             */

            boolean isStructured =
                    json.optBoolean(
                            "isStructured",
                            false
                    );

            document.setStructuredData(
                    isStructured
            );

            /*
             * --------------------------------
             * 4. Handle non-structured document
             * --------------------------------
             */

            if (!isStructured) {

                document.setStructuredDataType(
                        null
                );

                System.out.println(
                        "================================="
                );

                System.out.println(
                        "STRUCTURED DATA NOT DETECTED"
                );

                System.out.println(
                        "================================="
                );

                return;
            }

            /*
             * --------------------------------
             * 5. Read type
             * --------------------------------
             */

            String type =
                    json.optString(
                            "type",
                            "UNKNOWN"
                    );

            document.setStructuredDataType(
                    type
            );

            /*
             * --------------------------------
             * 6. Read columns
             * --------------------------------
             */

            JSONArray columns =
                    json.optJSONArray(
                            "columns"
                    );

            /*
             * --------------------------------
             * 7. Read rows
             * --------------------------------
             */

            JSONArray rows =
                    json.optJSONArray(
                            "rows"
                    );

            /*
             * --------------------------------
             * 8. Debug information
             * --------------------------------
             */

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "STRUCTURED DATA DETECTED"
            );

            System.out.println(
                    "Type: "
                            + type
            );

            if (columns != null) {

                System.out.println(
                        "Columns: "
                                + columns.toString()
                );

                System.out.println(
                        "Column count: "
                                + columns.length()
                );

            } else {

                System.out.println(
                        "Columns: []"
                );

                System.out.println(
                        "Column count: 0"
                );
            }

            if (rows != null) {

                System.out.println(
                        "Rows: "
                                + rows.length()
                );

            } else {

                System.out.println(
                        "Rows: 0"
                );
            }

            /*
             * Print each row for debugging.
             */

            if (rows != null) {

                for (int i = 0;
                        i < rows.length();
                        i++) {

                    JSONObject row =
                            rows.optJSONObject(i);

                    if (row != null) {

                        System.out.println(
                                "Row "
                                        + (i + 1)
                                        + ": "
                                        + row.toString()
                        );
                    }
                }
            }

            System.out.println(
                    "================================="
            );

        } catch (Exception e) {

            /*
             * --------------------------------
             * Invalid JSON must NOT break upload
             * --------------------------------
             */

            document.setStructuredData(
                    false
            );

            document.setStructuredDataType(
                    null
            );

            System.out.println(
                    "================================="
            );

            System.out.println(
                    "STRUCTURED DATA PROCESSING FAILED"
            );

            System.out.println(
                    "Gemini returned invalid structured JSON."
            );

            System.out.println(
                    "The document upload will continue."
            );

            System.out.println(
                    "================================="
            );

            e.printStackTrace();
        }
    }

    /*
     * --------------------------------
     * Clean Gemini JSON response
     * --------------------------------
     *
     * Gemini may sometimes return:
     *
     * ```json
     * {
     *     ...
     * }
     * ```
     *
     * This method removes the Markdown
     * code block before parsing.
     */

    private String cleanJsonResponse(
            String response) {

        String result =
                response.trim();

        if (result.startsWith("```json")) {

            result =
                    result.substring(
                            7
                    );

        } else if (result.startsWith("```")) {

            result =
                    result.substring(
                            3
                    );
        }

        if (result.endsWith("```")) {

            result =
                    result.substring(
                            0,
                            result.length() - 3
                    );
        }

        return result.trim();
    }
}