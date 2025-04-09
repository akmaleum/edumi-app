<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Database credentials
$host = "localhost";
$username = "root";
$password = "";
$database = "edumi_db";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['username']) || !isset($data['password'])) {
        echo json_encode(["error" => "Username and password are required"]);
        exit;
    }

    $username = $data['username'];
    $password = $data['password'];

    $sql = "SELECT id, username, password FROM auth_user WHERE username = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        if ($password === $row['password']) {
            echo json_encode([
                "message" => "Login successful",
                "userId" => $row["id"],
                "username" => $row["username"]
            ]);
        } else {
            echo json_encode(["error" => "Invalid password"]);
        }
    } else {
        echo json_encode(["error" => "User not found"]);
    }

    $stmt->close();
} else {
    echo json_encode(["error" => "Method not allowed"]);
}

$conn->close();
?>