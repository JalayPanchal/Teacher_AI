
<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>

<%
    DocumentEntity document =
            (DocumentEntity) request.getAttribute("document");

    String summary =
            (String) request.getAttribute("summary");

    String error =
            (String) request.getAttribute("error");

    String followUpQuestion =
            (String) request.getAttribute("followUpQuestion");

    String followUpAnswer =
            (String) request.getAttribute("followUpAnswer");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>AI Summary - Teacher_AI</title>

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
            max-width: 1050px;
            margin: 40px auto;
        }

        /* =========================
           HEADER
           ========================= */

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

        /* =========================
           DOCUMENT CARD
           ========================= */

        .document-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .document-name {
            font-size: 18px;
            font-weight: bold;
        }

        .document-info {
            margin-top: 7px;
            color: #777;
            font-size: 14px;
        }

        /* =========================
           SUMMARY CARD
           ========================= */

        .summary-card {
            background: white;
            padding: 30px;
            border-radius: 14px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .summary-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 22px;
        }

        .summary-header h2 {
            margin: 0;
            color: #1f3c88;
        }

        .summary-badge {
            background: #eef2ff;
            color: #1f3c88;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .summary {
            white-space: pre-wrap;
            line-height: 1.75;
            font-size: 16px;
            color: #333;
        }

        /* =========================
           FOLLOW-UP
           ========================= */

        .follow-up {
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }

        .follow-up h3 {
            margin-top: 0;
            color: #222;
        }

        .follow-up-description {
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

        .examples {
            margin-top: 14px;
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

        /* =========================
           FOLLOW-UP ANSWER
           ========================= */

        .follow-up-answer {
            margin-top: 22px;
            background: #f8faff;
            border: 1px solid #e1e8ff;
            border-radius: 10px;
            padding: 20px;
        }

        .follow-up-title {
            color: #1f3c88;
            font-weight: bold;
            margin-bottom: 12px;
        }

        .follow-up-question {
            color: #666;
            font-size: 14px;
            margin-bottom: 12px;
        }

        .follow-up-text {
            white-space: pre-wrap;
            line-height: 1.7;
            color: #333;
        }

        /* =========================
           ERROR
           ========================= */

        .error {
            background: #fff4f4;
            border: 1px solid #ffd5d5;
            color: #b42318;
            padding: 15px;
            border-radius: 9px;
            margin-bottom: 20px;
        }

        /* =========================
           BACK
           ========================= */

        .back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: #1f3c88;
            font-weight: bold;
        }

        /* =========================
           MOBILE
           ========================= */

        @media (max-width: 700px) {

            .container {
                width: 94%;
                margin: 25px auto;
            }

            .summary-card {
                padding: 22px;
            }

            .summary-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .question-form {
                flex-direction: column;
            }

            .ask-button {
                width: 100%;
            }

        }

    </style>

</head>

<body>

<div class="container">

    <!-- =========================
         HEADER
         ========================= -->

    <div class="header">

        <h1>🤖 AI Summary</h1>

        <p>
            A simple explanation of your teaching document.
        </p>

    </div>


    <!-- =========================
         DOCUMENT
         ========================= -->

    <div class="document-card">

        <div class="document-name">

            📄 <%= document.getFileName() %>

        </div>

        <div class="document-info">

            Ask AI about this document whenever you need.

        </div>

    </div>


    <!-- =========================
         ERROR
         ========================= -->

    <% if (error != null && !error.isBlank()) { %>

        <div class="error">

            ⚠️ <%= error %>

        </div>

    <% } %>


    <!-- =========================
         SUMMARY
         ========================= -->

    <div class="summary-card">

        <div class="summary-header">

            <h2>
                📝 What you should know
            </h2>

            <span class="summary-badge">
                Teacher-friendly
            </span>

        </div>


        <% if (summary != null && !summary.isBlank()) { %>

            <div class="summary">

                <%= summary %>

            </div>


            <!-- =========================
                 FOLLOW-UP AI
                 ========================= -->

            <div class="follow-up">

                <h3>
                    💬 Ask about this document
                </h3>

                <div class="follow-up-description">

                    You can ask another question without explaining
                    the document again.

                </div>


                <form
                    action="/teacher/ai/summary/ask"
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
                        placeholder="Ask something about this document..."
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
                        Explain this simply
                    </span>

                    <span class="example">
                        What do I need to do?
                    </span>

                    <span class="example">
                        What is the most important point?
                    </span>

                    <span class="example">
                        Are there any important dates?
                    </span>

                </div>


                <!-- =========================
                     FOLLOW-UP ANSWER
                     ========================= -->

                <% if (followUpAnswer != null
                        && !followUpAnswer.isBlank()) { %>

                    <div class="follow-up-answer">

                        <div class="follow-up-title">

                            🤖 Teacher_AI

                        </div>


                        <% if (followUpQuestion != null) { %>

                            <div class="follow-up-question">

                                <strong>You asked:</strong>
                                <%= followUpQuestion %>

                            </div>

                        <% } %>


                        <div class="follow-up-text">

                            <%= followUpAnswer %>

                        </div>

                    </div>

                <% } %>


            </div>

        <% } else if (error == null) { %>

            <p>
                No AI summary is available.
            </p>

        <% } %>

    </div>


    <!-- =========================
         BACK
         ========================= -->

    <a
        class="back"
        href="/teacher/ai?id=<%= document.getDocumentId() %>"
    >

        ← Back to AI Assistant

    </a>

</div>

</body>

</html>

