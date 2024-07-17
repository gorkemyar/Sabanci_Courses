<?php

include "config.php";

 
 if (isset($_POST['Shows_ID'])){

    $show_id = $_POST['Shows_ID'];
    $genre_id = $_POST['Genre_ID'];

    $sql_statement = "INSERT INTO Has(Shows_ID, Genre_ID) 
                        VALUES ('$show_id', '$genre_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>