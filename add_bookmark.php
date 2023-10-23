<?php
try {
        $redis = new Redis([
                'host' => '/var/run/redis/redis.sock',
                'port' => -1
        ]);
} catch (Exception $e) {
        echo "ERROR in Redis";
        die();
}
$shortcode = $_POST["shortcode"];
$uri = $_POST["uri"];
$redis->set($shortcode, $uri);
?>
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
        <h1> Item Added! </h1>
    </div>
</body>
</html>
