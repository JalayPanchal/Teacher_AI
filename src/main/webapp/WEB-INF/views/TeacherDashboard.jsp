<!DOCTYPE html>
<html>

<head>

    <title>Teacher Dashboard</title>

</head>

<body>

    <h1>Welcome to Teacher AI 👨‍🏫</h1>

    <h1>Welcome, ${sessionScope.user.firstName}</h1>

    <p>You are logged in as a Teacher.</p>

    <h2>Teacher Dashboard</h2>


    <!-- ===================================================== -->
    <!-- LANGUAGE SELECTION -->
    <!-- ===================================================== -->

    <div>

        <h3>🌐 AI Language</h3>

        <form action="/teacher/language" method="post">

            <label for="language">
                Choose the language for AI responses:
            </label>

            <select id="language"
                    name="language">

                <option value="English"
                    ${sessionScope.teacherLanguage == 'English' ? 'selected' : ''}>
                    English
                </option>

                <option value="Hindi"
                    ${sessionScope.teacherLanguage == 'Hindi' ? 'selected' : ''}>
                    हिंदी (Hindi)
                </option>

                <option value="Gujarati"
                    ${sessionScope.teacherLanguage == 'Gujarati' ? 'selected' : ''}>
                    ગુજરાતી (Gujarati)
                </option>

            </select>

            <button type="submit">
                Save Language
            </button>

        </form>

        <p>
            Current language:
            <strong>${sessionScope.teacherLanguage}</strong>
        </p>

    </div>


    <!-- ===================================================== -->
    <!-- MY DOCUMENTS -->
    <!-- ===================================================== -->

    <div>

        <h3>📄 My Documents</h3>

        <p>Upload and analyze teaching documents.</p>

        <a href="/teacher/documents/upload">
            <button type="button">
                Upload Document
            </button>
        </a>

        <a href="/teacher/documents">
            <button type="button">
                My Documents
            </button>
        </a>

    </div>


    <!-- ===================================================== -->
    <!-- AI ASSISTANT -->
    <!-- ===================================================== -->

    <div>

        <h3>🤖 AI Assistant</h3>

        <p>
            Ask AI questions about your documents.
        </p>

    </div>


    <!-- ===================================================== -->
    <!-- QUESTION GENERATOR -->
    <!-- ===================================================== -->

    <div>

        <h3>📝 Question Generator</h3>

        <p>
            Generate question papers and question banks.
        </p>

    </div>


    <!-- ===================================================== -->
    <!-- MY WORK -->
    <!-- ===================================================== -->

    <div>

        <h3>📊 My Work</h3>

        <p>
            Manage your teaching resources.
        </p>

    </div>


    <!-- ===================================================== -->
    <!-- LOGOUT -->
    <!-- ===================================================== -->

    <div>

        <a href="/logout">

            <button type="button">
                LogOut
            </button>

        </a>

    </div>		

</body>

</html>