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

    $sql2 = "SELECT * FROM chat WHERE shopID='$shopid' AND recieverID='$id' AND is_approved='1' ORDER BY id DESC LIMIT 1";
    $result2 = $conn->query($sql2);
    
    if ($result2->num_rows > 0) {
        while($row2 = $result2->fetch_assoc()) {
        

        $sql3="SELECT * FROM `shop` WHERE id='$shopid'";
        $result3 = $conn->query($sql3);
        while($row3 = $result3->fetch_assoc()) {
            $shopname = $row3['shop_name'];
        }
        $data = array();
            
        $data["id"] = $shopid;
        $data['recieverID']= $row2['recieverID'];
        $data["name"] = $shopname;
        $data["messageText"] =  $row2['message'];
        $data["imageURL"] = "https://randomuser.me/api/portraits/men/5.jpg";
        $data["clamCoin"] = $clamCoin;

        $dateString = $row2['add_date'];
        $dateTime = new DateTime($dateString);
        $isToday = $dateTime->format('Y-m-d') === (new DateTime())->format('Y-m-d');
        $formattedDate = $dateTime->format('d M');
        if ($isToday) {
            $currentDateTime = new DateTime();
            $interval = $currentDateTime->diff($dateTime);
            $hoursElapsed = $interval->h + ($interval->days * 24);
            $data["time"] = "$formattedDate, $hoursElapsed hours ago";
        } else {
            $data["time"] = $formattedDate;
        }

        $datafinala[] = $data;
    }

    } else {
        // echo "no msg ..........";
        // echo $sql2;
    }
    
  }
} else {
//   echo "0";
}

echo json_encode($datafinala);

?>