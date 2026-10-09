<%@ page import="com.Teacher_AI.entity.DocumentEntity" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>

<%
DocumentEntity document =
		(DocumentEntity) request.getAttribute("document");

String structuredJson =
        document.getStructuredDataJson();

boolean isStructured = false;
String structuredType = null;
JSONArray columns = null;
JSONArray rows = null;

if (structuredJson != null && !structuredJson.isBlank()) {

    try {

        JSONObject json =
                new JSONObject(structuredJson);

        isStructured =
                json.optBoolean("isStructured", false);

        structuredType =
                json.optString("type", null);

        columns =
                json.optJSONArray("columns");

        rows =
                json.optJSONArray("rows");

    } catch (Exception e) {

        System.out.println(
                "Could not parse structured data in JSP."
        );
    }
}

String question =
        (String) request.getAttribute("question");

String answer =
        (String) request.getAttribute("answer");

String error =
        (String) request.getAttribute("error");


%>

<!DOCTYPE html>

<html>

<head>

```
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

    /* =========================
       AI ACTIONS
       ========================= */

    .ai-card {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.06);
        margin-bottom: 25px;
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

    /* =========================
       STRUCTURED DATA CARD
       ========================= */

    .structured-card {
        background: white;
        padding: 25px;
        border-radius: 12px;
        margin-bottom: 25px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.06);
    }

    .structured-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 18px;
    }

    .structured-header h2 {
        margin: 0;
        color: #222;
    }

    .structured-type {
        background: #eef2ff;
        color: #1f3c88;
        padding: 7px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: bold;
    }

    /* =========================
       FILTER SECTION
       ========================= */

    .filter-section {
        background: #f8f9fc;
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 18px;
        margin-bottom: 18px;
    }

    .filter-title {
        font-size: 15px;
        font-weight: bold;
        color: #333;
        margin-bottom: 12px;
    }

    .filter-row {
        display: flex;
        gap: 10px;
        align-items: center;
        flex-wrap: wrap;
    }

    .search-box {
        flex: 1;
        min-width: 240px;
    }

    .search-input {
        width: 100%;
        padding: 13px 15px;
        border: 1px solid #ddd;
        border-radius: 9px;
        font-size: 14px;
        outline: none;
        background: white;
    }

    .search-input:focus {
        border-color: #1f3c88;
    }

    .dynamic-filter {
        min-width: 170px;
        padding: 13px 14px;
        border: 1px solid #ddd;
        border-radius: 9px;
        background: white;
        font-size: 14px;
        color: #333;
        outline: none;
        cursor: pointer;
    }

    .dynamic-filter:focus {
        border-color: #1f3c88;
    }

    .reset-button {
        border: none;
        padding: 13px 18px;
        border-radius: 9px;
        background: #eef2ff;
        color: #1f3c88;
        font-size: 14px;
        font-weight: bold;
        cursor: pointer;
    }

    .reset-button:hover {
        background: #e1e8ff;
    }

    .record-count {
        color: #777;
        font-size: 14px;
        margin-bottom: 18px;
    }

    /* =========================
       TABLE
       ========================= */

    .table-wrapper {
        overflow-x: auto;
        border: 1px solid #eee;
        border-radius: 10px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 650px;
    }

    .data-table th {
        background: #f8f9fc;
        color: #555;
        font-size: 14px;
        text-align: left;
        padding: 14px;
        border-bottom: 1px solid #eee;
        white-space: nowrap;
    }

    .data-table td {
        padding: 14px;
        border-bottom: 1px solid #eee;
        font-size: 14px;
    }

    .data-table tr:last-child td {
        border-bottom: none;
    }

    .data-table tr:hover {
        background: #fafbff;
    }

    .no-results-row {
        display: none;
    }

    .no-results-row td {
        text-align: center;
        padding: 35px 20px;
        color: #777;
        font-size: 15px;
    }

    /* =========================
       ASK AI
       ========================= */

    .ask-ai {
        margin-top: 25px;
        padding-top: 25px;
        border-top: 1px solid #eee;
    }

    .ask-ai h3 {
        margin-top: 0;
        color: #222;
    }

    .ask-ai-description {
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

    /* =========================
       EXAMPLES
       ========================= */

    .examples {
        margin-top: 15px;
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
       AI ANSWER
       ========================= */

    .answer-card {
        margin-top: 20px;
        background: #f8faff;
        border: 1px solid #e1e8ff;
        border-radius: 10px;
        padding: 20px;
    }

    .answer-title {
        font-weight: bold;
        color: #1f3c88;
        margin-bottom: 12px;
    }

    .question-display {
        color: #666;
        font-size: 14px;
        margin-bottom: 12px;
    }

    .answer-text {
        white-space: pre-wrap;
        line-height: 1.7;
        color: #333;
    }

    /* =========================
       ERROR
       ========================= */

    .error-card {
        margin-top: 20px;
        background: #fff4f4;
        border: 1px solid #ffd5d5;
        color: #b42318;
        padding: 15px;
        border-radius: 9px;
    }

    /* =========================
       NOT STRUCTURED
       ========================= */

    .not-structured {
        text-align: center;
        padding: 40px 20px;
        color: #777;
    }

    .not-structured-icon {
        font-size: 40px;
        margin-bottom: 10px;
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

        .actions {
            grid-template-columns: 1fr;
        }

        .filter-row {
            flex-direction: column;
            align-items: stretch;
        }

        .search-box {
            min-width: 100%;
        }

        .dynamic-filter {
            width: 100%;
        }

        .reset-button {
            width: 100%;
        }

        .question-form {
            flex-direction: column;
        }

        .ask-button {
            width: 100%;
        }

        .structured-header {
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
        }
    }

</style>
```

