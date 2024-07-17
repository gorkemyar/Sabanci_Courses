<?php

include "config.php";

 
 if (isset($_POST['Producer_ID'])){

    $Producer_id = $_POST['Producer_ID'];
    $actress_id = $_POST['Actress_ID'];

    $sql_statement = "INSERT INTO Sponsors_Actress(Producer_ID, Actress_ID) 
                        VALUES ('$Producer_id', '$actress_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>