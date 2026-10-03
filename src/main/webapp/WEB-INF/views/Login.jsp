<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Minimal Login</title>
  <style>
    /* minimal, clean base */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
      background: #f7f9fc;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 1.5rem;
    }

    .login-card {
      background: #ffffff;
      border-radius: 28px;
      box-shadow: 0 12px 30px rgba(0, 0, 0, 0.05), 0 4px 10px rgba(0, 0, 0, 0.02);
      padding: 2.5rem 2rem;
      width: 100%;
      max-width: 380px;
      transition: transform 0.2s ease;
    }

    .login-card h1 {
      font-size: 1.9rem;
      font-weight: 500;
      letter-spacing: -0.02em;
      color: #0b1b2b;
      margin-bottom: 0.25rem;
      text-align: left;
    }

    .login-card .subhead {
      font-size: 0.95rem;
      color: #6b7b8b;
      margin-bottom: 2rem;
      font-weight: 400;
      border-left: 3px solid #d0ddeb;
      padding-left: 0.9rem;
    }

    .input-group {
      margin-bottom: 1.5rem;
    }

    .input-group label {
      display: block;
      font-size: 0.85rem;
      font-weight: 500;
      color: #1f2e3d;
      margin-bottom: 0.5rem;
      letter-spacing: 0.01em;
    }

    .input-group input {
      width: 100%;
      padding: 1rem 1.2rem;
      font-size: 1rem;
      background: #ffffff;
      border: 1.5px solid #e2e9f2;
      border-radius: 18px;
      outline: none;
      transition: border-color 0.2s ease, box-shadow 0.2s ease;
      color: #0b1b2b;
      font-family: inherit;
    }

    .input-group input::placeholder {
      color: #9aacbf;
      font-weight: 300;
    }

    .input-group input:hover {
      border-color: #cbd8e9;
    }

    .input-group input:focus {
      border-color: #1e4b6e;
      box-shadow: 0 0 0 4px rgba(30, 75, 110, 0.08);
    }

    /* keeping the form exactly as requested: action="/login" method="post" */
    /* no extra hidden fields, no extra inputs — pure minimal */

    .actions {
      margin-top: 2.2rem;
    }

    .login-btn {
      width: 100%;
      background: #0b1b2b;
      color: #ffffff;
      border: none;
      border-radius: 40px;
      padding: 1rem 1.5rem;
      font-size: 1rem;
      font-weight: 500;
      letter-spacing: 0.02em;
      cursor: pointer;
      transition: background 0.2s ease, transform 0.1s ease;
      font-family: inherit;
      box-shadow: 0 8px 16px -6px rgba(11, 27, 43, 0.2);
    }

    .login-btn:hover {
      background: #1a2f42;
    }

    .login-btn:active {
      transform: scale(0.98);
      background: #0a1a28;
    }

    .footer-note {
      text-align: center;
      margin-top: 1.8rem;
      font-size: 0.85rem;
      color: #8b9aab;
    }

    .footer-note a {
      color: #1e4b6e;
      text-decoration: none;
      font-weight: 500;
      border-bottom: 1px solid transparent;
      transition: border-color 0.15s;
    }

    .footer-note a:hover {
      border-bottom-color: #1e4b6e;
    }
  </style>
</head>
<body>
  <div class="login-card">
    <h1>Welcome back</h1>
    <div class="subhead">sign in to continue</div>

    <!-- exactly the requested form: action="/login" method="post" -->
    <form action="/login" method="post">
      <div class="input-group">
        <label for="email">Email</label>
        <input 
          type="email" 
          name="email" 
          id="email" 
          placeholder="your@email.com" 
          required 
          autocomplete="email"
        >
      </div>

      <div class="input-group">
        <label for="password">Password</label>
        <input 
          type="password" 
          name="password" 
          id="password" 
          placeholder="••••••••" 
          required 
          autocomplete="current-password"
        >
      </div>

      <div class="actions">
        <button type="submit" class="login-btn">Log in</button>
      </div>
    </form>

    <div class="footer-note">
      <a href="#">Forgot password?</a>
    </div>
  </div>
</body>
</html>