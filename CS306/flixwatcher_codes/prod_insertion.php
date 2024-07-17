<?php

include "config.php";

 
 if (isset($_POST['Producer_Name'])){

    $producerName = $_POST['Producer_Name'];

    $sql_statement = "INSERT INTO Producers(Producer_Name) 
                        VALUES ('$producerName')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>