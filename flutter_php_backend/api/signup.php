<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
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

if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['first_name']) || !isset($data['last_name']) || !isset($data['username']) || 
        !isset($data['email']) || !isset($data['password']) || !isset($data['telephone'])) {
        echo json_encode(["error" => "All fields are required"]);
        exit;
    }

    $first_name = $data['first_name'];
    $last_name = $data['last_name'];
    $username = $data['username'];
    $email = $data['email'];
    $password = $data['password']; // For simplicity, plain text; in production, hash this
    $telephone = $data['telephone'];
    $date_joined = date("Y-m-d H:i:s");

    // Check if username or email already exists
    $checkStmt = $conn->prepare("SELECT id FROM auth_user WHERE username = ? OR email = ?");
    $checkStmt->bind_param("ss", $username, $email);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();

    if ($checkResult->num_rows > 0) {
        echo json_encode(["error" => "Username or email already exists"]);
        $checkStmt->close();
        $conn->close();
        exit;
    }
    $checkStmt->close();

    // Insert new user
    $sql = "INSERT INTO auth_user (first_name, last_name, username, email, password, date_joined, telephone) VALUES (?, ?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssss", $first_name, $last_name, $username, $email, $password, $date_joined, $telephone);

    if ($stmt->execute()) {
        echo json_encode(["message" => "User created successfully"]);
    } else {
        echo json_encode(["error" => "Failed to create user: " . $conn->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["error" => "Method not allowed"]);
}

$conn->close();
?>