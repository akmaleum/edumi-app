<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

$host = "localhost";
$username = "root";
$password = "";
$database = "edumi_db";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $sql = "SELECT id, title, content, created_at FROM blog_blogactivities WHERE is_published = 1 ORDER BY created_at DESC";
    $result = $conn->query($sql);

    $blogs = [];
    while ($row = $result->fetch_assoc()) {
        $blogs[] = [
            "id" => $row["id"],
            "title" => $row["title"],
            "content" => $row["content"],
            "createdAt" => date("c", strtotime($row["created_at"]))
        ];
    }

    echo json_encode($blogs);
} else {
    echo json_encode(["error" => "Method not allowed"]);
}

$conn->close();
?>