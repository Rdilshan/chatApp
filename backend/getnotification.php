<?php 
 require_once 'db_conn.php';

 $idnumber = $_POST['idnumber'];
 $mobilenumber = $_POST['mobilenumber'];
 $datafinala = array();
 $shopname = ''; 
$sql = "SELECT shopID,id,points FROM customers WHERE mobile='$mobilenumber' AND nic='$idnumber'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    $shopid = $row['shopID'];
    $id = $row['id'];
    $clamCoin = $row['points'];

    $sql2 = "SELECT * FROM chat WHERE shopID='$shopid' AND recieverID='$id' AND is_approved='1' AND status='0' ORDER BY id DESC LIMIT 1";
    $result2 = $conn->query($sql2);
    
    if ($result2->num_rows > 0) {
        while($row2 = $result2->fetch_assoc()) {
        

        $sql3="SELECT * FROM `shop` WHERE id='$shopid'";
        $result3 = $conn->query($sql3);
        while($row3 = $result3->fetch_assoc()) {
            $shopname = $row3['shop_name'];
        }

        $data = array();
        
        $data['shopname'] =  $shopname;
        $data['msg'] =  $row2['message'];

    

        $datafinala[] = $data;
    }

    } else {
        // echo "no msg ..........";
        // echo $sql;
    }
    
  }
} else {
//   echo "0";
}

echo json_encode($datafinala);

?>