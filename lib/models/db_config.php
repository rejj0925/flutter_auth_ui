<?php

$host = 'localhost';
$user = 'root';
$password = '';
$database = 'bb88';

$conn = mysqli_connect($host, $user, $password, $database);
if ($conn->connect_error) {
    die('connection failed' . $conn->connect_error);
}
?>