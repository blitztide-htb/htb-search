<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./styles.css">
    <link href='https://fonts.googleapis.com/css?family=Lato:400,700' rel='stylesheet' type='text/css'>
    <title>HTB Search</title>
</head>
<body>
    <div class="content">
        <h1> Add Item to HTB Search </h1>
        <form action="./add_bookmark.php" method="post">
            <label for="shortcode">Shortcode for search </label><br/>
            <input type="text" id="shortcode" name="shortcode"></input><br/>
            <label for="uri">URL to shorten</label><br/>
            <input type="text" id="uri" name="uri"></input></br>
            <input type="submit" value="Add URL"/>
        </form>
    </div>
</body>
</html>
