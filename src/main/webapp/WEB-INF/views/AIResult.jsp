<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>

<%
    DocumentEntity document =
            (DocumentEntity) request.getAttribute("document");

    String summary =
            (String) request.getAttribute("summary");

    String error =
            (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <title>AI Result - Teacher's Friend</title>

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

        .result-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        }

        .result-card h2 {
            margin-top: 0;
            color: #1f3c88;
        }

        .summary {
            white-space: pre-wrap;
            line-height: 1.7;
            font-size: 16px;
        }

        .error {
            background: #ffe5e5;
            color: #b00020;
            padding: 15px;
            border-radius: 8px;
        }

        .back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: #1f3c88;
            font-weight: bold;
        }

    </style>
</head>

<body>

<div class="container">

    <div class="header">

        <h1>🤖 AI Result</h1>

        <p>
            AI-generated result for your teaching document.
        </p>

    </div>


    <div class="document-card">

        <div class="document-name">

            📄 <%= document.getFileName() %>

        </div>

    </div>


    <div class="result-card">

        <h2>📝 Document Summary</h2>

        <% if (error != null) { %>

            <div class="error">

                <strong>AI Error:</strong>

                <%= error %>

            </div>

        <% } else if (summary != null) { %>

            <div class="summary">

                <%= summary %>

            </div>

        <% } else { %>

            <p>No AI result available.</p>

        <% } %>

    </div>


    <a class="back"
       href="/teacher/ai?id=<%= document.getDocumentId() %>">

        ← Back to AI Assistant

    </a>

</div>

</body>
</html>