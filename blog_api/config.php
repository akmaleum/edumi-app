<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = "127.0.0.1"; // Localhost via SSH tunnel
$username = "edumi";
$password = "#EDUMi!5197@2025";
$db_name = "edumi\$db";

$conn = mysqli_connect($host, $username, $password, $db_name);

if (!$conn) {
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed: " . mysqli_connect_error()]);
    exit();
}

mysqli_set_charset($conn, "utf8mb4");
?>