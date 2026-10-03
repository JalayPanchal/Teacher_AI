<%@ page import="java.util.List" %>
<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Documents - Teacher's Friend</title>

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
            width: 92%;
            max-width: 1200px;
            margin: 40px auto;
        }

        /* Header */

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
            color: #1f3c88;
        }

        .header p {
            margin-top: 8px;
            color: #777;
        }

        .upload-btn {
            background: #1f3c88;
            color: white;
            padding: 12px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
        }

        .upload-btn:hover {
            opacity: 0.9;
        }

        /* Documents card */
		
		/* Search */

.search-box {
    background: white;
    padding: 15px;
    border-radius: 12px;
    margin-bottom: 20px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.05);
}

.search-box form {
    display: flex;
    gap: 10px;
    align-items: center;
}

.search-box input {
    flex: 1;
    padding: 12px 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 14px;
    outline: none;
}

.search-box input:focus {
    border-color: #1f3c88;
}

.search-box button {
    border: none;
    background: #1f3c88;
    color: white;
    padding: 12px 18px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: bold;
}

.search-box button:hover {
    opacity: 0.9;
}

.search-box a {
    text-decoration: none;
    color: #666;
    padding: 10px;
}
		
        .documents {
            background: white;
            border-radius: 14px;
            padding: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.06);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 750px;
        }

        th {
            padding: 15px;
            text-align: left;
            background: #f8f9fc;
            color: #555;
            font-size: 14px;
        }

        td {
            padding: 16px 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        tr:hover {
            background: #fafbff;
        }

        /* File */

        .file-name {
            font-weight: bold;
            color: #222;
            max-width: 300px;
            word-break: break-word;
        }

        .file-icon {
            font-size: 24px;
            margin-right: 10px;
        }

        .file-info {
            display: flex;
            align-items: center;
        }

        /* Type */

        .type {
            color: #666;
            font-size: 14px;
        }

        /* Status */

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            background: #e8f7ee;
            color: #168544;
            font-size: 13px;
            font-weight: bold;
        }

        /* Actions */

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 7px 11px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .open-btn {
            background: #e8efff;
            color: #1f3c88;
        }

        .text-btn {
            background: #eeeaff;
            color: #6b46c1;
        }

        .delete-btn {
            background: #ffeaea;
            color: #d93025;
        }

        .action-btn:hover {
            opacity: 0.8;
        }

        /* Empty */

        .empty {
            text-align: center;
            padding: 70px 20px;
            color: #777;
        }

        .empty-icon {
            font-size: 50px;
            margin-bottom: 15px;
        }

        .empty h2 {
            color: #333;
        }

        .empty .upload-btn {
            display: inline-block;
            margin-top: 15px;
        }

        /* Back */

        .back {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            color: #1f3c88;
            font-weight: bold;
        }

        @media (max-width: 700px) {

            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .upload-btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <!-- Header -->

   <div class="header">

    <div>
        <h1>My Documents</h1>
        <p>Manage your uploaded teaching documents</p>
    </div>

    <a class="upload-btn"
       href="/teacher/documents/upload">
        + Upload Document
    </a>

</div>

<!-- Search -->

<div class="search-box">

    <form action="/teacher/documents" method="get">

        <input
            type="text"
            name="search"
            placeholder="Search documents..."
            value="<%= request.getAttribute("search") != null
                    ? request.getAttribute("search")
                    : "" %>">

        <button type="submit">
            🔍 Search
        </button>

        <a href="/teacher/documents">
            Clear
        </a>

    </form>

</div>


    <!-- Documents -->

    <div class="documents">

      <%
    List<DocumentEntity> documents =
            (List<DocumentEntity>) request.getAttribute("documents");

    String search =
            (String) request.getAttribute("search");

    boolean isSearching =
            search != null && !search.trim().isEmpty();

    if (documents == null || documents.isEmpty()) {
%>

    <div class="empty">

        <% if (isSearching) { %>

            <div class="empty-icon">🔍</div>

            <h2>No matching documents found</h2>

            <p>
                No document matches
                "<strong><%= search %></strong>".
            </p>

            <a class="upload-btn"
               href="/teacher/documents">
                Clear Search
            </a>

        <% } else { %>

            <div class="empty-icon">📄</div>

            <h2>No documents yet</h2>

            <p>
                Upload your first teaching document to get started.
            </p>

            <a class="upload-btn"
               href="/teacher/documents/upload">
                Upload Document
            </a>

        <% } %>

    </div>

        <%
            } else {
        %>

        <table>

            <thead>

                <tr>
                    <th>Document</th>
                    <th>Type</th>
                    <th>Size</th>
                    <th>Status</th>
                    <th>Uploaded</th>
                    <th>Actions</th>
                </tr>

            </thead>

            <tbody>

            <%
                for (DocumentEntity document : documents) {

                    String fileType = document.getFileType();

                    String icon = "📄";

                    if (fileType != null) {

                        if (fileType.contains("pdf")) {
                            icon = "📕";
                        }
                        else if (fileType.startsWith("image/")) {
                            icon = "🖼️";
                        }
                    }

                    long size = document.getFileSize();

                    String readableSize;

                    if (size >= 1024 * 1024) {
                        readableSize =
                            String.format("%.2f MB",
                                size / (1024.0 * 1024.0));
                    }
                    else if (size >= 1024) {
                        readableSize =
                            String.format("%.2f KB",
                                size / 1024.0);
                    }
                    else {
                        readableSize = size + " B";
                    }
            %>

                <tr>

                    <!-- Document -->

                    <td>

                        <div class="file-info">

                            <span class="file-icon">
                                <%= icon %>
                            </span>

                            <span class="file-name">
                                <%= document.getFileName() %>
                            </span>

                        </div>

                    </td>


                    <!-- Type -->

                    <td class="type">

                        <%= fileType != null
                                ? fileType
                                : "Unknown" %>

                    </td>


                    <!-- Size -->

                    <td>

                        <%= readableSize %>

                    </td>


                    <!-- Status -->

                    <td>

                        <span class="status">

                            <%= document.getStatus() %>

                        </span>

                    </td>


                    <!-- Uploaded -->

                    <td>

                        <%= document.getCreatedAt() %>

                    </td>


                    <!-- Actions -->

                    <td>

                        <div class="actions">

                            <a class="action-btn open-btn"
                               href="/teacher/documents/view?id=<%= document.getDocumentId() %>"
                               target="_blank">
                                Open
                            </a>

                            <a class="action-btn text-btn"
                               href="/teacher/documents/text?id=<%= document.getDocumentId() %>">
                                Text
                            </a>

							<a class="action-btn text-btn"
   href="/teacher/ai?id=<%= document.getDocumentId() %>">
    🤖 AI
</a>
                            <a class="action-btn delete-btn"
                               href="/teacher/documents/delete?id=<%= document.getDocumentId() %>"
                               onclick="return confirm('Are you sure you want to delete this document?');">
                                Delete
                            </a>

                        </div>

                    </td>

                </tr>

            <%
                }
            %>

            </tbody>

        </table>

        <%
            }
        %>

    </div>


    <!-- Back -->

    <a class="back"
       href="/TeacherDashboard">
        ← Back to Dashboard
    </a>

</div>

</body>
</html>