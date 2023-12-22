<?php 
 require_once 'db_conn.php';

 $shopID = $_POST['shopID'];
 $recieverID = $_POST['recieverID'];
 $datafinala = array();


$sql = "SELECT * FROM chat WHERE shopID='$shopID' AND recieverID='$recieverID' AND is_approved='1'";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    $data = array();

    $data["messageContent"] = $row['message'];
    $data["messageType"] = ($row['document'] == '')?"0":"1";
    $data["mesMsg"] = $row['document'];

    $datafinala[] = $data;

  }
} else {
//   echo "0";
}
echo json_encode($datafinala);


?>