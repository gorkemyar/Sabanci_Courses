<?php

include "config.php";

 
 if (isset($_POST['Producer_ID'])){

    $Producer_id = $_POST['Producer_ID'];
    $director_id = $_POST['Director_ID'];

    $sql_statement = "INSERT INTO Sponsors_Director(Producer_ID, Director_ID) 
                        VALUES ('$Producer_id', '$director_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>