</head>

<body>

<div class="container">

```
<!-- =========================
     HEADER
     ========================= -->

<div class="header">

    <h1>🤖 AI Assistant</h1>

    <p>
        Let AI help you work with your teaching document.
    </p>

</div>


<!-- =========================
     SELECTED DOCUMENT
     ========================= -->

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


<!-- =========================
     EXISTING AI ACTIONS
     ========================= -->

<div class="ai-card">

    <h2>
        What would you like AI to do?
    </h2>

    <p>
        Choose an option to work with your teaching document.
    </p>

    <div class="actions">


        <!-- Summarize -->

        <form
            action="/teacher/ai/summarize"
            method="post"
        >

            <input
                type="hidden"
                name="id"
                value="<%= document.getDocumentId() %>"
            >

            <button
                type="submit"
                class="ai-btn"
            >

                <span class="icon">📝</span>

                Summarize Document

            </button>

        </form>


        <!-- Generate Questions -->

        <button class="ai-btn">

            <span class="icon">❓</span>

            Generate Questions

        </button>


        <!-- Generate MCQs -->

        <button class="ai-btn">

            <span class="icon">☑️</span>

            Generate MCQs

        </button>


        <!-- Explain -->

        <button class="ai-btn">

            <span class="icon">💡</span>

            Explain Simply

        </button>


        <!-- Lesson Plan -->

        <button class="ai-btn">

            <span class="icon">📚</span>

            Create Lesson Plan

        </button>


        <!-- Translate -->

        <button class="ai-btn">

            <span class="icon">🌐</span>

            Translate Document

        </button>

    </div>

</div>


<!-- =====================================================
     STRUCTURED DATA
     ===================================================== -->

<div class="structured-card">


    <% if (isStructured && columns != null && rows != null) { %>


        <!-- =========================
             STRUCTURED HEADER
             ========================= -->

        <div class="structured-header">

            <h2>
                📊 Structured Data
            </h2>

            <span class="structured-type">

                <%= structuredType != null
                        ? structuredType
                        : "Structured Data" %>

            </span>

        </div>


        <!-- =================================================
             FILTER SECTION
             ================================================= -->

        <div class="filter-section">

            <div class="filter-title">
                🔎 Search & Filter Records
            </div>

            <div
                class="filter-row"
                id="filterContainer"
            >

                <!-- Search is always present -->

                <div class="search-box">

                    <input
                        type="text"
                        id="tableSearch"
                        class="search-input"
                        placeholder="🔍 Search records..."
                        autocomplete="off"
                    >

                </div>

                <!-- Dynamic filters are added here by JavaScript -->

            </div>

        </div>


        <!-- =========================
             RECORD COUNT
             ========================= -->

        <div
            class="record-count"
            id="recordCount"
        >
            Showing <%= rows.length() %>
            of <%= rows.length() %>
            records
        </div>


        <!-- =========================
             TABLE
             ========================= -->

        <div class="table-wrapper">

            <table
                class="data-table"
                id="structuredTable"
            >

                <thead>

                    <tr>

                        <%

                            for (int i = 0;
                                 i < columns.length();
                                 i++) {

                        %>

                            <th>
                                <%= columns.optString(i) %>
                            </th>

                        <%

                            }

                        %>

                    </tr>

                </thead>


                <tbody id="tableBody">


                    <%

                        for (int i = 0;
                             i < rows.length();
                             i++) {

                            JSONObject row =
                                    rows.optJSONObject(i);

                    %>


                        <tr class="data-row">


                            <%

                                for (int j = 0;
                                     j < columns.length();
                                     j++) {

                                    String columnName =
                                            columns.optString(j);

                                    String value =
                                            row != null
                                            ? row.optString(
                                                    columnName,
                                                    ""
                                              )
                                            : "";

                            %>


                                <td>
                                    <%= value %>
                                </td>


                            <%

                                }

                            %>


                        </tr>


                    <%

                        }

                    %>


                    <!-- No results -->

                    <tr
                        id="noResultsRow"
                        class="no-results-row"
                    >

                        <td
                            colspan="<%= columns.length() %>"
                        >

                            🔍 No matching records found.

                        </td>

                    </tr>

                </tbody>

            </table>

        </div>


        <!-- =================================================
             ASK AI ABOUT TABLE
             ================================================= -->

        <div class="ask-ai">

            <h3>
                🤖 Ask AI about this table
            </h3>


            <div class="ask-ai-description">

                Ask questions about the records,
                values, scores, percentages or other
                information in this table.

            </div>


            <form
                action="/teacher/ai/ask"
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
                    placeholder="Ask something about these records..."
                    value="<%= question != null ? question : "" %>"
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
                    Who scored the highest?
                </span>

                <span class="example">
                    What is the average score?
                </span>

                <span class="example">
                    Show students from 10-A.
                </span>

                <span class="example">
                    Who scored below 80?
                </span>

            </div>


            <!-- AI Answer -->

            <% if (answer != null && !answer.isBlank()) { %>


                <div class="answer-card">

                    <div class="answer-title">
                        🤖 AI Answer
                    </div>


                    <% if (question != null) { %>

                        <div class="question-display">

                            <strong>Question:</strong>

                            <%= question %>

                        </div>

                    <% } %>


                    <div class="answer-text">

                        <%= answer %>

                    </div>

                </div>


            <% } %>


            <!-- Error -->

            <% if (error != null && !error.isBlank()) { %>


                <div class="error-card">

                    ⚠️ <%= error %>

                </div>


            <% } %>


        </div>


    <% } else { %>


        <!-- =========================
             NO STRUCTURED DATA
             ========================= -->

        <div class="not-structured">

            <div class="not-structured-icon">
                📄
            </div>

            <h2>
                No structured data detected
            </h2>

            <p>
                AI did not detect a table or
                record-based structure in this document.
            </p>

            <p>
                You can still use the document
                AI actions above.
            </p>

        </div>


    <% } %>


</div>


<!-- =========================
     BACK
     ========================= -->

<a
    class="back"
    href="/teacher/documents"
>

    ← Back to My Documents

</a>
```

