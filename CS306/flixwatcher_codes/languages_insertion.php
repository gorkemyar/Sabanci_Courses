<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $subtitle = $_POST['Subtitle'];
    $voice = $_POST['Voice'];
    $show_id = $_POST['Shows_ID'];

    $sql_statement = "INSERT INTO Languages(Subtitle, Voice, Shows_ID) 
                        VALUES ('$subtitle', '$voice', '$show_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>