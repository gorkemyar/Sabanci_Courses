<?php

include "config.php";

 
 if (isset($_POST['Director_Name'])){

    $director_name = $_POST['Director_Name'];

    $sql_statement = "INSERT INTO Directors(Director_Name) 
                        VALUES ('$director_name')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>