<?php
error_reporting(E_ALL & ~E_DEPRECATED);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Ensure no output before JSON
ob_start();

include 'config.php';

$sql = "SELECT id, username, first_name, last_name, email, date_joined FROM auth_user WHERE is_active = 1";
$result = mysqli_query($conn, $sql);

if ($result) {
    $users = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $users[] = $row;
    }
    $json = json_encode($users, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    if ($json === false) {
        http_response_code(500);
        echo json_encode(["error" => "JSON encoding failed: " . json_last_error_msg()]);
    } else {
        ob_end_clean();
        echo $json;
    }
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to fetch users: " . mysqli_error($conn)]);
}

mysqli_close($conn);
?>