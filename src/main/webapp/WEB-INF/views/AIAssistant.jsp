
<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<%
    DocumentEntity document =
            (DocumentEntity) request.getAttribute("document");

    String structuredJson =
            document.getStructuredDataJson();

    boolean isStructured = false;
    String structuredType = null;
    JSONArray columns = null;
    JSONArray rows = null;

    if (structuredJson != null && !structuredJson.isBlank()) {

        try {

            JSONObject json =
                    new JSONObject(structuredJson);

            isStructured =
                    json.optBoolean("isStructured", false);

            structuredType =
                    json.optString("type", null);

            columns =
                    json.optJSONArray("columns");

            rows =
                    json.optJSONArray("rows");

        } catch (Exception e) {

            System.out.println(
                    "Could not parse structured data in JSP."
            );
        }
    }

    String question =
            (String) request.getAttribute("question");

    String answer =
            (String) request.getAttribute("answer");

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>AI Assistant - Teacher's Friend</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #222;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
        }

        /* Header */

        .header {
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
            color: #1f3c88;
        }

        .header p {
            color: #777;
            margin-top: 8px;
        }

        /* Document card */

        .document-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .document-name {
            font-size: 18px;
            font-weight: bold;
        }

        .document-info {
            margin-top: 8px;
            color: #777;
            font-size: 14px;
        }

        /* AI actions */

        .ai-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            margin-bottom: 25px;
        }

        .ai-card h2 {
            margin-top: 0;
        }

        .ai-card p {
            color: #777;
        }

        .actions {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 25px;
        }

        .ai-btn {
            border: none;
            padding: 18px;
            border-radius: 10px;
            background: #eef2ff;
            color: #1f3c88;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            text-align: left;
        }

        .ai-btn:hover {
            background: #e1e8ff;
        }

        .icon {
            font-size: 22px;
            margin-right: 8px;
        }

        /* Structured Data */

        .structured-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .structured-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .structured-header h2 {
            margin: 0;
            color: #222;
        }

        .structured-type {
            background: #eef2ff;
            color: #1f3c88;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .record-count {
            color: #777;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .table-wrapper {
            overflow-x: auto;
            border: 1px solid #eee;
            border-radius: 10px;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 650px;
        }

        .data-table th {
            background: #f8f9fc;
            color: #555;
            font-size: 14px;
            text-align: left;
            padding: 14px;
            border-bottom: 1px solid #eee;
            white-space: nowrap;
        }

        .data-table td {
            padding: 14px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .data-table tr:hover {
            background: #fafbff;
        }

        /* Ask AI */

        .ask-ai {
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }

        .ask-ai h3 {
            margin-top: 0;
            color: #222;
        }

        .ask-ai-description {
            color: #777;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .question-form {
            display: flex;
            gap: 10px;
        }

        .question-input {
            flex: 1;
            padding: 14px 16px;
            border: 1px solid #ddd;
            border-radius: 9px;
            font-size: 15px;
            outline: none;
        }

        .question-input:focus {
            border-color: #1f3c88;
        }

        .ask-button {
            border: none;
            background: #1f3c88;
            color: white;
            padding: 14px 22px;
            border-radius: 9px;
            font-weight: bold;
            cursor: pointer;
        }

        .ask-button:hover {
            opacity: 0.9;
        }

        /* Examples */

        .examples {
            margin-top: 15px;
            color: #777;
            font-size: 13px;
        }

        .example {
            display: inline-block;
            background: #f5f7fb;
            padding: 7px 10px;
            border-radius: 7px;
            margin: 5px 5px 0 0;
        }

        /* AI Answer */

        .answer-card {
            margin-top: 20px;
            background: #f8faff;
            border: 1px solid #e1e8ff;
            border-radius: 10px;
            padding: 20px;
        }

        .answer-title {
            font-weight: bold;
            color: #1f3c88;
            margin-bottom: 12px;
        }

        .question-display {
            color: #666;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .answer-text {
            white-space: pre-wrap;
            line-height: 1.7;
            color: #333;
        }

        /* Error */

        .error-card {
            margin-top: 20px;
            background: #fff4f4;
            border: 1px solid #ffd5d5;
            color: #b42318;
            padding: 15px;
            border-radius: 9px;
        }

        /* Not structured */

        .not-structured {
            text-align: center;
            padding: 40px 20px;
            color: #777;
        }

        .not-structured-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }

        /* Back */

        .back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: #1f3c88;
            font-weight: bold;
        }

        /* Mobile */

        @media (max-width: 700px) {

            .container {
                width: 94%;
                margin: 25px auto;
            }

            .actions {
                grid-template-columns: 1fr;
            }

            .question-form {
                flex-direction: column;
            }

            .ask-button {
                width: 100%;
            }

            .structured-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }

    </style>

</head>

<body>

