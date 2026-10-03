<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>

<%
    DocumentEntity document =
            (DocumentEntity) request.getAttribute("document");
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

        .back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: #1f3c88;
            font-weight: bold;
        }

        @media (max-width: 700px) {

            .actions {
                grid-template-columns: 1fr;
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


    <!-- AI Actions -->

    <div class="ai-card">

        <h2>
            What would you like AI to do?
        </h2>

        <p>
            Choose an option to work with the extracted document text.
        </p>


        <div class="actions">

           <form action="/teacher/ai/summarize" method="post">
    <input type="hidden"
           name="id"
           value="<%= document.getDocumentId() %>">

    <button type="submit" class="ai-btn">
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


    <!-- Back -->

    <a class="back"
       href="/teacher/documents">

        ← Back to My Documents

    </a>

</div>

</body>
</html>