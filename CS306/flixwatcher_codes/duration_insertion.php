<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $duration = $_POST['Duration_time'];
    $show_id = $_POST['Shows_ID'];

    $sql_statement = "INSERT INTO Duration(Duration_time, Shows_ID) 
                        VALUES ('$duration', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>