<?php

include "config.php";

 
 if (isset($_POST['Actor_Name'])){

    $actor_name = $_POST['Actor_Name'];

    $sql_statement = "INSERT INTO Actors(Actor_Name) 
                        VALUES ('$actor_name')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>
