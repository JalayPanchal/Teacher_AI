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

    <div>
        <h3>📄 My Documents</h3>
        <p>Upload and analyze teaching documents.</p>
        <a href="/teacher/documents/upload">
    <button>Upload Document</button>
    
    <a href="/teacher/documents">
    <button>My Documents</button>
</a>
</a>
    </div>

    <div>
        <h3>🤖 AI Assistant</h3>
        <p>Ask AI questions about your documents.</p>
    </div>

    <div>
        <h3>📝 Question Generator</h3>
        <p>Generate question papers and question banks.</p>
    </div>

    <div>
        <h3>📊 My Work</h3>
        <p>Manage your teaching resources.</p>
    </div>
    
    <div>
    <a href="/logout" >
    		<button type="button"> LogOut</button>
    </a>
    </div>

</body>
</html>