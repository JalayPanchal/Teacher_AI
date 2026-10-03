<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!-- 
form :-
		first_Name* , last_Name* , email* , password* , gender* , state , city , contact_Num ----auth public----User,Admin---create teacher account
 -->
</head>
<body>

	
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Signup | Create Account</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .signup-container {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 600px;
            padding: 40px 35px;
            transition: transform 0.3s ease;
        }

        .signup-container:hover {
            transform: translateY(-5px);
        }

        h2 {
            text-align: center;
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .subtitle {
            text-align: center;
            color: #718096;
            font-size: 14px;
            margin-bottom: 30px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: flex;
            gap: 20px;
        }

        .form-row .form-group {
            flex: 1;
        }

        label {
            display: block;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 6px;
            font-size: 14px;
        }

        label .required {
            color: #e53e3e;
            margin-left: 2px;
        }

        input, select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s, box-shadow 0.3s;
            background-color: #f7fafc;
            color: #2d3748;
            font-family: inherit;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            background-color: #ffffff;
        }

        input::placeholder {
            color: #a0aec0;
            font-size: 14px;
        }

        .radio-group {
            display: flex;
            gap: 25px;
            padding-top: 8px;
            flex-wrap: wrap;
        }

        .radio-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            color: #4a5568;
            cursor: pointer;
            font-size: 15px;
        }

        .radio-group input[type="radio"] {
            width: 18px;
            height: 18px;
            accent-color: #667eea;
            cursor: pointer;
            flex-shrink: 0;
        }

        .auth-role {
            background: #edf2f7;
            padding: 15px 18px;
            border-radius: 10px;
            margin: 10px 0 5px;
        }

        .auth-role p {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .auth-role .radio-group label {
            font-weight: 400;
        }

        .btn-submit {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.5);
        }

        .btn-submit:active {
            transform: translateY(0px);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #718096;
            font-size: 15px;
        }

        .login-link a {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .field-note {
            font-size: 12px;
            color: #a0aec0;
            margin-top: 4px;
        }

        /* Responsive */
        @media (max-width: 500px) {
            .form-row {
                flex-direction: column;
                gap: 0;
            }

            .signup-container {
                padding: 25px 20px;
            }

            .radio-group {
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>Create Account</h2>
        <p class="subtitle">Join us — fill in the details below</p>

        <form action="/signup" method="POST">
            <!-- First & Last Name -->
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name <span class="required">*</span></label>
                    <input type="text" id="firstName" name="firstName" placeholder="John" required>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name <span class="required">*</span></label>
                    <input type="text" id="lastName" name="lastName" placeholder="Doe" required>
                </div>
            </div>

            <!-- Email -->
            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" placeholder="you@example.com" required>
            </div>

            <!-- Password -->
            <div class="form-group">
                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password"  >
            </div>

            <!-- Gender -->
            <div class="form-group">
                <label>Gender <span class="required">*</span></label>
                <div class="radio-group">
                    <label><input type="radio" name="gender" value="Male" required> Male</label>
                    <label><input type="radio" name="gender" value="Female" required> Female</label>
                    <label><input type="radio" name="gender" value="Other" required> Other</label>
                </div>
            </div>

            <!-- State & City -->
            <div class="form-row">
                <div class="form-group">
                    <label for="state">State</label>
                    <input type="text" id="state" name="state" placeholder="e.g., California">
                </div>
                <div class="form-group">
                    <label for="city">City</label>
                    <input type="text" id="city" name="city" placeholder="e.g., San Francisco">
                </div>
            </div>
			<div class="form-group">

    <label for="contactNum">Contact Number</label>

    <input
        type="tel"
        id="contactNum"
        name="contactNum"
        placeholder="9876543210"
        maxlength="10">

</div>
            </div>

            <!-- Hidden field to indicate this is a signup form (optional) -->
            <input type="hidden" name="action" value="signup">

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Log in</a>
        </div>
    </div>
</body>
</html>
