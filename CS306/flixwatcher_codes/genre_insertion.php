<?php

include "config.php";

 
 if (isset($_POST['Genre_Name'])){

    $genre_name = $_POST['Genre_Name'];



    $sql_statement = "INSERT INTO Genre(Genre_Name) 
                        VALUES ('$genre_name')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>