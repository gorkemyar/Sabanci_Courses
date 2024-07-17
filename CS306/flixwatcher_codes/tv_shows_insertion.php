<?php

include "config.php";

 
 if (isset($_POST['Show_ID'])){

    $show_id = $_POST['Show_ID'];
    $seasons_num = $_POST['Season_num'];

    $sql_statement = "INSERT INTO TV_Shows(Seasons_num,Shows_ID) 
                        VALUES ('$seasons_num', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>