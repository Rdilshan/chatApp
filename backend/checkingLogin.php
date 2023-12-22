<?php 
 require_once 'db_conn.php';

 $idnumber = $_POST['idnumber'];
 $mobilenumber = $_POST['mobilenumber'];


$sql = "SELECT * FROM customers WHERE mobile='$mobilenumber' AND nic='$idnumber' LIMIT 1";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    echo json_encode($row);
    // echo $sql;
  }
} else {
  echo "0";
}


?>