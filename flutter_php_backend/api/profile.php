<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, PUT, OPTIONS");
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
    // Fetch user profile
    if (!isset($_GET['userId'])) {
        echo json_encode(["error" => "User ID is required"]);
        exit;
    }

    $userId = $_GET['userId'];
    $sql = "SELECT first_name, last_name, username, email, telephone FROM auth_user WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode($row);
    } else {
        echo json_encode(["error" => "User not found"]);
    }

    $stmt->close();
} elseif ($method === 'PUT') {
    // Update user profile
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data['userId']) || !isset($data['first_name']) || !isset($data['last_name']) || 
        !isset($data['username']) || !isset($data['email']) || !isset($data['telephone'])) {
        echo json_encode(["error" => "All fields are required"]);
        exit;
    }

    $userId = $data['userId'];
    $first_name = $data['first_name'];
    $last_name = $data['last_name'];
    $username = $data['username'];
    $email = $data['email'];
    $telephone = $data['telephone'];

    // Check if the new username or email is already taken by another user
    $checkStmt = $conn->prepare("SELECT id FROM auth_user WHERE (username = ? OR email = ?) AND id != ?");
    $checkStmt->bind_param("ssi", $username, $email, $userId);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();

    if ($checkResult->num_rows > 0) {
        echo json_encode(["error" => "Username or email already taken"]);
        $checkStmt->close();
        $conn->close();
        exit;
    }
    $checkStmt->close();

    // Update user
    $sql = "UPDATE auth_user SET first_name = ?, last_name = ?, username = ?, email = ?, telephone = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssi", $first_name, $last_name, $username, $email, $telephone, $userId);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Profile updated successfully"]);
    } else {
        echo json_encode(["error" => "Failed to update profile: " . $conn->error]);
    }

    $stmt->close();
} else {
    echo json_encode(["error" => "Method not allowed"]);
}

$conn->close();
?>