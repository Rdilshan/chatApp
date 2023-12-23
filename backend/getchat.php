<?php 
 require_once 'db_conn.php';

 $shopID = $_POST['shopID'];
 $recieverID = $_POST['recieverID'];
 $datafinala = array();


$sql = "SELECT * FROM chat WHERE shopID='$shopID' AND recieverID='$recieverID' AND is_approved='1' ORDER BY add_date";

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

$sql2 = "UPDATE chat SET status = '1' WHERE shopID='$shopID' AND recieverID='$recieverID' AND is_approved='1' AND status='0'";
$result2 = $conn->query($sql2);

if ($result2) {
    
} 


?>