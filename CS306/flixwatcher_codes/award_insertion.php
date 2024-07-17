<?php

include "config.php";

 
 if (isset($_POST['Award_Type'])){

    $award_type = $_POST['Award_Type'];
    
    $sql_statement = "INSERT INTO Award(Award_Type) 
                        VALUES ('$award_type')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>