<?php

include "config.php";

 
 if (isset($_POST['Actress_Name'])){

    $actress_name = $_POST['Actress_Name'];

    $sql_statement = "INSERT INTO Actresses(Actress_Name) 
                        VALUES ('$actress_name')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>