</div>

<!-- =========================================================
     DYNAMIC TABLE FILTER JAVASCRIPT
     ========================================================= -->

<% if (isStructured && columns != null && rows != null) { %>

<script>

document.addEventListener("DOMContentLoaded", function () {


    /*
     * ========================================================
     * GET TABLE ELEMENTS
     * ========================================================
     */

    const table =
        document.getElementById("structuredTable");

    const tableBody =
        document.getElementById("tableBody");

    const searchInput =
        document.getElementById("tableSearch");

    const filterContainer =
        document.getElementById("filterContainer");

    const recordCount =
        document.getElementById("recordCount");

    const noResultsRow =
        document.getElementById("noResultsRow");


    /*
     * ========================================================
     * GET HEADER NAMES
     * ========================================================
     */

    const headers =
        Array.from(
            table.querySelectorAll("thead th")
        ).map(function (header) {

            return header.textContent
                .trim();

        });


    /*
     * ========================================================
     * GET DATA ROWS
     *
     * We deliberately exclude the "no results" row.
     * ========================================================
     */

    const dataRows =
        Array.from(
            tableBody.querySelectorAll(
                "tr.data-row"
            )
        );


    /*
     * ========================================================
     * CREATE DYNAMIC FILTERS
     *
     * We look at the actual table data.
     *
     * A filter is created when:
     *
     * - column has multiple values
     * - column has a reasonable number of unique values
     * - column looks like categorical/text data
     *
     * This means we do NOT hard-code "Class".
     * ========================================================
     */

    headers.forEach(function (headerName, columnIndex) {


        const values =
            dataRows.map(function (row) {

                const cell =
                    row.children[columnIndex];

                return cell
                    ? cell.textContent.trim()
                    : "";

            }).filter(function (value) {

                return value !== "";

            });


        /*
         * Remove duplicate values.
         */

        const uniqueValues =
            [...new Set(
                values.map(function (value) {
                    return value.toLowerCase();
                })
            )];


        /*
         * Need at least two different values
         * to make a useful filter.
         */

        if (uniqueValues.length < 2) {
            return;
        }


        /*
         * Avoid huge dropdowns.
         *
         * Example:
         * 500 different student names
         *
         * should be searched using the search box,
         * not displayed as a 500-item dropdown.
         */

        if (uniqueValues.length > 20) {
            return;
        }


        /*
         * Check whether the column looks numeric.
         *
         * Numeric columns such as:
         *
         * ID
         * Score
         * Percentage
         *
         * are better handled by search for now.
         */

        const numericValues =
            values.filter(function (value) {

                const cleaned =
                    value
                        .replace(/[%,$₹]/g, "")
                        .replace(/,/g, "")
                        .trim();

                return cleaned !== ""
                    && !isNaN(cleaned);

            });


        const numericRatio =
            values.length > 0
                ? numericValues.length / values.length
                : 0;


        /*
         * Skip mostly numeric columns.
         */

        if (numericRatio >= 0.8) {
            return;
        }


        /*
         * Create select element.
         */

        const select =
            document.createElement("select");

        select.className =
            "dynamic-filter";


        select.setAttribute(
            "data-column-index",
            columnIndex
        );


        /*
         * "All" option.
         */

        const allOption =
            document.createElement("option");

        allOption.value = "";

        allOption.textContent =
            "All " + headerName;

        select.appendChild(
            allOption
        );


        /*
         * Sort values naturally.
         */

        const sortedValues =
            [...new Set(values)]
                .sort(function (a, b) {

                    return a.localeCompare(
                        b,
                        undefined,
                        {
                            numeric: true,
                            sensitivity: "base"
                        }
                    );

                });


        /*
         * Create options.
         */

        sortedValues.forEach(function (value) {

            const option =
                document.createElement("option");

            option.value =
                value.toLowerCase();

            option.textContent =
                value;

            select.appendChild(
                option
            );

        });


        /*
         * When filter changes,
         * re-run filtering.
         */

        select.addEventListener(
            "change",
            applyFilters
        );


        /*
         * Add filter to UI.
         */

        filterContainer.appendChild(
            select
        );

    });


    /*
     * ========================================================
     * RESET BUTTON
     * ========================================================
     */

    const resetButton =
        document.createElement("button");

    resetButton.type =
        "button";

    resetButton.className =
        "reset-button";

    resetButton.textContent =
        "Reset Filters";

    resetButton.addEventListener(
        "click",
        function () {

            /*
             * Clear search.
             */

            searchInput.value = "";


            /*
             * Reset every dynamic filter.
             */

            const filters =
                filterContainer.querySelectorAll(
                    ".dynamic-filter"
                );

            filters.forEach(function (filter) {

                filter.value = "";

            });


            /*
             * Show everything again.
             */

            applyFilters();

        }
    );


    filterContainer.appendChild(
        resetButton
    );


    /*
     * ========================================================
     * SEARCH LISTENER
     * ========================================================
     */

    searchInput.addEventListener(
        "input",
        applyFilters
    );


    /*
     * ========================================================
     * APPLY FILTERS
     * ========================================================
     */

    function applyFilters() {


        /*
         * Get search text.
         */

        const searchText =
            searchInput.value
                .trim()
                .toLowerCase();


        /*
         * Get all active dropdown filters.
         */

        const activeFilters =
            Array.from(
                filterContainer.querySelectorAll(
                    ".dynamic-filter"
                )
            ).map(function (filter) {

                return {
                    columnIndex:
                        parseInt(
                            filter.getAttribute(
                                "data-column-index"
                            )
                        ),

                    value:
                        filter.value
                };

            }).filter(function (filter) {

                return filter.value !== "";

            });


        /*
         * Number of visible records.
         */

        let visibleCount = 0;


        /*
         * Check every table row.
         */

        dataRows.forEach(function (row) {


            /*
             * Get all cell values.
             */

            const cellValues =
                Array.from(
                    row.children
                ).map(function (cell) {

                    return cell.textContent
                        .trim()
                        .toLowerCase();

                });


            /*
             * ================================================
             * SEARCH MATCH
             * ================================================
             *
             * Search checks the complete row.
             *
             * Example:
             *
             * Rahul
             * 101
             * 10-A
             *
             * all work.
             */

            const rowText =
                cellValues.join(" ");


            const searchMatches =
                searchText === ""
                    || rowText.includes(
                        searchText
                    );


            /*
             * ================================================
             * FILTER MATCH
             * ================================================
             *
             * Every active filter must match.
             *
             * Therefore filters use AND logic.
             */

            const filtersMatch =
                activeFilters.every(
                    function (filter) {

                        const cellValue =
                            cellValues[
                                filter.columnIndex
                            ] || "";

                        return cellValue ===
                            filter.value;

                    }
                );


            /*
             * Final result:
             *
             * Search AND filters
             */

            const shouldShow =
                searchMatches
                && filtersMatch;


            /*
             * Show / hide row.
             */

            row.style.display =
                shouldShow
                    ? ""
                    : "none";


            if (shouldShow) {
                visibleCount++;
            }

        });


        /*
         * ====================================================
         * UPDATE RECORD COUNT
         * ====================================================
         */

        const totalCount =
            dataRows.length;


        recordCount.textContent =
            "Showing "
            + visibleCount
            + " of "
            + totalCount
            + " records";


        /*
         * ====================================================
         * NO RESULTS
         * ====================================================
         */

        if (visibleCount === 0) {

            noResultsRow.style.display =
                "table-row";

        } else {

            noResultsRow.style.display =
                "none";

        }

    }


    /*
     * ========================================================
     * INITIAL STATE
     * ========================================================
     */

    applyFilters();

});

</script>

<% } %>

</body>

</html>