<div class="container">

    <!-- Header -->

    <div class="header">

        <h1>🤖 AI Assistant</h1>

        <p>
            Let AI help you work with your teaching document.
        </p>

    </div>


    <!-- Selected document -->

    <div class="document-card">

        <div class="document-name">

            📄 <%= document.getFileName() %>

        </div>

        <div class="document-info">

            Type:
            <%= document.getFileType() %>

            &nbsp; | &nbsp;

            Status:
            <%= document.getStatus() %>

        </div>

    </div>


    <!-- Existing AI Actions -->

    <div class="ai-card">

        <h2>
            What would you like AI to do?
        </h2>

        <p>
            Choose an option to work with your teaching document.
        </p>


        <div class="actions">

            <!-- Summarize -->

            <form action="/teacher/ai/summarize" method="post">

                <input
                    type="hidden"
                    name="id"
                    value="<%= document.getDocumentId() %>"
                >

                <button
                    type="submit"
                    class="ai-btn"
                >

                    <span class="icon">📝</span>

                    Summarize Document

                </button>

            </form>


            <button class="ai-btn">

                <span class="icon">❓</span>

                Generate Questions

            </button>


            <button class="ai-btn">

                <span class="icon">☑️</span>

                Generate MCQs

            </button>


            <button class="ai-btn">

                <span class="icon">💡</span>

                Explain Simply

            </button>


            <button class="ai-btn">

                <span class="icon">📚</span>

                Create Lesson Plan

            </button>


            <button class="ai-btn">

                <span class="icon">🌐</span>

                Translate Document

            </button>

        </div>

    </div>


    <!-- ===================================================== -->
    <!-- STRUCTURED DATA -->
    <!-- ===================================================== -->

    <div class="structured-card">

        <% if (isStructured && columns != null && rows != null) { %>


            <div class="structured-header">

                <h2>
                    📊 Structured Data
                </h2>

                <span class="structured-type">
                    <%= structuredType != null
                            ? structuredType
                            : "Structured Data" %>
                </span>

            </div>


            <div class="record-count">

                <%= rows.length() %> records detected

            </div>


            <!-- Table -->

            <div class="table-wrapper">

                <table class="data-table">

                    <thead>

                        <tr>

                            <%
                                for (int i = 0;
                                     i < columns.length();
                                     i++) {
                            %>

                                <th>
                                    <%= columns.optString(i) %>
                                </th>

                            <%
                                }
                            %>

                        </tr>

                    </thead>


                    <tbody>

                        <%
                            for (int i = 0;
                                 i < rows.length();
                                 i++) {

                                JSONObject row =
                                        rows.optJSONObject(i);
                        %>

                            <tr>

                                <%
                                    for (int j = 0;
                                         j < columns.length();
                                         j++) {

                                        String columnName =
                                                columns.optString(j);

                                        String value =
                                                row != null
                                                ? row.optString(
                                                        columnName,
                                                        ""
                                                  )
                                                : "";
                                %>

                                    <td>
                                        <%= value %>
                                    </td>

                                <%
                                    }
                                %>

                            </tr>

                        <%
                            }
                        %>

                    </tbody>

                </table>

            </div>


            <!-- ================================================= -->
            <!-- ASK AI ABOUT TABLE -->
            <!-- ================================================= -->

            <div class="ask-ai">

                <h3>
                    🤖 Ask AI about this table
                </h3>

                <div class="ask-ai-description">

                    Ask questions about the records,
                    values, scores, percentages or other
                    information in this table.

                </div>


                <form
                    action="/teacher/ai/ask"
                    method="post"
                    class="question-form"
                >

                    <input
                        type="hidden"
                        name="id"
                        value="<%= document.getDocumentId() %>"
                    >


                    <input
                        type="text"
                        name="question"
                        class="question-input"
                        placeholder="Ask something about these records..."
                        value="<%= question != null ? question : "" %>"
                        required
                    >


                    <button
                        type="submit"
                        class="ask-button"
                    >

                        Ask AI ➤

                    </button>

                </form>


                <!-- Examples -->

                <div class="examples">

                    Try asking:

                    <span class="example">
                        Who scored the highest?
                    </span>

                    <span class="example">
                        What is the average score?
                    </span>

                    <span class="example">
                        Show students from 10-A.
                    </span>

                    <span class="example">
                        Who scored below 80?
                    </span>

                </div>


                <!-- AI Answer -->

                <% if (answer != null && !answer.isBlank()) { %>

                    <div class="answer-card">

                        <div class="answer-title">
                            🤖 AI Answer
                        </div>

                        <% if (question != null) { %>

                            <div class="question-display">

                                <strong>Question:</strong>
                                <%= question %>

                            </div>

                        <% } %>


                        <div class="answer-text">

                            <%= answer %>

                        </div>

                    </div>

                <% } %>


                <!-- Error -->

                <% if (error != null && !error.isBlank()) { %>

                    <div class="error-card">

                        ⚠️ <%= error %>

                    </div>

                <% } %>

            </div>


        <% } else { %>


            <!-- No structured data -->

            <div class="not-structured">

                <div class="not-structured-icon">
                    📄
                </div>

                <h2>
                    No structured data detected
                </h2>

                <p>
                    AI did not detect a table or
                    record-based structure in this document.
                </p>

                <p>
                    You can still use the document
                    AI actions above.
                </p>

            </div>


        <% } %>

    </div>


    <!-- Back -->

    <a
        class="back"
        href="/teacher/documents"
    >

        ← Back to My Documents

    </a>

</div>

</body>

</html>
