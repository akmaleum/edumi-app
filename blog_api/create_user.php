<?php
error_reporting(E_ALL & ~E_DEPRECATED);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

ob_start();

include 'config.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['username']) || !isset($data['password']) || !isset($data['first_name']) || !isset($data['last_name']) || !isset($data['email'])) {
    http_response_code(400);
    ob_end_clean();
    echo json_encode(["error" => "All fields are required"]);
    exit();
}

$username = mysqli_real_escape_string($conn, $data['username']);
$password = $data['password']; // Plain text for now (hash in production)
$first_name = mysqli_real_escape_string($conn, $data['first_name']);
$last_name = mysqli_real_escape_string($conn, $data['last_name']);
$email = mysqli_real_escape_string($conn, $data['email']);

// Check for duplicate username or email
$check_sql = "SELECT id FROM auth_user WHERE username = '$username' OR email = '$email'";
$check_result = mysqli_query($conn, $check_sql);
if (mysqli_num_rows($check_result) > 0) {
    http_response_code(400);
    ob_end_clean();
    echo json_encode(["error" => "Username or email already exists"]);
    exit();
}

// Insert new user
$sql = "INSERT INTO auth_user (username, password, first_name, last_name, email, is_active, is_staff, is_superuser, date_joined) 
        VALUES ('$username', '$password', '$first_name', '$last_name', '$email', 1, 0, 0, NOW())";
if (mysqli_query($conn, $sql)) {
    $user_id = mysqli_insert_id($conn);
    ob_end_clean();
    echo json_encode(["id" => $user_id, "message" => "User created successfully"]);
} else {
    http_response_code(500);
    ob_end_clean();
    echo json_encode(["error" => "Failed to create user: " . mysqli_error($conn)]);
}

mysqli_close($conn);
?>