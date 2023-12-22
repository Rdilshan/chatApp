<?php
$sname= "localhost";
$uname= "asialdlk_company";
$password = "Asia.lk@sahan";
$db_name = "asialdlk_pos_2";

$conn = mysqli_connect($sname, $uname, $password, $db_name);

if (!$conn) {
	echo "Connection failed!";
 //exit();
}

?>