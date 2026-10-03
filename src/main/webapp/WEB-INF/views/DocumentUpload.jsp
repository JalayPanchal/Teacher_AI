<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

    <title>Upload Document - Teacher's Friend</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
        }

        .container {
            width: 600px;
            margin: 80px auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        h1 {
            margin-bottom: 10px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }

        .upload-box {
            border: 2px dashed #999;
            border-radius: 12px;
            padding: 50px 20px;
            text-align: center;
            margin-bottom: 25px;
        }

        input[type="file"] {
            margin-top: 20px;
        }

        button {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            background: #1f3c88;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #162d68;
        }

        .success {
            color: green;
            margin-bottom: 20px;
        }

        .error {
            color: red;
            margin-bottom: 20px;
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

    <h1>Upload Document</h1>

    <p class="subtitle">
        Upload a document and let Teacher's Friend help you.
    </p>

    <% if ("true".equals(request.getParameter("success"))) { %>

        <div class="success">
            Document uploaded successfully! ✓
        </div>

    <% } %>

    <% if ("empty".equals(request.getParameter("error"))) { %>

        <div class="error">
            Please select a file first.
        </div>

    <% } %>


    <form action="/teacher/documents/upload"
          method="post"
          enctype="multipart/form-data">

        <div class="upload-box">

            <strong>Select your document</strong>

            <br>

            <small>
                PDF, images and other teacher documents
            </small>

            <br>

            <input type="file"
                   name="file"
                   required>

        </div>

        <button type="submit">
            Upload Document
        </button>

    </form>

    <a class="back" href="/TeacherDashboard">
        ← Back to Dashboard
    </a>

</div>

</body>
</html>