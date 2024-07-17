<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $start = $_POST['Start_Date'];
    $end = $_POST['End_Date'];
    $show_id = $_POST['Shows_ID'];

    $sql_statement = "INSERT INTO Netflix_Availability(Start_Date, End_Date, Shows_ID) 
                        VALUES ('$start', '$end', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>