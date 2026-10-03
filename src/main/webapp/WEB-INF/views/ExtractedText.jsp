<!DOCTYPE html>
<html>

<head>

    <title>Extracted Text - Teacher's Friend</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
        }

        .header {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        h1 {
            margin: 0 0 8px 0;
        }

        .file-name {
            color: #666;
        }

        .text-box {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);

            white-space: pre-wrap;
            line-height: 1.7;

            min-height: 400px;
        }

        .empty {
            color: #888;
            text-align: center;
            padding: 80px 20px;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #1f3c88;
        }

    </style>

</head>

<body>

<div class="container">

    <div class="header">

        <h1>Extracted Text</h1>

        <div class="file-name">
            <strong>File:</strong>
            ${document.fileName}
        </div>

    </div>


    <div class="text-box">

        <%
            String text = ((com.Teacher_AI.entity.DocumentEntity)
                    request.getAttribute("document"))
                    .getExtractedText();

            if (text == null || text.trim().isEmpty()) {
        %>

            <div class="empty">

                <h2>No text extracted</h2>

                <p>
                    This document may be scanned or image-based.
                </p>

            </div>

        <%
            } else {
        %>

            <%= text %>

        <%
            }
        %>

    </div>


    <a class="back" href="/teacher/documents">
        ← Back to My Documents
    </a>

</div>

</body>

</html>