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

if (!isset($data['username']) || !isset($data['password'])) {
    http_response_code(400);
    echo json_encode(["error" => "Username and password are required"]);
    exit();
}

$username = mysqli_real_escape_string($conn, $data['username']);
$password = $data['password'];

// Fetch user
$sql = "SELECT id, password FROM auth_user WHERE username = '$username' AND is_active = 1";
$result = mysqli_query($conn, $sql);

if ($result && mysqli_num_rows($result) > 0) {
    $user = mysqli_fetch_assoc($result);
    // For simplicity, assuming password is plain text (not recommended for production)
    if ($password === $user['password']) {
        // Update last_login
        $last_login_sql = "UPDATE auth_user SET last_login = NOW() WHERE id = '{$user['id']}'";
        mysqli_query($conn, $last_login_sql);

        ob_end_clean();
        echo json_encode(["id" => $user['id'], "message" => "Login successful"]);
    } else {
        http_response_code(401);
        ob_end_clean();
        echo json_encode(["error" => "Invalid credentials"]);
    }
} else {
    http_response_code(401);
    ob_end_clean();
    echo json_encode(["error" => "Invalid credentials"]);
}

mysqli_close($conn);
?>