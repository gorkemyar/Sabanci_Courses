<?php

include "config.php";

 
 if (isset($_POST['Show_ID'])){

    $Producer_id = $_POST['Producer_ID'];
    $show_id = $_POST['Show_ID'];

    $sql_statement = "INSERT INTO Made_By(Shows_ID, Producer_ID) 
                        VALUES ('$show_id', '$Producer_id')";
    $result = mysqli_query($db, $sql_statement);

    header("Location: index.php");

 }

 else{
    echo "The form is not set.";
 }

?>