<?php

include "config.php";

 
 if (isset($_POST['Producer_ID'])){

    $Producer_id = $_POST['Producer_ID'];
    $actor_id = $_POST['Actor_ID'];

    $sql_statement = "INSERT INTO Sponsors_Actor(Producer_ID, Actor_ID) 
                        VALUES ('$Producer_id', '$actor_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>